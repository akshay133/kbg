import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen({Key? key, required this.chatRoomId, required this.user})
      : super(key: key);
  final String chatRoomId;
  final String user;
  final TextEditingController _message = TextEditingController();
  final authController = Get.put(AuthController());
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": "Admin",
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.size.height / 1.25,
              width: Get.size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRoom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;

                        return messages(Get.size, map, context);
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              height: Get.size.height / 10,
              width: Get.size.width,
              alignment: Alignment.center,
              child: Container(
                height: Get.size.height / 12,
                width: Get.size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.size.height / 17,
                      width: Get.size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget messages(size, Map<String, dynamic> map, BuildContext context) {
    return Container(
      alignment:
          map['sendby'] == authController.box.read(ConstStrings.adminEmail)
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
        ),
        child: Text(
          map['message'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
