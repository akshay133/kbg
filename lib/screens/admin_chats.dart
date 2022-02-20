import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/screens/chat_room_screen.dart';

class AdminChatsScreen extends StatelessWidget {
  AdminChatsScreen({Key? key}) : super(key: key);
  final authController = Get.put(AuthController());
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
        stream: FirebaseFirestore.instance.collection("admin").snapshots(),
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
                  return InkWell(
                    onTap: () {
                      String roomId = chatRoomId(
                          authController.box.read(ConstStrings.clientEmail) ??
                              authController.box
                                  .read(ConstStrings.engineerEmail),
                          ds[index]['email']);
                      Get.to(ChatRoomScreen(
                        chatRoomId: roomId,
                        user: ds[index]['name'],
                        sentBy: authController.box
                                .read(ConstStrings.clientEmail) ??
                            authController.box.read(ConstStrings.engineerEmail),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            ds[index]['name'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: grayColor),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
