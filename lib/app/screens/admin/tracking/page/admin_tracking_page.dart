import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/tracking/controller/admin_tracking_controller.dart';
import 'package:test_app/app/screens/admin/widgets/tracking_update_dialog.dart';

class AdminTrackingPage extends GetView<AdminTrackingController> {
  const AdminTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffloadColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Active Orders',
          style: AppTextstyles.mediumText.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (controller.acceptedOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.track_changes_outlined,
                  size: 80.sp,
                  color: AppColors.blackColor.withOpacity(0.3),
                ),
                height20,
                Text(
                  'No active orders',
                  style: AppTextstyles.mediumText.copyWith(
                    color: AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchAcceptedOrders(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.acceptedOrders.length,
            itemBuilder: (context, index) {
              final order = controller.acceptedOrders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(order) {
    final dateStr = order.createdAt != null
        ? DateFormat('MMM dd, hh:mm a').format(order.createdAt!)
        : 'N/A';

    return GestureDetector(
      onTap: () => Get.dialog(
        TrackingUpdateDialog(order: order, controller: controller),
        barrierDismissible: true,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId?.substring(0, 8)}',
                        style: AppTextstyles.smallText.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      height6,
                      Text(
                        order.customerName,
                        style: AppTextstyles.smallText.copyWith(
                          color: AppColors.blackColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${order.totalAmount.toStringAsFixed(0)}',
                  style: AppTextstyles.xMediumText.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            height12,
            Row(
              children: [
                Icon(Icons.schedule, size: 14.sp, color: AppColors.blackColor.withOpacity(0.5)),
                width6,
                Text(
                  dateStr,
                  style: AppTextstyles.xSmallText.copyWith(
                    color: AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            height12,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                  width6,
                  Text(
                    order.trackingStatus ?? 'Order Placed',
                    style: AppTextstyles.smallText.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
