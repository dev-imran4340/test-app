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
import 'package:test_app/app/screens/login/controller/login_controller.dart';

class LoginForm extends GetView<LoginController> {
  const LoginForm({super.key});

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
            InkWell(
              onTap: () {},
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forget Password!",
                      style: AppTextstyles.xSmallText.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            height30,
            Obx(
              () => CustomButton(
                loading: controller.isloading.value,
                text: "Login",
                textColor: AppColors.primaryColor,
                ontap: () => controller.isLogin(),
              ),
            ),
            height14,
            Obx(
              () => CustomButton(
                loading: controller.isGoogleLoading.value,
                text: "Login with Google",
                iconPath: AppIcons.google,
                textColor: AppColors.whiteColor,
                backColor: AppColors.primaryColor,
                loadingColor: AppColors.whiteColor,
                ontap: () => controller.signInWithGoogle(),
              ),
            ),
            height14,
            InkWell(
              onTap: () => Get.offNamed(AppRoutes.signup),
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                  child: Text(
                    "New Here? Create an Account",
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
