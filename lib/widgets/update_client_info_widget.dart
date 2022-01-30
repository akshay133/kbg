import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/controller/auth_controller.dart';

class UpdateClientInfoWidget extends StatefulWidget {
  const UpdateClientInfoWidget({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  _UpdateClientInfoWidgetState createState() => _UpdateClientInfoWidgetState();
}

class _UpdateClientInfoWidgetState extends State<UpdateClientInfoWidget> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final authController = Get.put(AuthController());
  File? _image;
  String? photoUrl;
  _imgFromGallery() async {
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
    String filename = 'images/clients/${time.toString()}';
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
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _imgFromGallery();
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: _image == null
                ? Icon(
                    Icons.person,
                    size: Get.size.height * 0.1,
                    color: grayColor.withOpacity(0.15),
                  )
                : Image.file(
                    _image!,
                    height: Get.size.height * 0.1,
                    width: Get.size.width * 0.2,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(hintText: 'Name'),
        ),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(hintText: 'phone'),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(hintText: 'email'),
        ),
        ElevatedButton(
            onPressed: () {
              Get.back();
              authController.updateSingleClientInfo(
                  widget.uid,
                  _nameController.text,
                  _phoneController.text,
                  _emailController.text.trim(),
                  photoUrl!);
            },
            child: Text('Update'))
      ],
    );
  }
}
