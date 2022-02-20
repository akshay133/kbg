import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/admin_chats.dart';
import 'package:kbg/screens/clients_chats_screen.dart';
import 'package:kbg/screens/clients_engineers_project_screen.dart';
import 'package:kbg/screens/gallery_screen.dart';
import 'package:kbg/widgets/drawer.dart';

class ClientHomeScreenMain extends StatelessWidget {
  const ClientHomeScreenMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Welcome'),
            ),
            drawer: CustomDrawer(
              user: 'client',
            ),
            body: SafeArea(
              child: IndexedStack(
                index: _.tabIndex,
                children: [
                  ClientsAndEngineersProjectScreen(),
                  AdminChatsScreen(),
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
                    'assets/images/project.png',
                    height: Get.height * 0.034,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/project.png',
                    height: Get.height * 0.034,
                    color: primaryColor,
                  ),
                  label: 'Project',
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
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/gallery.png',
                    height: Get.height * 0.034,
                  ),
                  label: 'Gallery',
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
