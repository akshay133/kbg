import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;
  bool isEngineer = false;
  List activitiesList = [];
  late DocumentSnapshot snapshot;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  deleteActivity(projectNum, element) {
    try {
      FirebaseFirestore.instance.collection("projects").doc(projectNum).update({
        'activities': FieldValue.arrayRemove([element])
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("error!", e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateActivity(
    projectNum,
    name,
    percentage,
  ) {
    final data = {
      'name': name,
      'percentage': percentage,
    };
    try {
      FirebaseFirestore.instance.collection("projects").doc(projectNum).update({
        'activities': FieldValue.arrayUnion([data])
      }).then((value) => Get.back());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("error!", e.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void checkUserEngineer(bool user) {
    isEngineer = user;
    update();
  }

  updateList(activities) {
    activitiesList.add(activities);
    update();
  }

  updateDocSnapshot(snap) {
    snapshot = snap;
    update();
  }
}
