import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/core/widgets/custom_button.dart';
import 'package:test_app/app/core/widgets/custom_text_field.dart';
import 'package:test_app/app/screens/checkout/controller/checkout_controller.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Scaffold(
      backgroundColor: AppColors.scaffloadColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Checkout',
          style: AppTextstyles.mediumText.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Information',
                style: AppTextstyles.mediumText.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              height20,
              CustomTextfeild(
                textColor: AppColors.blackColor,
                controller: controller.nameController,
                cursorColor: AppColors.blackColor,
                hintcolor: AppColors.blackColor,
                outlinebordercolor: AppColors.primaryColor,
                filled: true,
                titleColor: AppColors.blackColor,
                enablebordercolor: AppColors.primaryColor,
                focusbordercolor: AppColors.primaryColor,
                fillcolor: AppColors.primaryColor.withOpacity(0.1),
                hinttext: "Enter Your Name",
                title: "Full Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              height10,
              CustomTextfeild(
                textColor: AppColors.blackColor,
                cursorColor: AppColors.blackColor,
                // hintcolor: AppColors.blackColor,
                hintcolor: AppColors.primaryColor,
                outlinebordercolor: AppColors.primaryColor,
                filled: true,
                titleColor: AppColors.blackColor,
                enablebordercolor: AppColors.primaryColor,
                focusbordercolor: AppColors.primaryColor,
                fillcolor: AppColors.primaryColor.withOpacity(0.1),
                controller: controller.emailController,
                hinttext: "Enter Email",
                title: "Email",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              height10,
              CustomTextfeild(
                textColor: AppColors.blackColor,
                cursorColor: AppColors.blackColor,
                hintcolor: AppColors.blackColor,
                outlinebordercolor: AppColors.primaryColor,
                filled: true,
                titleColor: AppColors.blackColor,
                enablebordercolor: AppColors.primaryColor,
                focusbordercolor: AppColors.primaryColor,
                fillcolor: AppColors.primaryColor.withOpacity(0.1),
                controller: controller.phoneController,
                hinttext: "Enter Phone Number",
                title: "Phone Number",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              height10,
              CustomTextfeild(
                textColor: AppColors.blackColor,
                cursorColor: AppColors.blackColor,
                hintcolor: AppColors.blackColor,
                outlinebordercolor: AppColors.primaryColor,
                filled: true,
                titleColor: AppColors.blackColor,
                enablebordercolor: AppColors.primaryColor,
                focusbordercolor: AppColors.primaryColor,
                fillcolor: AppColors.primaryColor.withOpacity(0.1),
                controller: controller.addressController,
                hinttext: "Enter Delivery Address",
                title: "Address",
                // maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              height30,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: AppTextstyles.mediumText.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height10,
                    Obx(() {
                      return Column(
                        children: [
                          ...mainController.cartItems.map(
                            (item) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.name} x ${item.quantity}',
                                      style: AppTextstyles.smallText.copyWith(
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: AppTextstyles.smallText.copyWith(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 20.h,
                            color: AppColors.blackColor.withOpacity(0.1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: AppTextstyles.xMediumText.copyWith(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${mainController.totalAmount.toStringAsFixed(0)}',
                                style: AppTextstyles.xLargeText.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              height30,
              Obx(
                () => CustomButton(
                  loading: controller.isLoading.value,
                  text: "Place Order",
                  textColor: AppColors.whiteColor,
                  backColor: AppColors.primaryColor,
                  loadingColor: AppColors.whiteColor,
                  ontap: () => controller.placeOrder(),
                ),
              ),
              height20,
            ],
          ),
        ),
      ),
    );
  }
}
