import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hti_store/shared/components/components.dart';

import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../login/login_screen.dart';
import '../on_boarding/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Widget widget;

      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      token = CacheHelper.getData(key: 'token');
      userRole = CacheHelper.getData(key: 'userRole');
      userID = CacheHelper.getData(key: 'userID');

      if (onBoarding != null) {
        if (token != null && userRole != null) {
          widget = getHomeScreen(userRole!);
        } else {
          widget = LoginScreen();
          print("LoginScreen");
        }
      } else {
        widget = const OnBoardingScreen();
        print("OnBoardingScreen");
      }

      Timer(const Duration(seconds: 4), () {
        navigateTo(context, widget);
      });

      return  Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 300, height: 300),
                const SizedBox(height: 16),
                progressLoading(),

              ],
            ),
          ),
        ),
      );
    });
  }
}
