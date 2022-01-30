import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/controller/auth_controller.dart';
import 'package:kbg/controller/dashboard_controller.dart';

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  String? photoUrl;
  String? gender = "Mr.";
  File? _image;
  final _authController = Get.put(AuthController());
  final _dashBordController = Get.put(DashboardController());
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _activityController = TextEditingController();

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
    String filename = 'images/engineers/${time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);
      UploadTask task = ref.putFile(image);
      return task;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (ctl) {
        print(ctl.isEngineer);
        return Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 239, 246, 1)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          )),
                      SizedBox(width: Get.width * 0.25),
                      Text(
                        ctl.isEngineer == false ? 'New Client' : 'New Engineer',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _imgFromGallery();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
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
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      DropdownButton<String>(
                        value: gender,
                        items: <String>['Mr.', 'Mrs.'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: grayColor.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  const Divider(),
                  const Text(
                    'Add more details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Title',
                          hintText: 'Company name',
                          hintStyle:
                              TextStyle(color: grayColor.withOpacity(0.5)),
                          labelStyle:
                              TextStyle(color: grayColor.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Phone',
                          hintText: 'Company Phone',
                          hintStyle:
                              TextStyle(color: grayColor.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Mobile',
                          hintText: 'Client Mobile',
                          hintStyle:
                              TextStyle(color: grayColor.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  ctl.isEngineer == false
                      ? Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: _websiteController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Website',
                                hintText: 'Company.site',
                                hintStyle: TextStyle(
                                    color: grayColor.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                          hintText: 'Company@mail.com',
                          hintStyle:
                              TextStyle(color: grayColor.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  ctl.isEngineer == false
                      ? Container(
                          height: Get.height * 0.1,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: _activityController,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Activities',
                                hintText: 'Some notes about the client',
                                hintStyle: TextStyle(
                                    color: grayColor.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (photoUrl == null) {
                          print("error");
                        } else if (ctl.isEngineer == false) {
                          _authController.storeClientData(
                              _nameController.text,
                              _titleController.text,
                              _phoneController.text,
                              _mobileController.text,
                              _websiteController.text,
                              _emailController.text,
                              _activityController.text,
                              photoUrl!,
                              gender!);
                        } else {
                          _authController.storeEngineerData(
                              _nameController.text,
                              _titleController.text,
                              _phoneController.text,
                              _mobileController.text,
                              _emailController.text,
                              photoUrl!,
                              gender!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: Text(ctl.isEngineer == false
                          ? 'ADD CLIENT'
                          : 'ADD ENGINEER'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
