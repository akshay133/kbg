import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/screens/single_project_info_screen.dart';

class AllProjectsScreen extends StatelessWidget {
  AllProjectsScreen({Key? key}) : super(key: key);
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("projects").snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListTile(
                    onTap: () {
                      Get.to(SingleProjectInfoScreen(
                        snapshot: snapshot.data!.docs[index],
                      ));
                    },
                    tileColor: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(snapshot.data!.docs[index]['name']),
                  ),
                );
              });
        }
      },
    );
  }
}
