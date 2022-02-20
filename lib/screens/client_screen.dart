import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/single_info_client_screen.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';
import 'package:kbg/widgets/signup_users_widget.dart';

class ClientScreen extends StatelessWidget {
  ClientScreen({Key? key}) : super(key: key);
  final _dashboardController = Get.put(DashboardController());
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Client\nManagement',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: grayColor),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amberAccent),
              child: IconButton(
                  onPressed: () {
                    _dashboardController.checkUserEngineer(false);
                    Get.defaultDialog(
                        barrierDismissible: false,
                        backgroundColor: Color.fromRGBO(240, 239, 246, 1),
                        title: 'Register New client',
                        middleText: '',
                        content: SignUpUsersWidget());
                  },
                  icon: const Icon(
                    Icons.add,
                  )),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("clients").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  Get.snackbar("Error", snapshot.error.toString());
                }
                var ds = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                      itemCount: ds.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(SingleInfoClientScreen(
                                name: ds[index]['name'],
                                imgUrl: ds[index]['imgUrl'],
                                email: ds[index]['email'],
                                mobile: ds[index]['mobile'],
                                uid: ds[index]['uid'],
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: CachedNetworkImage(
                                          imageUrl: ds[index]['imgUrl'],
                                          height: Get.height * 0.08,
                                          width: Get.width * 0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            ds[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: grayColor),
                                          ),
                                          Text(
                                            ds[index]['title'],
                                            style: const TextStyle(
                                                fontSize: 16, color: grayColor),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: const Color(0xff75B3FF),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(children: [
                                            Text(
                                                '${ds[index]['projects'].length}')
                                          ]))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              })
        ],
      ),
    );
  }
}
