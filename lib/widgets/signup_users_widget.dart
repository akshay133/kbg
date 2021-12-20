import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';

class SignUpUsersWidget extends StatefulWidget {
  SignUpUsersWidget({Key? key}) : super(key: key);

  @override
  State<SignUpUsersWidget> createState() => _SignUpUsersWidgetState();
}

class _SignUpUsersWidgetState extends State<SignUpUsersWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  final _authController = Get.put(AuthController());
  final _dashboardController = Get.put(DashboardController());
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                    hintText: 'abc@mail.com',
                    hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.all(8))),
          ),
          SizedBox(height: Get.height * 0.02),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: passwordController,
              obscureText: _obscureText,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                labelText: 'Password',
                hintText: '12345678',
                hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                suffix: IconButton(
                    onPressed: _toggle,
                    icon: Icon(_obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined)),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          ElevatedButton(
              onPressed: () {
                if (_dashboardController.tabIndex == 1) {
                  _authController.registerEngineerWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      context);
                  _dashboardController.checkUserEngineer(true);
                  Get.back();
                } else {
                  _authController.registerClientWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim());
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(Get.width, Get.width / 10)),
              child: const Text('Register')),
        ],
      ),
    );
  }
}
