import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/widgets/update_client_info_widget.dart';

class SingleInfoClientScreen extends StatelessWidget {
  const SingleInfoClientScreen(
      {Key? key,
      required this.imgUrl,
      required this.name,
      required this.mobile,
      required this.email,
      required this.uid})
      : super(key: key);
  final String uid;
  final String imgUrl;
  final String name;
  final String mobile;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Client Info'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Update info'),
                        content: UpdateClientInfoWidget(
                          uid: uid,
                          whichInfo: 'Client',
                        )));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  width: Get.width * 0.19,
                  height: Get.height * 0.08,
                  fit: BoxFit.cover,
                ),
              ),
              Text(name),
              Text(mobile),
              Text(email),
              Container(
                margin: EdgeInsets.all(12),
                alignment: Alignment.topLeft,
                child: Text(
                  "Projects",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("projects")
                      .where('assigned', arrayContains: uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var ds = snapshot.data!.docs;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: ds.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(12),
                                child: Text('${ds[index]['name']}'),
                              );
                            }),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
