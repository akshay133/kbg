import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/photo_view_screen.dart';
import 'package:kbg/screens/single_project_info_screen.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({Key? key}) : super(key: key);
  final dashBordController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("projects").snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ds = snapshot.data!.docs;
            return ListView.builder(
                itemCount: ds.length,
                itemBuilder: (ctx, index) {
                  DocumentSnapshot doc = ds[index];
                  List imgs = doc.get('imagesUrls');
                  return Container(
                    margin: EdgeInsets.all(8),
                    clipBehavior: Clip.antiAlias,
                    height: Get.height * 0.22,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white, offset: Offset(0.3, 0.2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (imgs.isNotEmpty)
                          InkWell(
                            onTap: () {
                              dashBordController.updateDocSnapshot(doc);
                              Get.to(SingleProjectInfoScreen());
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: imgs.first,
                                fit: BoxFit.cover,
                                height: Get.height * 0.18,
                                width: Get.width,
                              ),
                            ),
                          )
                        else
                          const Icon(
                            Icons.account_circle_rounded,
                            size: 32,
                          ),
                        Text(
                          doc.get('name'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                });
          }
        });
  }
}
