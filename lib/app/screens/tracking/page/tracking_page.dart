import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/tracking/controller/tracking_controller.dart';

class TrackingPage extends GetView<TrackingController> {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackingController>();
    return Scaffold(
      backgroundColor: AppColors.scaffloadColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Order Tracking',
          style: AppTextstyles.mediumText.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (controller.activeOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_shipping_outlined,
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
          onRefresh: () => controller.fetchActiveOrders(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.activeOrders.length,
            itemBuilder: (context, index) {
              final order = controller.activeOrders[index];
              return _buildOrderTrackingCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderTrackingCard(Map<String, dynamic> order) {
    final trackingSteps = order['trackingSteps'] as List<dynamic>? ?? [];
    final totalAmount = (order['totalAmount'] ?? 0.0).toDouble();
    final createdAt = order['createdAt'];
    final trackingStatus = order['trackingStatus'] ?? 'Order Placed';
    final orderId = order['id'] ?? '';
    final dateStr = createdAt != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(createdAt.toDate())
        : 'N/A';

    final isArrived = trackingStatus == 'Arrived';

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
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
              Text(
                'Order Total',
                style: AppTextstyles.smallText.copyWith(
                  color: AppColors.blackColor.withOpacity(0.6),
                ),
              ),
              Text(
                '${totalAmount.toStringAsFixed(0)}',
                style: AppTextstyles.xMediumText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          height6,
          Text(
            dateStr,
            style: AppTextstyles.xSmallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          height20,
          Text(
            'Tracking Status',
            style: AppTextstyles.mediumText.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          height16,
          ...trackingSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value as Map<String, dynamic>;
            final isCompleted = step['completed'] ?? false;
            final isLast = index == trackingSteps.length - 1;
            final stepName = step['step'] ?? '';
            final timestamp = step['timestamp'] ?? '';
            final timeStr = timestamp.isNotEmpty
                ? DateFormat('hh:mm a').format(DateTime.parse(timestamp))
                : '';

            return _buildTrackingStep(
              stepName: stepName,
              timeStr: timeStr,
              isCompleted: isCompleted,
              isLast: isLast,
            );
          }).toList(),
          if (isArrived) ...[
            height20,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
                  width12,
                  Expanded(
                    child: Text(
                      'Your order has arrived! Please confirm receipt.',
                      style: AppTextstyles.smallText.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height12,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.markAsReceived(orderId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, color: AppColors.whiteColor, size: 20.sp),
                    width8,
                    Text(
                      'Mark as Received',
                      style: AppTextstyles.smallText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingStep({
    required String stepName,
    required String timeStr,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primaryColor
                    : AppColors.scaffloadColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primaryColor
                      : AppColors.blackColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                      size: 14.sp,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: isCompleted
                    ? AppColors.primaryColor
                    : AppColors.blackColor.withOpacity(0.2),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepName,
                  style: AppTextstyles.smallText.copyWith(
                    color: isCompleted
                        ? AppColors.blackColor
                        : AppColors.blackColor.withOpacity(0.5),
                    fontWeight:
                        isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (timeStr.isNotEmpty)
                  Text(
                    timeStr,
                    style: AppTextstyles.xSmallText.copyWith(
                      color: AppColors.blackColor.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
