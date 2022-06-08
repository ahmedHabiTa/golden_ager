import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/features/chat/presentation/provider/chat_provider.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:golden_ager/provider/requests_provider.dart';
import 'package:golden_ager/screen/auth/login_screen.dart';
import 'package:golden_ager/screen/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'core/constant/cutome_page_transition.dart';
import 'features/chat/domain/entities/order_user.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/injection/injection_container.dart' as di;
import 'features/injection/injection_container.dart';
import 'core/util/shared_prefs_helper.dart';
import 'provider/auth_provider.dart';
import 'provider/home_provider.dart';
import 'screen/home/splash_screen.dart';
import 'screen/home/tabs_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var initialzationSettingsAndroid = AndroidInitializationSettings('logo');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            priority: Priority.max,
            enableLights: true,
            playSound: true,
          ),
        ));
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefsHelper.init();
  await di.init();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<RequestsProvider>(
            create: (_) => RequestsProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => sl<ChatProvider>())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomePageTransition(),
            TargetPlatform.iOS: CustomePageTransition()
          }),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              elevation: 0,
              color: Colors.white,
              iconTheme: IconThemeData(color: Constant.primaryColor)),
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: RedierctScreen(),
      ),
    );
  }
}

class RedierctScreen extends StatefulWidget {
  const RedierctScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RedierctScreen> createState() => _RedierctScreenState();
}

class _RedierctScreenState extends State<RedierctScreen> {
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid = AndroidInitializationSettings('logo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        final message = jsonDecode(payload!);
        if (message['category'] == "chat") {
          await Future.delayed(Duration.zero).then((value) async {
            await Constant.navigateTo(
                context: context,
                routeName: ChatPage(
                    user1:
                        ChatUser.fromMap(jsonDecode(message["reciver_user"])),
                    user2:
                        ChatUser.fromMap(jsonDecode(message["sender_user"]))));
          });
        } else if (message['category'] != "chat") {
          await Future.delayed(Duration.zero).then((value) async {
            await Constant.navigateTo(
                context: context, routeName: const NotificationScreen());
          });
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                priority: Priority.max,
                enableLights: true,
                playSound: true,
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data["category"] == "chat") {
        Future.delayed(Duration.zero).then((value) async {
          await Constant.navigateTo(
              context: context,
              routeName: ChatPage(
                  user1: ChatUser.fromMap(
                      jsonDecode(message.data["reciver_user"])),
                  user2: ChatUser.fromMap(
                      jsonDecode(message.data["sender_user"]))));
        });
      } else {
        Future.delayed(Duration.zero).then((value) async {
          await Constant.navigateTo(
              context: context, routeName: const NotificationScreen());
        });
      }
    });

    context.read<AuthProvider>().tryToLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (ctx, u, _) {
      if (u.isLoadingTryToLogin) {
        return const SplashScreen();
      } else if (u.userType != null) {
        return const TabsScreen();
      } else {
        return LoginScreen();
      }
    });
  }
}
