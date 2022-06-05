
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var initSetting;

  BehaviorSubject<ReceivedNotification> get didReceivedNotificationSubject =>
      BehaviorSubject<ReceivedNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  initializePlatform() {
    var initSettingAndroid =
        AndroidInitializationSettings('logo');
    var initSettingIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title!, body: body!, payload: payload!);
        didReceivedNotificationSubject.add(receivedNotification);
      },
    );
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceivedNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin!.initialize(initSetting,
        onSelectNotification: (String? payload) {
      onNotificationClick(payload);
    });
  }

  Future<void> repeatedNotification({required String body,required String payload,required RepeatInterval repeatInterval}) async {
    var androidChannel = AndroidNotificationDetails(
      'Channel_ID repeated',
      'Channel_Name repeated',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.periodicallyShow(
      0,
      '',
      body,
      repeatInterval,
      platformChannel,
      payload: payload,
    );
  }
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin!.cancelAll();
  }
  Future<void> scheduleNotification() async {
    var scheduleTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannel = AndroidNotificationDetails(
      'Channel_ID scheduled',
      'Channel_Name scheduled',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.schedule(
        1, 'title', 'body', scheduleTime, platformChannel,
        payload: 'new payload');
  }
  Future<void> showEveryDayAtATimeNotification({required String body, required Time time,required String payload}) async {
    var androidChannel = AndroidNotificationDetails(
      'Channel_ID daily',
      'Channel_Name daily',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.showDailyAtTime(
        1, '', body, time, platformChannel,
        payload: payload);
  }
  Future<void> showWeeklyAtDayAtTimeNotification({required String body, Day? day, Time? time}) async {
    var androidChannel = AndroidNotificationDetails(
      'Channel_ID Weekly',
      'Channel_Name Weekly',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(
        3, '', body, day!, time!, platformChannel,
        payload: 'new payload');
  }

}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();



class ReceivedNotification {
  final int id;

  final String title;

  final String body;

  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
