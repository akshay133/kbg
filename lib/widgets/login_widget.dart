import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/shapes_and_styles.dart';
import 'package:kbg/controller/auth_controller.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String role = '';
  final _authController = Get.put(AuthController());
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              color: primaryColor,
              width: double.infinity,
              height: Get.height * 0.02,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.black,
                width: Get.width * 0.2,
                height: Get.height * 0.005,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Login to your account',
            style:
                ShapesAndStyles.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: ShapesAndStyles.textStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              const Text(
                'EMAIL',
                style: ShapesAndStyles.textStyle2,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: borderSideColor,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.021,
              ),
              const Text(
                "PASSWORD",
                style: ShapesAndStyles.textStyle2,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: borderSideColor,
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Forgot Password?",
                    style: ShapesAndStyles.textStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton(
                    child: Text(role == '' ? 'Select Role ' : role),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'admin',
                          child: Text('Admin'),
                        ),
                        const PopupMenuItem(
                          value: 'client',
                          child: Text('Client'),
                        ),
                        const PopupMenuItem(
                          value: 'engineer',
                          child: Text('Engineer'),
                        )
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'admin') {
                        setState(() {
                          role = value;
                        });
                      } else if (value == 'client') {
                        setState(() {
                          role = value;
                        });
                      } else if (value == 'engineer') {
                        setState(() {
                          role = value;
                        });
                      }
                    },
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.08,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    minimumSize: Size(Get.width, Get.height * 0.05)),
                onPressed: () {
                  if (_emailController.text.isEmpty &&
                      _passwordController.text.isEmpty) {
                    Get.snackbar(
                      "Required!",
                      "All fields are required",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                  if (role == '') {
                    Get.snackbar("Error!", "Please select role");
                  } else {
                    _authController.loginWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        role);
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
