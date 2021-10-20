import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/shapes_and_styles.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: Get.height * 0.08,
        panel: Column(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: ShapesAndStyles.textStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
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
