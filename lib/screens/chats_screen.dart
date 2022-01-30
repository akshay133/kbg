import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("clients").snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          Get.snackbar("Error", snapshot.error.toString());
        }
        var ds = snapshot.data!.docs;
        return ListView.builder(
            itemCount: ds.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
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
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                    children: List.generate(
                                        ds[index]['projects'].length,
                                        (index) =>
                                            Text('${ds[index]['projects']}'))))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
