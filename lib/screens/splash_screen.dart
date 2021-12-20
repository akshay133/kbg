import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/shapes_and_styles.dart';
import 'package:kbg/widgets/login_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: Get.height * 0.1,
        maxHeight: Get.height * 0.8,
        panel: const LoginWidget(),
        body: Container(
          height: double.infinity,
          color: primaryColor,
          padding: const EdgeInsets.all(20),
          child: Image.asset("assets/images/Logo-kbg.png"),
        ),
      ),
    );
  }
}
