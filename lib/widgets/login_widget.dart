import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/shapes_and_styles.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
              SizedBox(
                height: Get.height * 0.05,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    fillColor: borderSideColor,
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
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
              SizedBox(
                height: Get.height * 0.05,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    fillColor: borderSideColor,
                    filled: true,
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
              Text(
                "Forgot Password?",
                style: ShapesAndStyles.textStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    minimumSize: Size(Get.width, Get.height * 0.05)),
                onPressed: () {},
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
