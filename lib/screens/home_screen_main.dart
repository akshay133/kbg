import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/chats_screen.dart';
import 'package:kbg/screens/client_screen.dart';
import 'package:kbg/screens/engineer_screen.dart';
import 'package:kbg/screens/gallery_screen.dart';
import 'package:kbg/screens/project_screen.dart';

class HomeScreenMain extends StatelessWidget {
  HomeScreenMain({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (_) {
          return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: _.tabIndex,
                children: const [
                  ClientScreen(),
                  EngineerScreen(),
                  ProjectScreen(),
                  ChatsScreen(),
                  GalleryScreen()
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: _.changeTabIndex,
              selectedItemColor: primaryColor,
              currentIndex: _.tabIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/client.png',
                    height: Get.height * 0.034,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/client.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                  label: 'Client',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/engineer.png',
                    height: Get.height * 0.034,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/engineer.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/project.png',
                    height: Get.height * 0.034,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/project.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                  label: 'Alerts',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/chats.png',
                    height: Get.height * 0.034,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/chats.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                  label: 'Account',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/gallery.png',
                    height: Get.height * 0.034,
                  ),
                  label: 'News',
                  activeIcon: Image.asset(
                    'assets/images/gallery.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
