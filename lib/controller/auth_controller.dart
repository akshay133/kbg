import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kbg/screens/home_screen_main.dart';
import 'package:kbg/screens/splash_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  @override
  void onReady() {
    ever(firebaseUser, handleAuth);
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onReady();
  }

  handleAuth(firebaseUser) {
    if (firebaseUser == null || _auth.currentUser?.uid == null) {
      Get.offAll(const SplashScreen());
    } else {
      Get.offAll(HomeScreenMain());
    }
  }

  loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAll(HomeScreenMain());
      });
    } on FirebaseAuthException catch (err) {
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
          .doc(_auth.currentUser!.uid)
          .set({
        "name": name,
        'title': title,
        'phone': phone,
        'mobile': mobile,
        'website': website,
        'email': email,
        'activity': activity,
        'imgUrl': imgUrl,
        'gender': gender
      }).then((value) {
        Get.snackbar("New Client Added", "");
      });
    } on FirebaseException catch (err) {
      Get.snackbar("error!", err.message!, snackPosition: SnackPosition.BOTTOM);
    }
  }

  logout() async {
    await _auth.signOut();
  }
}
