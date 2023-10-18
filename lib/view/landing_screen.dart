import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:test_app/core/constant/colors.dart';
import 'package:test_app/view/login_signup/login/login.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

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

  checkLoginStatus() {
    //currently just redirecting
    Get.off(LoginScreen());
  }
}