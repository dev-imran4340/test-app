import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/dashboard/controller/admin_dashboard_controller.dart';

class OrderDetailDialog extends StatelessWidget {
  final dynamic order;
  final AdminDashboardController controller;

  const OrderDetailDialog({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final items = order.items as List<dynamic>;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 600.h),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
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
            height20,
            Text(
              'Customer Information',
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            height10,
            _buildInfoRow(Icons.person, order.customerName),
            height8,
            _buildInfoRow(Icons.email, order.customerEmail),
            height8,
            _buildInfoRow(Icons.phone, order.customerPhone),
            height8,
            _buildInfoRow(Icons.location_on, order.customerAddress),
            height20,
            Text(
              'Order Items',
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            height10,
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['name']} x ${item['quantity']}',
                            style: AppTextstyles.xSmallText.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        Text(
                          '${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                          style: AppTextstyles.xSmallText.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            height12,
            Divider(color: AppColors.blackColor.withOpacity(0.2)),
            height12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextstyles.smallText.copyWith(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
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
            height20,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.cancelOrder(order.orderId);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextstyles.smallText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                width12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.acceptOrder(order.orderId);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Accept',
                      style: AppTextstyles.smallText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.blackColor.withOpacity(0.6)),
        width8,
        Expanded(
          child: Text(
            text,
            style: AppTextstyles.xSmallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
