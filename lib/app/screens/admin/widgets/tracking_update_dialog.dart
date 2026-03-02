import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/tracking/controller/admin_tracking_controller.dart';

class TrackingUpdateDialog extends StatelessWidget {
  final dynamic order;
  final AdminTrackingController controller;

  const TrackingUpdateDialog({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final trackingStatuses = [
      'In Kitchen',
      'Assembling',
      'Ready for Pickup',
      'On the Way',
      'Arrived',
    ];

    final currentStatus = order.trackingStatus ?? 'Order Placed';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 500.h),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Update Tracking',
                  style: AppTextstyles.xMediumText.copyWith(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.blackColor),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            height16,
            Text(
              'Order #${order.orderId?.substring(0, 8)}',
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor.withOpacity(0.6),
              ),
            ),
            height8,
            Text(
              order.customerName,
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            height20,
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                  width8,
                  Text(
                    'Current: $currentStatus',
                    style: AppTextstyles.smallText.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            height20,
            Text(
              'Update Status',
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            height12,
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trackingStatuses.length,
                itemBuilder: (context, index) {
                  final status = trackingStatuses[index];
                  final isCurrentStatus = status == currentStatus;
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: ElevatedButton(
                      onPressed: isCurrentStatus
                          ? null
                          : () {
                              controller.updateTrackingStatus(
                                order.orderId,
                                status,
                              );
                              Get.back();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCurrentStatus
                            ? AppColors.blackColor.withOpacity(0.3)
                            : AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            color: AppColors.whiteColor,
                            size: 20.sp,
                          ),
                          width8,
                          Text(
                            status,
                            style: AppTextstyles.smallText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isCurrentStatus) ...[
                            width8,
                            Icon(
                              Icons.check_circle,
                              color: AppColors.whiteColor,
                              size: 16.sp,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'In Kitchen':
        return Icons.kitchen;
      case 'Assembling':
        return Icons.build;
      case 'Ready for Pickup':
        return Icons.check_circle;
      case 'On the Way':
        return Icons.delivery_dining;
      case 'Arrived':
        return Icons.home;
      default:
        return Icons.info;
    }
  }
}
