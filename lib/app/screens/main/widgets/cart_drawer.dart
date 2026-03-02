import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/core/widgets/custom_button.dart';
import 'package:test_app/app/routes/app_routes.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Drawer(
      backgroundColor: AppColors.scaffloadColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              color: AppColors.primaryColor,
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: AppColors.whiteColor,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'My Cart',
                    style: AppTextstyles.mediumText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (mainController.cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 60.sp,
                          color: AppColors.blackColor.withOpacity(0.3),
                        ),
                        height20,
                        Text(
                          'Your cart is empty',
                          style: AppTextstyles.mediumText.copyWith(
                            color: AppColors.blackColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: mainController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = mainController.cartItems[index];
                    return _buildCartItem(item, mainController);
                  },
                );
              }),
            ),
            Obx(() {
              if (mainController.cartItems.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: AppTextstyles.xSmallText.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${mainController.totalAmount.toStringAsFixed(0)}',
                          style: AppTextstyles.mediumText.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    height20,
                    CustomButton(
                      text: "CheckOut",
                      backColor: AppColors.primaryColor,
                      textColor: AppColors.whiteColor,
                      ontap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.checkout);
                      },
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50.h,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Get.back();
                    //       Get.toNamed(AppRoutes.checkout);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: AppColors.primaryColor,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.r),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Checkout',
                    //       style: AppTextstyles.mediumText.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(dynamic item, MainController mainController) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: AppColors.scaffloadColor),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.scaffloadColor,
                    child: Icon(
                      Icons.restaurant,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextstyles.smallText.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    height6,
                    Text(
                      '${item.price.toStringAsFixed(0)}',
                      style: AppTextstyles.xSmallText.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => mainController.decreaseQuantity(item.id),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffloadColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${item.quantity}',
                style: AppTextstyles.smallText.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () => mainController.increaseQuantity(item.id),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18.sp,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
