import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constants/strings.dart';
import '../controller/dashboard_controller.dart';

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({Key? key}) : super(key: key);
  final _random = Random();
  final nameController = TextEditingController();
  final percentageController = TextEditingController();
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(_.snapshot.get('name')),
            actions: [
              IconButton(
                  onPressed: () {
                    if (authController.box.read(ConstStrings.clientIdStore) ==
                        true) {
                      Get.snackbar("Error", "You have not access");
                    } else {
                      Get.dialog(AlertDialog(
                        title: Text('Add more activities'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(hintText: 'Name'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: percentageController,
                                decoration:
                                    InputDecoration(hintText: 'Add Percentage'),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  if (nameController.text.isEmpty &&
                                      percentageController.text.isEmpty) {
                                    Get.snackbar(
                                        "Error!", "All fields required!");
                                  } else {
                                    _.updateActivity(
                                        _.snapshot.get('number'),
                                        nameController.text,
                                        int.parse(
                                            percentageController.text.trim()));
                                  }
                                },
                                child: Text('Add'))
                          ],
                        ),
                      ));
                    }
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Activities Progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects')
                        .doc(_.snapshot.get('number'))
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List ds = snapshot.data!.get('activities');
                        return Expanded(
                          child: ListView.builder(
                              itemCount: ds.length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  margin: EdgeInsets.all(4),
                                  height: Get.height * 0.14,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color.fromRGBO(244, 243, 255, 1)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              )
                                            ];
                                          },
                                          onSelected: (String value) {
                                            if (value == 'edit') {
                                              if (authController.box.read(
                                                      ConstStrings
                                                          .clientIdStore) ==
                                                  true) {
                                                Get.snackbar("Error",
                                                    "You have not access");
                                              } else {
                                                Get.dialog(AlertDialog(
                                                  title: const Center(
                                                      child: Text(
                                                    'Edit',
                                                    style: TextStyle(),
                                                  )),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              nameController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      'Activity Name'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              percentageController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      'Percentage'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              if (nameController
                                                                      .text
                                                                      .isEmpty &&
                                                                  percentageController
                                                                      .text
                                                                      .isEmpty) {
                                                                Get.snackbar(
                                                                    "Error!",
                                                                    "All fields required!");
                                                              } else {
                                                                _.deleteActivity(
                                                                    _.snapshot.get(
                                                                        'number'),
                                                                    ds[index]);
                                                                _.updateActivity(
                                                                    _.snapshot.get(
                                                                        'number'),
                                                                    nameController
                                                                        .text,
                                                                    int.parse(
                                                                        percentageController
                                                                            .text
                                                                            .trim()));
                                                              }
                                                            },
                                                            child:
                                                                Text('Update')),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                              }
                                            } else if (value == 'delete') {
                                              if (authController.box.read(
                                                      ConstStrings
                                                          .clientIdStore) ==
                                                  true) {
                                                Get.snackbar("Error",
                                                    "You have not access");
                                              } else {
                                                _.deleteActivity(
                                                    _.snapshot.get('number'),
                                                    ds[index]);
                                              }
                                            }
                                            print(
                                                'You Click on po up menu item $value');
                                          },
                                        ),
                                        right: 8,
                                        top: 8,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12)),
                                              color: Colors.primaries[
                                                      _random.nextInt(Colors
                                                          .primaries.length)]
                                                  [_random.nextInt(9) * 100],
                                            ),
                                            height: Get.height,
                                            width: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10),
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    ds[index]['name'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.height * 0.025,
                                                ),
                                                Row(
                                                  children: [
                                                    LinearPercentIndicator(
                                                      width: Get.width * 0.72,
                                                      lineHeight: 8.0,
                                                      percent: ds[index]
                                                                  ['percentage']
                                                              .toDouble() /
                                                          100,
                                                      progressColor: Colors
                                                                  .primaries[
                                                              _random.nextInt(
                                                                  Colors
                                                                      .primaries
                                                                      .length)][
                                                          _random.nextInt(9) *
                                                              100],
                                                      barRadius:
                                                          const Radius.circular(
                                                              10),
                                                    ),
                                                    Text(
                                                      "${ds[index]['percentage'].toString()}%",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
