import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/activities_screen.dart';
import 'package:kbg/screens/single_info_client_screen.dart';
import 'package:kbg/screens/single_info_engineer_screen.dart';
import 'package:kbg/widgets/add_image_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../constants/strings.dart';
import '../controller/auth_controller.dart';

class SingleProjectInfoUpdateScreen extends StatefulWidget {
  const SingleProjectInfoUpdateScreen({Key? key}) : super(key: key);

  @override
  State<SingleProjectInfoUpdateScreen> createState() =>
      _SingleProjectInfoUpdateScreenState();
}

class _SingleProjectInfoUpdateScreenState
    extends State<SingleProjectInfoUpdateScreen> {
  int ssum = 0;
  var tl;
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (_) {
          List activities = _.snapshot.get('activities');
          for (var element in activities) {
            int um = element['percentage'];
            ssum = ssum + um;
            tl = ssum / activities.length;
          }
          return Scaffold(
            backgroundColor: Color.fromRGBO(243, 245, 253, 1),
            appBar: AppBar(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(_.snapshot.get('name')),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(ActivitiesScreen());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(230, 231, 242, 1),
                                    spreadRadius: 22,
                                    blurRadius: 4,
                                    offset: Offset(2, 2))
                              ],
                              color: Color.fromRGBO(230, 231, 241, 1),
                              shape: BoxShape.circle),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(230, 231, 241, 1),
                                      spreadRadius: 13,
                                      blurRadius: 10,
                                      offset: Offset(2, 2))
                                ],
                                shape: BoxShape.circle),
                            child: CircularPercentIndicator(
                              radius: 120.0,
                              animation: true,
                              linearGradient: LinearGradient(colors: [
                                Colors.blue.shade900,
                                Color(0xff1f0b6c),
                                Color(0xfff368c5)
                              ]),
                              animationDuration: 1200,
                              lineWidth: 10.0,
                              percent: tl / 100,
                              center: Text(
                                tl.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const AddImageWidget(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Clients and Engineer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("clients")
                              .where('projects',
                                  arrayContains: _.snapshot.get('number'))
                              .snapshots(),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var ds = snapshot.data!.docs;
                              return Container(
                                height: 80,
                                child: ListView.builder(
                                    itemCount: ds.length,
                                    itemBuilder: (ctx, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (authController.box.read(
                                                      ConstStrings
                                                          .clientIdStore) ==
                                                  true ||
                                              authController.box.read(
                                                      ConstStrings
                                                          .engineerIdStore) ==
                                                  true) {
                                            Get.snackbar(
                                                "Error", "You have not access");
                                          } else {
                                            Get.to(SingleInfoClientScreen(
                                                imgUrl: ds[index]['imgUrl'],
                                                name: ds[index]['name'],
                                                mobile: ds[index]['mobile'],
                                                email: ds[index]['email'],
                                                uid: ds[index]['uid']));
                                          }
                                        },
                                        child: Container(
                                            child:
                                                Text('${ds[index]['name']}')),
                                      );
                                    }),
                              );
                            }
                          }),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("engineers")
                              .where('projects',
                                  arrayContains: _.snapshot.get('number'))
                              .snapshots(),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var ds = snapshot.data!.docs;
                              return Container(
                                height: 50,
                                child: ListView.builder(
                                    itemCount: ds.length,
                                    itemBuilder: (ctx, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (authController.box.read(
                                                      ConstStrings
                                                          .clientIdStore) ==
                                                  true ||
                                              authController.box.read(
                                                      ConstStrings
                                                          .engineerIdStore) ==
                                                  true) {
                                            Get.snackbar(
                                                "Error", "You have not access");
                                          } else {
                                            if (authController.box.read(
                                                        ConstStrings
                                                            .clientIdStore) ==
                                                    true ||
                                                authController.box.read(
                                                        ConstStrings
                                                            .engineerIdStore) ==
                                                    true) {
                                              Get.snackbar("Error",
                                                  "You have not access");
                                            } else {
                                              Get.to(SingleInfoEngineerScreen(
                                                  imgUrl: ds[index]['imgUrl'],
                                                  name: ds[index]['name'],
                                                  mobile: ds[index]['mobile'],
                                                  email: ds[index]['email'],
                                                  uid: ds[index]['uid']));
                                            }
                                          }
                                        },
                                        child: Container(
                                            child:
                                                Text('${ds[index]['name']}')),
                                      );
                                    }),
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
