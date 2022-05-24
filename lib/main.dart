import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:golden_ager/features/auth/presentation/pages/login_screen.dart';
import 'package:golden_ager/features/auth/presentation/provider/auth_provider.dart';
import 'package:golden_ager/features/home/presentaion/splash_screen.dart';
import 'package:golden_ager/features/home/presentaion/tabs_screen.dart';
import 'package:provider/provider.dart';

import 'core/common_widget/loading_widget.dart';
import 'core/util/shared_prefs_helper.dart';
import 'features/home/home_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
        debugShowCheckedModeBanner: false,
        home:  StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const LoadingWidget();
            }else if(snapshot.hasError){
              return const Scaffold(body:  Center(child:Text('Something went wrong')));
            }else if(snapshot.hasData){
              return const TabsScreen();
            }else{
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}


