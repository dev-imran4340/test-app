import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/assets/app_images.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/core/widgets/custom_scaffold.dart';
import 'package:test_app/app/screens/login/controller/login_controller.dart';
import 'package:test_app/app/screens/login/widgets/login_form.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height20,
                Image.asset(AppImages.img1),
                height24,
                Text("Welome Back",
                    style: AppTextstyles.largeText
                        .copyWith(fontWeight: FontWeight.bold)),
                height6,
                Text("Login to your account",
                    style: AppTextstyles.smallText
                        .copyWith(fontWeight: FontWeight.w300)),
                height18,
                LoginForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
