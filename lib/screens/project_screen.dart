import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/screens/all_projects_screen.dart';
import 'package:kbg/widgets/add_project_bottom_sheet.dart';
import 'package:kbg/widgets/signup_users_widget.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Project\nManagement',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: grayColor),
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amberAccent),
                child: IconButton(
                    onPressed: () {
                      Get.bottomSheet(AddProjectBottomSheet());
                    },
                    icon: const Icon(
                      Icons.add,
                    )),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.amberAccent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: 'All projects',
              ),
              Tab(
                text: 'On Going',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllProjectsScreen(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
