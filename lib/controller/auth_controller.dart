import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/screens/home_screen_main.dart';
import 'package:kbg/screens/splash_screen.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  var clientId = ''.obs;
  var adminId = ''.obs;
  var adminProfileImg = ''.obs;
  var adminEmail = '';
  late SharedPreferences preferences;
  @override
  void onReady() {
    handleAuth();
    super.onReady();
  }

  handleAuth() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.get(ConstStrings.adminId) == null) {
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
        preferences = await SharedPreferences.getInstance();
        preferences.setString(ConstStrings.adminId, value.user!.uid);
        preferences.setString(
            ConstStrings.adminEmail, value.user!.email.toString());
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
          .doc(_auth.currentUser!.uid + DateTime.now().toString())
          .set({
        "name": name,
        'title': title,
        'phone': phone,
        'mobile': mobile,
        'email': email,
        'imgUrl': imgUrl,
        'gender': gender,
        'projects': [],
        'uid': _auth.currentUser!.uid
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
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      await FirebaseFirestore.instance
          .collection("clients")
          .doc(_auth.currentUser!.uid + DateTime.now().toString())
          .set({
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
        'uid': _auth.currentUser!.uid
      }).then((value) {
        Get.snackbar("New Client Added", "");
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  logout() async {
    await _auth.signOut();
    preferences.clear().then((value) => Get.offAll(SplashScreen()));
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
