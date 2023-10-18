import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:test_app/core/constant/app_route.dart';
import 'package:test_app/core/controller/login_sign_up_controller.dart';
import 'package:test_app/view/login_signup/login/login.dart';
import '../../core/constant/colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final LoginSignUpController _loginSignUpController =
      Get.find<LoginSignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.avatarColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter text here',
                                border: InputBorder.none,
                              ),
                              onChanged: (data) {},
                              controller: TextEditingController(
                                text: 'Initial Text',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: AppColors.iconColor.withOpacity(0.5),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _loginSignUpController.logOut();
                Get.offAllNamed(AppRoutes.loginScreen);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.buttonBackground,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
