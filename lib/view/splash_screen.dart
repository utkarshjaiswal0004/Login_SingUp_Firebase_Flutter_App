import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:test_app/core/constant/app_route.dart';
import 'package:test_app/view/home_screen/home_screen.dart';
import 'package:test_app/view/login_signup/login/login.dart';

import '../core/constant/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //wait before redirecting to login signUp screen
    Future.delayed(Durations.extralong1, () {
      checkLoginStatus();
    });
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }

  Future checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Get.offNamed(AppRoutes.loginScreen);
    }
  }
}
