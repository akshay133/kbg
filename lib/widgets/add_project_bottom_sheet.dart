import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';

class AddProjectBottomSheet extends StatefulWidget {
  AddProjectBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddProjectBottomSheet> createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final projectNumberController = TextEditingController();

  final projectNameController = TextEditingController();

  final projectTypeController = TextEditingController();

  final activitiesController = TextEditingController();

  final List _value = [];

  @override
  void dispose() {
    projectNumberController.dispose();
    projectNameController.dispose();
    projectTypeController.dispose();
    activitiesController.dispose();
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
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              height: Get.height * 0.1,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: activitiesController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Activities',
                    hintText: 'Some notes about the client',
                    hintStyle: TextStyle(color: grayColor.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.all(8)),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (projectNameController.text.isEmpty &&
                      projectNumberController.text.isEmpty &&
                      projectTypeController.text.isEmpty &&
                      activitiesController.text.isEmpty) {
                    Get.snackbar("Error!", "All fields re required!");
                  } else {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    FirebaseFirestore.instance
                        .collection("projects")
                        .doc(uid + DateTime.now().toString())
                        .set({
                      'name': projectNameController.text,
                      'number': projectNumberController.text,
                      'type': projectTypeController.text,
                      'activity': activitiesController.text,
                      'assigned': [],
                      'images': []
                    }).then((value) {
                      Get.back();
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
