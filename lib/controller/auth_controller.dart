import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kbg/constants/shapes_and_styles.dart';
import 'package:kbg/constants/strings.dart';
import 'package:kbg/screens/client_home_screen_main.dart';
import 'package:kbg/screens/engineers_home_screen_main.dart';
import 'package:kbg/screens/home_screen_main.dart';
import 'package:kbg/screens/splash_screen.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    updateClientId(box.read(ConstStrings.clientId).toString().obs);
    updateAdmin(box.read(ConstStrings.adminId).toString().obs);
    updateEngineerId(box.read(ConstStrings.engineerId).toString().obs);
    if (box.read(ConstStrings.adminId) == null &&
        box.read(ConstStrings.clientIdStore) == null &&
        box.read(ConstStrings.engineerIdStore) == null) {
      Get.offAll(const SplashScreen());
    } else if (box.read(ConstStrings.clientIdStore) == true) {
      Get.offAll(ClientHomeScreenMain());
    } else if (box.read(ConstStrings.engineerIdStore) == true) {
      Get.offAll(EngineersHomeScreenMain());
    } else {
      Get.offAll(HomeScreenMain());
    }
  }

  loginWithEmailAndPassword(String email, String password, role) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (role == 'client') {
          box.write(ConstStrings.clientId, value.user!.uid);
          box.write(ConstStrings.clientEmail, value.user!.email);
          box
              .write(ConstStrings.clientIdStore, true)
              .then((value) => Get.offAll(ClientHomeScreenMain()));
        } else if (role == 'engineer') {
          box.write(ConstStrings.engineerId, value.user!.uid);
          box.write(ConstStrings.engineerEmail, value.user!.email);
          box
              .write(ConstStrings.engineerIdStore, true)
              .then((value) => Get.offAll(EngineersHomeScreenMain()));
        } else if (role == 'admin') {
          box.write(ConstStrings.adminId, value.user!.uid);
          box.write(ConstStrings.adminEmail, value.user!.email.toString());
          updateAdminEmail(value.user!.email);
          Get.offAll(HomeScreenMain());
        }
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
        'role': 'engineer',
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
      'role': 'client',
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

  storeProjectData(projectNum, name, type, selectedStartDate, selectedEndDate,
      activitiesList) {
    try {
      FirebaseFirestore.instance.collection("projects").doc(projectNum).set({
        'name': name,
        'number': projectNum,
        'type': type,
        'start_date': "${selectedStartDate?.toLocal()}".split(' ')[0],
        'end_date': "${selectedEndDate?.toLocal()}".split(' ')[0],
        'activities': activitiesList,
        'assigned': [],
        'imagesUrls': [],
      }).then(
        (value) => Get.back(),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("error!", e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateSingleEngineerInfo(
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
          .collection('engineers')
          .doc(uid)
          .update(updateData)
          .then((value) => Get.back());
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
          .update(updateData)
          .then((value) => Get.back());
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateClientsProjects(uid, projectIds) {
    final updateData = {
      'projects': FieldValue.arrayUnion([projectIds]),
    };
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .update(updateData)
          .then((value) {
        FirebaseFirestore.instance
            .collection("projects")
            .doc(projectIds)
            .update({
          'assigned': FieldValue.arrayUnion([uid])
        });
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateEngineersProjects(uid, projectIds) {
    final updateData = {
      'projects': FieldValue.arrayUnion([projectIds]),
    };
    try {
      Get.snackbar("Please wait...", '', snackPosition: SnackPosition.BOTTOM);
      FirebaseFirestore.instance
          .collection('engineers')
          .doc(uid)
          .update(updateData)
          .then((value) {
        FirebaseFirestore.instance
            .collection("projects")
            .doc(projectIds)
            .update({
          'assigned': FieldValue.arrayUnion([uid])
        });
      });
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

  updateEngineerId(id) {
    engineerId = id;
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
