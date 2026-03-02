import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/core/widgets/custom_scaffold.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';
import 'package:test_app/app/screens/main/widgets/cart_drawer.dart';
import 'package:test_app/app/screens/main/widgets/cart_floating_button.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
   

    return CustomScaffold(
      child: Scaffold(
        backgroundColor: AppColors.scaffloadColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Food Menu',
            style: AppTextstyles.mediumText.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => controller.logout(),
            ),
          ],
        ),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.all(16.w),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.56,
              ),
              itemCount: controller.foodItems.length,
              itemBuilder: (context, index) {
                final item = controller.foodItems[index];
                return _buildFoodCard(item, controller);
              },
            ),
          ),
        ),
        floatingActionButton: const CartFloatingButton(),
        endDrawer: const CartDrawer(),
      ),
    );
  }

  Widget _buildFoodCard(dynamic item, MainController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.scaffloadColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.scaffloadColor,
                child: Icon(
                  Icons.restaurant,
                  color: AppColors.primaryColor,
                  size: 40.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
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
                    item.ingredients,
                    style: AppTextstyles.xSmallText.copyWith(
                      color: AppColors.blackColor.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Spacer(),
                  height14,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(0)}',
                        style: AppTextstyles.xMediumText.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.addToCart(
                          controller.convertToCartItem(item),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: AppColors.whiteColor,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
