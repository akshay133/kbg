import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/single_project_info_update_screen.dart';

class ClientsAndEngineersProjectScreen extends StatefulWidget {
  ClientsAndEngineersProjectScreen({Key? key}) : super(key: key);

  @override
  State<ClientsAndEngineersProjectScreen> createState() =>
      _ClientsAndEngineersProjectScreenState();
}

class _ClientsAndEngineersProjectScreenState
    extends State<ClientsAndEngineersProjectScreen> {
  int? selectedIndex;
  final authController = Get.put(AuthController());
  final dashbordController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (ctrl) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("projects")
                .where('assigned',
                    arrayContains: ctrl.box.read(ConstStrings.clientId) == null
                        ? ctrl.box.read(ConstStrings.engineerId)
                        : ctrl.box.read(ConstStrings.clientId))
                .snapshots(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var ds = snapshot.data!.docs;
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: ds.length,
                    itemBuilder: (ctx, index) {
                      var project = ds[index];
                      return InkWell(
                        onTap: () {
                          dashbordController
                              .updateDocSnapshot(snapshot.data!.docs[index]);
                          Get.to(const SingleProjectInfoUpdateScreen());
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(project['name']),
                              authController.box.read(ConstStrings.clientId) !=
                                      null
                                  ? IconButton(
                                      onPressed: () {
                                        assignedToEngineersPop(snapshot
                                            .data!.docs[index]['number']);
                                      },
                                      icon: Icon(Icons.more_vert_outlined))
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          );
        });
  }

  void assignedToEngineersPop(projectNum) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Text('Assigned to Engineers'),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok'))
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("engineers")
                          .snapshots(),
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container(
                            height: 200,
                            width: 300,
                            child: ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (ctx, index) {
                                  DocumentSnapshot data =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.amberAccent),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        assignedProjectToEngineer(
                                            data.get('uid'), projectNum);
                                      },
                                      title: Text(data.get('name')),
                                      leading: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: data.get('imgUrl'),
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      trailing: selectedIndex == index
                                          ? Icon(Icons.done)
                                          : null,
                                    ),
                                  );
                                }),
                          );
                        }
                      })
                ],
              ));
        });
  }

  void assignedProjectToEngineer(uid, projectID) {
    authController.updateEngineersProjects(uid, projectID);
  }
}
