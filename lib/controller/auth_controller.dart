import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kbg/constants/shapes_and_styles.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/screens/home_screen_main.dart';
import 'package:kbg/screens/splash_screen.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  var clientId = ''.obs;
  var adminId = ''.obs;
  var adminProfileImg = ''.obs;
  var adminEmail = '';
  var engineerId = ''.obs;
  late GetStorage box;

  @override
  void onReady() {
    handleAuth();
    super.onReady();
  }

  handleAuth() async {
    box = GetStorage();
    box.read(ConstStrings.engineerId);
    box.read(ConstStrings.clientId);

    if (box.read(ConstStrings.adminId) == null) {
      Get.offAll(const SplashScreen());
    } else {
      Get.offAll(HomeScreenMain());
    }
  }

  loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        box.write(ConstStrings.adminId, value.user!.uid);
        box.write(ConstStrings.adminEmail, value.user!.email.toString());
        updateAdminEmail(value.user!.email);
        Get.offAll(HomeScreenMain());
      });
    } on FirebaseAuthException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  loginClientWithEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        var email = value.user!.email;
      });
    } on FirebaseAuthException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  registerClientWithEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          Get.snackbar("Registered", "");
          box.write(ConstStrings.clientId, value.user!.uid);
          Get.bottomSheet(BottomSheetWidget());
        }
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  registerEngineerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          Get.snackbar("Registered", "");
          box.write(ConstStrings.engineerId, value.user!.uid);
          Get.bottomSheet(BottomSheetWidget());
        }
      });
    } on FirebaseException catch (e) {
      Get.snackbar("error!", e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  storeEngineerData(String name, String title, String phone, String mobile,
      String email, String imgUrl, String gender) async {
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      await FirebaseFirestore.instance
          .collection("engineers")
          .doc(box.read(ConstStrings.engineerId))
          .set({
        "name": name,
        'title': title,
        'phone': phone,
        'mobile': mobile,
        'email': email,
        'imgUrl': imgUrl,
        'gender': gender,
        'projects': [],
        'uid': box.read(ConstStrings.engineerId)
      }).then((value) {
        Get.snackbar("New Engineer Added", "");
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateEngineers(String name, String title, String phone, String mobile,
      String email, String imgUrl, String gender, List projects) async {
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      await FirebaseFirestore.instance
          .collection("engineers")
          .doc(box.read(ConstStrings.engineerId))
          .update({
        "name": name,
        'title': title,
        'phone': phone,
        'mobile': mobile,
        'email': email,
        'imgUrl': imgUrl,
        'gender': gender,
        'projects': FieldValue.arrayUnion(projects),
        'uid': box.read(ConstStrings.engineerId)
      }).then((value) {
        Get.snackbar("New Engineer Added", "");
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  storeClientData(
      String name,
      String title,
      String phone,
      String mobile,
      String website,
      String email,
      String activity,
      String imgUrl,
      String gender) async {
    final setData = {
      "name": name,
      'title': title,
      'phone': phone,
      'mobile': mobile,
      'website': website,
      'email': email,
      'activity': activity,
      'imgUrl': imgUrl,
      'gender': gender,
      'projects': [],
      'uid': box.read(ConstStrings.clientId)
    };
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      await FirebaseFirestore.instance
          .collection("clients")
          .doc(box.read(ConstStrings.clientId))
          .set(setData)
          .then((value) {
        Get.snackbar("New Client Added", "");
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateSingleClientInfo(
      String uid, String name, String phone, String email, String imgUrl) {
    final updateData = {
      "name": name,
      'phone': phone,
      'email': email,
      'imgUrl': imgUrl,
    };
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .update(updateData);
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateClients(
      String name,
      String title,
      String phone,
      String mobile,
      String website,
      String email,
      String activity,
      String imgUrl,
      String gender,
      List projects) {
    final updateData = {
      "name": name,
      'title': title,
      'phone': phone,
      'mobile': mobile,
      'website': website,
      'email': email,
      'activity': activity,
      'imgUrl': imgUrl,
      'gender': gender,
      'projects': FieldValue.arrayUnion(projects),
      'uid': box.read(ConstStrings.clientId)
    };
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      FirebaseFirestore.instance
          .collection('clients')
          .doc(box.read(ConstStrings.clientId))
          .update(updateData);
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  logout() async {
    await _auth.signOut();
    box.erase().then((value) => Get.offAll(SplashScreen()));
  }

  updateClientId(id) {
    clientId = id;
    update();
  }

  updateAdmin(id) async {
    adminId = id;
    update();
  }

  updateAdminImg(img) {
    adminProfileImg = img;
    update();
  }

  updateAdminEmail(email) async {
    adminEmail = email;
    update();
  }
}
