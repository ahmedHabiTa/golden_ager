import 'package:flutter/material.dart';
import 'package:golden_ager/core/constant/constants.dart';

import '../../../pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double opacityLevel = 0.0;

  void _changeOpacity() {
    setState(() => opacityLevel = 1.0);
  }
@override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () => _changeOpacity(),
    );
    Future.delayed(
      const Duration(seconds:4),
      () => Constants.navigateToRep(routeName: const LoginScreen(), context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: Constants.width(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constants.primaryColor,
                Constants.primaryDarkColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(seconds: 4),
                  child: Container(
                    width: Constants.width(context) * 0.6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF628BB2),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(seconds: 2),
                  child: Container(
                    width: Constants.width(context) * 0.45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFBCD2DF),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    width: Constants.width(context) * 0.3,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: Constants.width(context) * 0.15,
                  height: Constants.height(context) * 0.15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/logo.png')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
