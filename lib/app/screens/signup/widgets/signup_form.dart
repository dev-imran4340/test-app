import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/assets/app_icons.dart';
import 'package:test_app/app/core/utils/extenton.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/core/widgets/custom_button.dart';
import 'package:test_app/app/core/widgets/custom_text_field.dart';
import 'package:test_app/app/routes/app_routes.dart';
import 'package:test_app/app/screens/signup/controller/signup_controller.dart';

class SignupForm extends GetView<SignupController> {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Form(
        key: controller.formkey,
        child: Column(
          children: [
            CustomTextfeild(
              controller: controller.emailController,
              hinttext: "Enter Email",
              title: "Email",
              validator: (v) => v!.validEmail(),
            ),
            height10,
            Obx(
              () => CustomTextfeild(
                controller: controller.passwordController,
                hinttext: "Enter Password",
                title: "Password",
                validator: (v) => v!.validPassword(),
                obscureText: controller.isPasswordObscure.value,
                icon: IconButton(
                  onPressed: () => controller.changeObscure(),
                  icon: Icon(
                    !controller.isPasswordObscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            height10,
            Obx(
              () => CustomTextfeild(
                controller: controller.confirmPasswordController,
                hinttext: "Enter Confirm Password",
                title: "Confirm Password",
                validator: (v) => v!.validPassword(),
                obscureText: controller.isConfirmPasswordObscure.value,
                icon: IconButton(
                  onPressed: () => controller.changeConfirmPasswordObscure(),
                  icon: Icon(
                    !controller.isConfirmPasswordObscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            height30,
            Obx(
              () => CustomButton(
                loading: controller.isLoading.value,
                text: "Register",
                textColor: AppColors.primaryColor,
                ontap: () => controller.isSignup(),
              ),
            ),
            height14,
            Obx(
              () => CustomButton(
                loading: controller.isGoogleLoading.value,
                text: "Register with Google",
                iconPath: AppIcons.google,
                textColor: AppColors.whiteColor,
                backColor: AppColors.primaryColor,
                ontap: () => controller.signUpWithGoogle(),
              ),
            ),
            height14,
            InkWell(
              onTap: () => Get.offNamed(AppRoutes.login),
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                  child: Text(
                    "Already have account? Login here",
                    style: AppTextstyles.smallText.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
