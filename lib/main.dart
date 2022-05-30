import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constant.dart';
import 'package:golden_ager/provider/auth_provider.dart';
import 'package:golden_ager/screen/auth/login_screen.dart';
import 'package:provider/provider.dart';

import 'core/util/shared_prefs_helper.dart';
import 'provider/auth_provider.dart';
import 'provider/home_provider.dart';
import 'screen/home/splash_screen.dart';
import 'screen/home/tabs_screen.dart';

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
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
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
