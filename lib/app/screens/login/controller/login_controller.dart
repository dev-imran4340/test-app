import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>(debugLabel: 'loginFormKey');
  final storage = GetStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  var isloading = false.obs;
  var isGoogleLoading = false.obs;
  var isPasswordObscure = true.obs;

  void changeObscure() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  Future<void> isLogin() async {
    if (formkey.currentState!.validate()) {
      try {
        if (kDebugMode) print('[LOGIN] Starting email/password login...');
        isloading.value = true;

        if (kDebugMode) print('[LOGIN] Email: ${emailController.text.trim()}');

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (kDebugMode) print('[LOGIN] Firebase authentication successful');

        User? user = userCredential.user;
        if (user != null) {
          if (kDebugMode) print('[LOGIN] User ID: ${user.uid}');
          if (kDebugMode) print('[LOGIN] User Email: ${user.email}');

          await storage.write('userId', user.uid);
          await storage.write('userEmail', user.email);
          
          final isAdmin = user.email == 'admin@gmail.com';
          await storage.write('isAdmin', isAdmin);
          
          if (kDebugMode) print('[LOGIN] User data saved to local storage');
          if (kDebugMode) print('[LOGIN] Is Admin: $isAdmin');

          UI.showSnackBar(Get.context!, "Login Successfully", isError: false);
          
          if (isAdmin) {
            if (kDebugMode) print('[LOGIN] Redirecting to admin dashboard...');
            Get.offAllNamed(AppRoutes.adminDashboard);
          } else {
            if (kDebugMode) print('[LOGIN] Redirecting to main screen...');
            Get.offAllNamed(AppRoutes.main);
          }
        } else {
          if (kDebugMode) print('[LOGIN ERROR] User is null after authentication');
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (kDebugMode) {
            print('[LOGIN ERROR] FirebaseAuthException:');
            print('  Code: ${e.code}');
            print('  Message: ${e.message}');
          }
          UI.showSnackBar(
            Get.context!,
            e.message ?? "Login failed",
            isError: true,
          );
        } else {
          if (kDebugMode) {
            print('[LOGIN ERROR] Unexpected error: $e');
            print('  Type: ${e.runtimeType}');
          }
          UI.showSnackBar(Get.context!, "Login failed", isError: true);
        }
      } finally {
        isloading.value = false;
        emailController.clear();
        passwordController.clear();
        if (kDebugMode) print('[LOGIN] Login process completed');
      }
    } else {
      if (kDebugMode) print('[LOGIN] Form validation failed');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      if (kDebugMode) print('[GOOGLE LOGIN] Starting Google Sign In...');
      isGoogleLoading.value = true;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        if (kDebugMode) print('[GOOGLE LOGIN] User cancelled Google Sign In');
        isGoogleLoading.value = false;
        return;
      }

      if (kDebugMode) print('[GOOGLE LOGIN] Google user selected: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (kDebugMode) print('[GOOGLE LOGIN] Google authentication tokens received');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (kDebugMode) print('[GOOGLE LOGIN] Firebase credential created');

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (kDebugMode) print('[GOOGLE LOGIN] Firebase authentication successful');

      User? user = userCredential.user;
      if (user != null) {
        if (kDebugMode) print('[GOOGLE LOGIN] User ID: ${user.uid}');
        if (kDebugMode) print('[GOOGLE LOGIN] User Email: ${user.email}');

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email,
        }, SetOptions(merge: true));
        if (kDebugMode) print('[GOOGLE LOGIN] User data saved to Firestore');

        await storage.write('userId', user.uid);
        await storage.write('userEmail', user.email);
        
        final isAdmin = user.email == 'admin@gmail.com';
        await storage.write('isAdmin', isAdmin);
        
        if (kDebugMode) print('[GOOGLE LOGIN] User data saved to local storage');
        if (kDebugMode) print('[GOOGLE LOGIN] Is Admin: $isAdmin');

        UI.showSnackBar(Get.context!, "Login Successfully", isError: false);
        
        if (isAdmin) {
          if (kDebugMode) print('[GOOGLE LOGIN] Redirecting to admin dashboard...');
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else {
          if (kDebugMode) print('[GOOGLE LOGIN] Redirecting to main screen...');
          Get.offAllNamed(AppRoutes.main);
        }
      } else {
        if (kDebugMode) print('[GOOGLE LOGIN ERROR] User is null after authentication');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[GOOGLE LOGIN ERROR] Exception occurred: $e');
        print('  Type: ${e.runtimeType}');
        if (e is FirebaseAuthException) {
          print('  Code: ${e.code}');
          print('  Message: ${e.message}');
        }
      }
      UI.showSnackBar(Get.context!, "Google Sign In failed", isError: true);
    } finally {
      isGoogleLoading.value = false;
      if (kDebugMode) print('[GOOGLE LOGIN] Google Sign In process completed');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
