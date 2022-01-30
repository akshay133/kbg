import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (cotroller) {
          var email = cotroller.box.read(ConstStrings.adminEmail);
          print("email$email");
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Center(
                      child: Text(
                        email == null ? cotroller.adminEmail : email.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      cotroller.logout();
                    },
                    child: Text('Logout'))
              ],
            ),
          );
        });
  }
}
