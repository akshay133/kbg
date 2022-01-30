import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SingleProjectInfoScreen extends StatefulWidget {
  SingleProjectInfoScreen({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  State<SingleProjectInfoScreen> createState() =>
      _SingleProjectInfoScreenState();
}

class _SingleProjectInfoScreenState extends State<SingleProjectInfoScreen> {
  final percentageController = TextEditingController();
  File? _image;
  String? photoUrl;
  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    final pickedImageFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(pickedImageFile!.path);
    });

    UploadTask photoPath = uploadPhoto(_image!);
    final snapshot = await photoPath.whenComplete(() {});
    photoUrl = await snapshot.ref.getDownloadURL();
  }

  uploadPhoto(File image) {
    DateTime time = DateTime.now();
    String filename = 'images/projects/${time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);
      UploadTask task = ref.putFile(image);
      return task;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot.get('name')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircularPercentIndicator(
                radius: 130.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent:
                    double.parse(widget.snapshot.get('percentage').toString()),
                center: Text(
                  "${widget.snapshot.get('percentage').toString()}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.yellow,
                progressColor: Colors.red,
              ),
              TextField(
                controller: percentageController,
                decoration: InputDecoration(
                    hintText: 'Add percentage of the running project'),
              ),
              InkWell(
                onTap: () {
                  _imgFromCamera();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                        )
                      : Image.file(
                          _image!,
                          height: Get.size.height * 0.2,
                          width: Get.size.width * 0.5,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('projects')
                        .doc(widget.snapshot.get('number'))
                        .update({
                      'percentage': percentageController.text,
                      'imagesUrls': FieldValue.arrayUnion([photoUrl.toString()])
                    });
                  },
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
