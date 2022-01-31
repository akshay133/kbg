import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/controller/dashboard_controller.dart';

class AddProjectBottomSheet extends StatefulWidget {
  AddProjectBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddProjectBottomSheet> createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final projectNumberController = TextEditingController();

  final projectNameController = TextEditingController();

  final projectTypeController = TextEditingController();
  final activityController = TextEditingController();

  final authController = Get.put(AuthController());
  final dashController = Get.put(DashboardController());
  DateTime? selectedDate;
  DateTime? selectedEndDate;
  String defaultValue = "Select here";
  int? selectedIndex;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  @override
  void initState() {
    dashController.activitiesList.clear();
    super.initState();
  }

  @override
  void dispose() {
    projectNumberController.dispose();
    projectNameController.dispose();
    projectTypeController.dispose();
    activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color.fromRGBO(240, 239, 246, 1)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    )),
                SizedBox(width: Get.width * 0.25),
                const Text(
                  'New Project',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: projectNameController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Project Name',
                    hintText: 'abc project',
                    hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.all(8)),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: projectNumberController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Project Number',
                    hintText: '12221',
                    hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.all(8)),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: projectTypeController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Project Type',
                    hintText: 'abc',
                    hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.all(8)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Start and End date of the project',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(selectedDate == null
                      ? 'Start Date'
                      : "${selectedDate?.toLocal()}".split(' ')[0]),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectEndDate(context);
                  },
                  child: Text(selectedEndDate == null
                      ? 'End Date'
                      : "${selectedEndDate?.toLocal()}".split(' ')[0]),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add activities',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Add Activity'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: activityController,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        dashController.updateList(
                                            activityController.text);
                                        Get.back();
                                      },
                                      child: const Text('Add'))
                                ],
                              ),
                            );
                          });
                    },
                    child: Text('Add'))
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            GetBuilder<DashboardController>(
                init: DashboardController(),
                builder: (ctl) {
                  return Column(
                    children: List.generate(
                        ctl.activitiesList.length,
                        (index) => Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  '${index + 1}. ${ctl.activitiesList[index]}'),
                            )),
                  );
                }),
            ElevatedButton(
                onPressed: () {
                  if (projectNameController.text.isEmpty &&
                      projectNumberController.text.isEmpty &&
                      projectTypeController.text.isEmpty) {
                    Get.snackbar("Error!", "All fields re required!");
                  } else {
                    FirebaseFirestore.instance
                        .collection("projects")
                        .doc(projectNumberController.text.trim())
                        .set({
                      'name': projectNameController.text,
                      'number': projectNumberController.text,
                      'type': projectTypeController.text,
                      'start_date':
                          "${selectedEndDate?.toLocal()}".split(' ')[0],
                      'end_date': "${selectedEndDate?.toLocal()}".split(' ')[0],
                      'activities': dashController.activitiesList,
                      'assigned': [],
                      'imagesUrls': [],
                      'percentage': 0,
                    });
                  }
                },
                child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}
