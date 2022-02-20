import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbg/controller/dashboard_controller.dart';

import '../constants/strings.dart';
import '../controller/auth_controller.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({Key? key}) : super(key: key);

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  File? _image;
  String? photoUrl;
  final dasController = Get.put(DashboardController());
  final authController = Get.put(AuthController());
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
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (authController.box.read(ConstStrings.clientIdStore) == true) {
              Get.snackbar("Error", "You have not access");
            } else {
              _imgFromCamera();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: _image == null
                ? const Icon(
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
              if (photoUrl != null) {
                FirebaseFirestore.instance
                    .collection('projects')
                    .doc(dasController.snapshot.get('number'))
                    .update({
                  'imagesUrls': FieldValue.arrayUnion([photoUrl.toString()])
                }).then((value) {
                  Get.snackbar("Updated", "Successfully");
                });
              } else {
                Get.snackbar("Error!", 'Please select an photo');
              }
            },
            child: Text('Update'))
      ],
    );
  }
}
