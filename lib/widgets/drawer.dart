import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key, required this.user}) : super(key: key);
  final String user;
  String email = '';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (cotroller) {
          if (user == 'admin') {
            email = cotroller.box.read(ConstStrings.adminEmail);
          } else if (user == 'client') {
            email = cotroller.box.read(ConstStrings.clientEmail);
          } else if (user == 'engineer') {
            email = cotroller.box.read(ConstStrings.engineerEmail);
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Colors.amberAccent),
                    child: Center(
                      child: Text(
                        email,
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
