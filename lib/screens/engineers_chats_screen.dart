import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';

class EngineersChatsScreen extends StatefulWidget {
  const EngineersChatsScreen({Key? key}) : super(key: key);

  @override
  State<EngineersChatsScreen> createState() => _EngineersChatsScreenState();
}

class _EngineersChatsScreenState extends State<EngineersChatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("engineers").snapshots(),
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
                  return Container(
                    margin: EdgeInsets.all(6),
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
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
