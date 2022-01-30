import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

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
                  return imgs != null
                      ? Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blueGrey.shade200,
                                    offset: Offset(0.3, 0.2))
                              ]),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: imgs.first,
                                fit: BoxFit.cover,
                                height: Get.height * 0.02,
                              ),
                              Text(doc.get('name'))
                            ],
                          ),
                        )
                      : Container();
                });
          }
        });
  }
}
