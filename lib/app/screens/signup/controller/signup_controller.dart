import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/routes/app_routes.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>(debugLabel: 'signupFormKey');
  final storage = GetStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  var isLoading = false.obs;
  var isGoogleLoading = false.obs;
  var isPasswordObscure = true.obs;
  var isConfirmPasswordObscure = true.obs;

  void changeObscure() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  void changeConfirmPasswordObscure() {
    isConfirmPasswordObscure.value = !isConfirmPasswordObscure.value;
  }

  Future<void> isSignup() async {
    if (formkey.currentState!.validate()) {
      try {
        if (kDebugMode) print('[SIGNUP] Starting email/password signup...');

        if (passwordController.text.trim() !=
            confirmPasswordController.text.trim()) {
          if (kDebugMode) print('[SIGNUP ERROR] Passwords do not match');
          UI.showSnackBar(Get.context!, "Passwords do not match",
              isError: true);
          return;
        }

        isLoading.value = true;
        if (kDebugMode) print('[SIGNUP] Email: ${emailController.text.trim()}');

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (kDebugMode) print('[SIGNUP] Firebase account created successfully');

        User? user = userCredential.user;

        if (user != null) {
          if (kDebugMode) print('[SIGNUP] User ID: ${user.uid}');
          if (kDebugMode) print('[SIGNUP] User Email: ${user.email}');

          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'userId': user.uid,
            'email': emailController.text.trim(),
          });
          if (kDebugMode) print('[SIGNUP] User data saved to Firestore');

          await storage.write('userId', user.uid);
          await storage.write('userEmail', user.email);
          if (kDebugMode) print('[SIGNUP] User data saved to local storage');

          UI.showSnackBar(Get.context!, "Signup successful!", isError: false);
          if (kDebugMode) print('[SIGNUP] Redirecting to login screen...');
          Get.offAllNamed(AppRoutes.login);
        } else {
          if (kDebugMode) print('[SIGNUP ERROR] User is null after registration');
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print('[SIGNUP ERROR] FirebaseAuthException:');
          print('  Code: ${e.code}');
          print('  Message: ${e.message}');
        }
        UI.showSnackBar(Get.context!, e.message ?? "An error occurred",
            isError: true);
      } catch (e) {
        if (kDebugMode) {
          print('[SIGNUP ERROR] Unexpected error: $e');
          print('  Type: ${e.runtimeType}');
        }
        UI.showSnackBar(Get.context!, "An unexpected error occurred",
            isError: true);
      } finally {
        isLoading.value = false;
        if (kDebugMode) print('[SIGNUP] Signup process completed');
      }
    } else {
      if (kDebugMode) print('[SIGNUP] Form validation failed');
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      if (kDebugMode) print('[GOOGLE SIGNUP] Starting Google Sign Up...');
      isGoogleLoading.value = true;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        if (kDebugMode) print('[GOOGLE SIGNUP] User cancelled Google Sign Up');
        isGoogleLoading.value = false;
        return;
      }

      if (kDebugMode) print('[GOOGLE SIGNUP] Google user selected: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (kDebugMode) print('[GOOGLE SIGNUP] Google authentication tokens received');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (kDebugMode) print('[GOOGLE SIGNUP] Firebase credential created');

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (kDebugMode) print('[GOOGLE SIGNUP] Firebase authentication successful');

      User? user = userCredential.user;
      if (user != null) {
        if (kDebugMode) print('[GOOGLE SIGNUP] User ID: ${user.uid}');
        if (kDebugMode) print('[GOOGLE SIGNUP] User Email: ${user.email}');

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email,
        });
        if (kDebugMode) print('[GOOGLE SIGNUP] User data saved to Firestore');

        await storage.write('userId', user.uid);
        await storage.write('userEmail', user.email);
        if (kDebugMode) print('[GOOGLE SIGNUP] User data saved to local storage');

        UI.showSnackBar(Get.context!, "Signup successful!", isError: false);
        if (kDebugMode) print('[GOOGLE SIGNUP] Redirecting to login screen...');
        Get.offAllNamed(AppRoutes.login);
      } else {
        if (kDebugMode) print('[GOOGLE SIGNUP ERROR] User is null after authentication');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[GOOGLE SIGNUP ERROR] Exception occurred: $e');
        print('  Type: ${e.runtimeType}');
        if (e is FirebaseAuthException) {
          print('  Code: ${e.code}');
          print('  Message: ${e.message}');
        }
      }
      UI.showSnackBar(Get.context!, "Google Sign Up failed", isError: true);
    } finally {
      isGoogleLoading.value = false;
      if (kDebugMode) print('[GOOGLE SIGNUP] Google Sign Up process completed');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
