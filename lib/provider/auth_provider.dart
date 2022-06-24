import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:golden_ager/main.dart';
import 'package:golden_ager/models/medicine.dart';
import 'package:golden_ager/models/user.dart';
import 'package:golden_ager/notifications.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:golden_ager/screen/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../core/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/util/shared_prefs_helper.dart';

import '../core/error/exceptions.dart';
import '../models/notification.dart';
import '../screen/home/tabs_screen.dart';

class AuthProvider extends ChangeNotifier implements ReassembleHandler {
  User? _firebasecurrentUser;

  User? get firebasecurrentUser => _firebasecurrentUser;

  String? _userType;

  String? get userType => _userType;

  Future<void> changeUserType(
      {required String newUserType, String? PatientId}) async {
    if (newUserType == "patient") {
      final patientData =
          await FirebaseFirestore.instance.doc("users/$PatientId").get();
      _patient = Patient.fromMap(patientData.data() as Map<String, dynamic>);
      _userType = newUserType;
      notifyListeners();
    } else {
      _patient = null;
      _userType = newUserType;
    }
  }

  Patient? _patient;

  Patient? get patient => _patient;
  Doctor? _doctor;

  Doctor? get doctor => _doctor;
  Mentor? _mentor;

  Mentor? get mentor => _mentor;

  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Constant.showToast(
          message: "Location services are disabled", color: Colors.red);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Constant.showToast(
            message: "Location permissions are denied", color: Colors.red);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Constant.showToast(
          message:
              "Location permissions are permanently denied, we cannot get your location",
          color: Colors.red);
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _firebasecurrentUser = FirebaseAuth.instance.currentUser!;
      final userUUID = _firebasecurrentUser!.uid.toString();
      final location = await _determinePosition(context);
      final latitude = location.latitude;
      final longitude = location.longitude;
      print('latitude is '+latitude.toString() +'longitude is '+ longitude.toString());
      FirebaseFirestore.instance.doc("users/$userUUID").update({
        "fcm_token": await FirebaseMessaging.instance.getToken(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });
      await getUserData();

      await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
      await SharedPrefsHelper.saveData(
          key: 'user_data',
          value: json.encode({'email': email, 'password': password}));
      Constant.navigateTo(routeName: const TabsScreen(), context: context);
    } on FirebaseAuthException catch (error) {
      Constant.showToast(
        message: error.message.toString(),
        color: Colors.red,
      );
    }

    notifyListeners();
  }

  Future<void> getUserData() async {
    final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .get();
    if (userData.data() != null) {
      _userType = userData.data()!['user_type'];
      if (_userType == 'patient') {
        _patient = Patient.fromMap(userData.data()!);
      } else if (_userType == 'doctor') {
        _doctor = Doctor.fromMap(userData.data()!);
      } else if (_userType == 'mentor') {
        _mentor = Mentor.fromMap(userData.data()!);
      }
    }
  }

  File? image;
  String? imageUrl;

  Future pickImage({
    required ImageSource imageSource,
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      notifyListeners();
    } on PlatformException {
      print('failed to pick image');
    }
    notifyListeners();
  }

//* Try To login
  bool _isLoadingTryToLogin = true;

  bool get isLoadingTryToLogin => _isLoadingTryToLogin;

  Future<void> tryToLogin({required BuildContext context}) async {
    final getUserData = await SharedPrefsHelper.getData(key: 'user_data');
    if (getUserData == null) {
      await Future.delayed(const Duration(seconds: 2));
      Constant.navigateToRep(routeName: const LoginScreen(), context: context);
    } else {
      final data = json.decode(getUserData);
      if (data != null) {
        await login(
            email: data['email'], password: data['password'], context: context);
        _isLoadingTryToLogin = false;
        notifyListeners();
      }
    }
  }

  bool isLoadingSignUp = false;

  toggleLoading() {
    isLoadingSignUp = !isLoadingSignUp;
    notifyListeners();
  }

  Future<void> signUp(
      {required String name,
      required String phone,
      required String email,
      required String password,
      required String age,
       String? desc,
      required String gender,
      required String userType,
       List<String>? medicalHistory,
      required BuildContext context,
      String? specialty}) async {
    if (image == null) {
      Constant.showToast(
        message: 'Please select an image',
        color: Colors.red,
      );
      return;
    } else {
      try {
        toggleLoading();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final userUUID = FirebaseAuth.instance.currentUser!.uid.toString();
        await SharedPrefsHelper.saveData(key: 'userUUID', value: userUUID);
        await SharedPrefsHelper.saveData(
            key: 'user_data',
            value: json.encode({'email': email, "password": password}));
        String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child(imageFileName);
        UploadTask uploadTask = ref.putFile(image!);
        await uploadTask.then((res) async {
          await res.ref.getDownloadURL().then((url) {
            imageUrl = url;
          });
        });
        final location = await _determinePosition(context);
        final latitude = location.latitude;
        final longitude = location.longitude;
        await FirebaseFirestore.instance.collection('users').doc(userUUID).set({
          "image": imageUrl,
          "uid": userUUID,
          "age": age,
          "description": desc?? '',
          "email": email,
          "feeling": '',
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "gender": gender,
          "name": name,
          "phone": phone,
          'user_type': userType,
          'medicalHistory': medicalHistory ?? [],
          "fcm_token": await FirebaseMessaging.instance.getToken(),
          "specialty": specialty ?? "",
          "patients": [],
          "mentor": [],
          "notification": [],
          'reports': [],
          'medicine': [],
          'contacts': [],
          'doctors': []
        });
        await getUserData();
        Constant.navigateToRep(routeName: const RedierctScreen(), context: context);
      } on FirebaseAuthException catch (error) {
        Constant.showToast(
          message: error.message.toString(),
          color: Colors.red,
        );

        toggleLoading();
      }

      toggleLoading();
    }
  }

  Future<void> logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Constant.navigateToRep(routeName: const LoginScreen(), context: context);
    await SharedPrefsHelper.clearData();
    _userType = null;
    _doctor = null;
    _patient = null;
    _mentor = null;
    notifyListeners();
  }

  bool isLoadingAddMedicine = false;

  toggleAddMedicineLoading() {
    isLoadingAddMedicine = !isLoadingAddMedicine;
    notifyListeners();
  }

// make notification Local for every dose
  Future<bool> addMedicine(
      {required String name,
      required String pillDosage,
      required int shape,
      required int color,
      required int dose,
      required DateTime startAt,
      required DateTime endAt}) async {
    toggleAddMedicineLoading();
    await FirebaseFirestore.instance.doc('users/${_patient!.uid}').get();
    final Medicine medicine = Medicine(
        name: name,
        pillDosage: pillDosage,
        shape: shape,
        color: color,
        dose: dose,
        startAt: startAt,
        endAt: endAt);
    Map<String, Map<String, bool>> isDone = {};
    final int hours = 24 ~/ medicine.dose;
    int condition = medicine.endAt.difference(medicine.startAt).inDays;
    for (var i = 0; i < condition; i++) {
      // day.day
      final day = medicine.startAt.add(Duration(days: i));
      isDone[DateFormat('yMd').format(day)] = {};
      for (var j = 0; j < medicine.dose; j++) {
        isDone[DateFormat('yMd').format(day)]!
            .addAll({(hours * j).toString(): false});
        localNotifyManager.scheduleNotification(
            scheduleTime: DateTime(hours * j));
      }
    }
    medicine.isDone = isDone;
    _patient!.medicines.add(medicine);
    await FirebaseFirestore.instance.doc('users/${_patient!.uid}').update(
        {"medicines": _patient!.medicines.map((e) => e.toMap()).toList()});
    getDisplayMedcines(selectedDate);
    getTodayActivity();
    toggleAddMedicineLoading();

    return true;
  }

  Future<void> toggleTakeMedicine(
      Medicine medicine, String key, context) async {
    patient!.medicines[patient!.medicines.indexOf(medicine)]
        .isDone![DateFormat('yMd').format(DateTime.now())]![key] = true;
    getTodayActivity();
    FirebaseFirestore.instance.doc('users/${_patient!.uid}').update({
      "medicines": _patient!.medicines.map((e) => e.toMap()).toList()
    }).then((value) async {
      final AppNotification notification = AppNotification(
          senderName: patient!.name,
          senderToken: patient!.mentor[0].fcmToken,
          body:
              "Reminder : ${patient!.name} has taken his dose at ${DateFormat('yMd').format(DateTime.now())}",
          category: "request",
          title: "Request",
          timeStamp: DateTime.now());
      await sendNotification(
          notification: notification, reciverID: patient!.mentor[0].uid);
    });
  }

  Future<void> sendNotification(
      {required AppNotification notification,
      required String reciverID}) async {
    await sendPushMessage(notification: notification);
    await FirebaseFirestore.instance
        .collection("notifications/$reciverID/notifications")
        .add(notification.toMap());
  }

  Future<void> sendPushMessage({required AppNotification notification}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA1qlt7Qg:APA91bGGGR-c_wv3L7BPGby8TqBDX6dgJK3WT455n3zNRj5tOS68ReSQKtsO02q25cKKFKim4m7Vp_JlkZAYSQfX176WZ5y4JIlHl3aMtdbJ87v9MDiPPi_wcqg7ZM_isFYSutu0GHnI'
        },
        body: jsonEncode({
          'to': notification.senderToken,
          'data': {
            'via': 'FlutterFire Cloud Messaging!!!',
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "category": notification.category,
          },
          'notification': {
            'title': notification.title,
            'body': notification.body,
            "sound": "default"
          },
        }),
      );
    } catch (e) {
      throw ServerException();
    }
  }

  List<Medicine> displayMedcines = [];
  DateTime selectedDate = DateTime.now();

  void getDisplayMedcines(DateTime date) {
    selectedDate = date;
    notifyListeners();
    displayMedcines = _patient!.medicines
        .where((element) =>
            element.startAt.isBefore(date) && element.endAt.isAfter(date))
        .toList();
    notifyListeners();
  }

  List todayActivity = [1, 1, 1];

  void getTodayActivity() {
    int max = 0;
    int done = 0;
    int doneForOneMedicine = 0;
    displayMedcines = patient!.medicines
        .where((element) =>
            element.startAt.isBefore(DateTime.now()) &&
            element.endAt.isAfter(DateTime.now()))
        .toList();
    for (Medicine medicine in displayMedcines) {
      final int hours = 24 ~/ medicine.dose;
      max++;
      for (var j = 0; j < medicine.dose; j++) {
        if (medicine.isDone![DateFormat('yMd').format(DateTime.now())]![
            (hours * j).toString()] as bool) {
          doneForOneMedicine++;
        }
      }
      if (doneForOneMedicine == medicine.dose) {
        done++;
      }
      doneForOneMedicine = 0;
    }
    todayActivity = [done / max, done, max];
    notifyListeners();
  }

  Future<void> updateUserLocal(
      {Patient? patient, Doctor? doctor, Mentor? mentor}) async {
    _patient = patient ?? _patient;
    _doctor = doctor ?? _doctor;
    _mentor = mentor ?? _mentor;
  }

  @override
  void reassemble() {}

// Send to patient
  Future<void> postReportForDoctor({
    required String patientID,
    required String patientFcm,
    required String from,
    required String to,
    required String medicalSpecialty,
    required String sampleName,
    required String description,
    required String problem,
    required BuildContext context,
  }) async {
    final doctorUUID = SharedPrefsHelper.getData(key: 'userUUID');
    await FirebaseFirestore.instance
        .collection('reports')
        .doc('$doctorUUID-$patientID')
        .collection('$doctorUUID-$patientID')
        .add(
      {
        'from': from,
        'to': to,
        'medicalSpecialty': medicalSpecialty,
        'sampleName': sampleName,
        'description': description,
        'problem': problem,
        'time': DateTime.now().toString(),
      },
    );
    final AppNotification notification = AppNotification(
        senderName: from,
        senderToken: patientFcm,
        body: "$from sends you a Report",
        category: "request",
        title: "Request",
        timeStamp: DateTime.now());
    await context
        .read<RequestsProvider>()
        .sendNotification(notification: notification, reciverID: patientID);
    Constant.navigateToRep(routeName: const TabsScreen(), context: context);
  }
}
