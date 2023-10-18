// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:test_app/core/constant/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_app/view/login_signup/login/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  XFile? pickedImage;
  late PermissionStatus _cameraStatus;
  late PermissionStatus _galleryStatus;
  final picker = ImagePicker();
  bool showPassword = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      print('Name: $name');
      print('Email: $email');
      print('Password: $password');
      // Add your login logic here
    }
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildListTile(
                Icons.camera,
                'Take a Photo',
                () {
                  Navigator.of(context).pop(); // Close the dialog
                  pickImage(ImageSource.camera);
                },
              ),
              _buildListTile(
                Icons.photo,
                'Choose from Gallery',
                () {
                  Navigator.of(context).pop(); // Close the dialog
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final status = (source == ImageSource.camera)
        ? _cameraStatus
        : _galleryStatus; // Request camera / gallery access
    if (status.isGranted) {
      pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          pickedImage = pickedImage;
        });
      }
    } else if (status.isDenied) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'Please enable camera/gallery permissions in your device settings.'),
          actions: <Widget>[
            _buildDialogTextButton('Open Settings', () {
              openAppSettings();
              Navigator.of(context).pop();
            }),
            _buildDialogTextButton('Cancel', () {
              Navigator.of(context).pop();
            }),
          ],
        );
      },
    );
  }

  TextButton _buildDialogTextButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  // Function to check the status of the gallery permission
  Future<void> _askPhotoPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      status = await Permission.photos.request();
    }
    setState(() {
      _galleryStatus = status;
    });
  }

  // Function to request gallery permission
  Future<void> _askCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    setState(() {
      _cameraStatus = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _askPhotoPermission();
    _askCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up With Email',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: _showImageSourceDialog, // Open image picker on tap
                    child: pickedImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors
                                .transparent, // Add this line to make the background transparent
                            backgroundImage: pickedImage != null
                                ? FileImage(File(pickedImage!.path))
                                : null,
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.avatarColor,
                            child: Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20.0),
                  buildMaterialTextField(
                    controller: nameController,
                    labelText: 'Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  buildMaterialTextField(
                    controller: emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  buildMaterialTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: showPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _handleLogin,
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
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    "Already have an account",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Get.to(const LoginScreen());
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMaterialTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
  }) {
    return SizedBox(
      width: 350,
      child: Material(
        elevation: 10,
        shadowColor: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: AppColors.white,
            labelStyle: const TextStyle(
              color: AppColors.textColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.avatarColor,
              ),
            ),
            contentPadding: const EdgeInsets.all(15.0),
            suffixIcon: suffixIcon,
          ),
          obscureText: obscureText,
          validator: validator,
        ),
      ),
    );
  }
}
