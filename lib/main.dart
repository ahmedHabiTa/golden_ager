import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:golden_ager/core/constant/constant.dart';
=======
import 'package:golden_ager/features/home/presentaion/splash_screen.dart';
import 'package:golden_ager/features/home/presentaion/tabs_screen.dart';
import 'package:golden_ager/provider/auth_provider.dart';
>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2
import 'package:provider/provider.dart';

import 'core/common_widget/loading_widget.dart';
import 'core/util/shared_prefs_helper.dart';
<<<<<<< HEAD
import 'provider/auth_provider.dart';
import 'screen/medicine_reminder.dart';
=======
import 'provider/home_provider.dart';
>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2

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
<<<<<<< HEAD
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
=======
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


>>>>>>> 2a33480485c5115cb74505fdbb1f7f7a29cf24d2
