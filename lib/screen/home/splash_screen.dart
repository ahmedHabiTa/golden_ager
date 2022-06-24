import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:golden_ager/core/constant/Constant.dart';

import '../../notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    notify();
  }

  notify() async {
    await localNotifyManager.showEveryDayAtATimeNotification(
      body: 'Tell us How you feel today',
      payload: 'checkIn_screen',
      time: Time(12, 0, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.ease,
        duration: const Duration(seconds: 2),
        builder: (BuildContext context, double opacity, Widget? child) {
          return Scaffold(
            body: Container(
              width: Constant.width(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Constant.primaryColor,
                    Constant.primaryDarkColor,
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
                      opacity: opacity % 2 > 1 ? 1 : opacity % 2,
                      duration: const Duration(seconds: 4),
                      child: Container(
                        width: Constant.width(context) * 0.6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF628BB2),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacity % 1 > 1 ? 1 : opacity % 1,
                      duration: const Duration(seconds: 2),
                      child: Container(
                        width: Constant.width(context) * 0.45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFBCD2DF),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacity > 1 ? 1 : opacity,
                      duration: const Duration(seconds: 1),
                      child: Container(
                        width: Constant.width(context) * 0.3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: Constant.width(context) * 0.15,
                      height: Constant.height(context) * 0.15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/logo.png')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
