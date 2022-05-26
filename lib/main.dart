import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:provider/provider.dart';

import 'core/util/shared_prefs_helper.dart';
import 'provider/auth_provider.dart';
import 'screen/medicine_reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                elevation: 0,
                color: Colors.white,
                iconTheme: IconThemeData(color: Constant.primaryColor)),
            primarySwatch: Colors.blue,
          ),
          home:
              const MedicineReminderScreen() // const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}
