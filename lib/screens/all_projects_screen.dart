import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/screens/single_project_info_screen.dart';

class AllProjectsScreen extends StatefulWidget {
  AllProjectsScreen({Key? key}) : super(key: key);

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  final authController = Get.put(AuthController());
  int? selectedIndex;
  int? selectedIndex2;
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
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert_outlined),
                      onPressed: () {
                        assignedToClientPop(
                            snapshot.data!.docs[index]['number']);
                      },
                    ),
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

  void assignedToClientPop(String projectNum) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Text('Assigned to Clients'),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.back();
                      assignedToEngineersPop(projectNum);
                    },
                    icon: Icon(Icons.arrow_forward_ios))
              ],
              content: StatefulBuilder(
                builder: (ctx, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("clients")
                              .snapshots(),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var ds = snapshot.data!.docs;
                              return Container(
                                height: 200,
                                width: 300,
                                child: ListView.builder(
                                    itemCount: ds.length,
                                    itemBuilder: (ctx, index) {
                                      var data = ds[index];
                                      return Container(
                                        margin: EdgeInsets.all(4),
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
                                            assignedProjectToClient(data['uid'],
                                                projectNum); // assignedProjectToClient(data.get('name'));
                                          },
                                          title: Text(data['name']),
                                          leading: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: data['imgUrl'],
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
                          }),
                    ],
                  );
                },
              ));
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
                                          selectedIndex2 = index;
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

  void assignedProjectToClient(uid, projectID) {
    authController.updateClientsProjects(uid, projectID);
  }

  void assignedProjectToEngineer(uid, projectID) {
    authController.updateEngineersProjects(uid, projectID);
  }
}
