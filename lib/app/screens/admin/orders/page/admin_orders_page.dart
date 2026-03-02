import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/orders/controller/admin_orders_controller.dart';
import 'package:test_app/app/screens/admin/widgets/order_detail_dialog.dart';
import 'package:test_app/app/screens/admin/dashboard/controller/admin_dashboard_controller.dart';

class AdminOrdersPage extends GetView<AdminOrdersController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffloadColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Pending Orders',
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

        if (controller.pendingOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pending_outlined,
                  size: 80.sp,
                  color: AppColors.blackColor.withOpacity(0.3),
                ),
                height20,
                Text(
                  'No pending orders',
                  style: AppTextstyles.mediumText.copyWith(
                    color: AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchPendingOrders(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.pendingOrders.length,
            itemBuilder: (context, index) {
              final order = controller.pendingOrders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(order) {
    final items = order.items as List<dynamic>;
    final dateStr = order.createdAt != null
        ? DateFormat('MMM dd, hh:mm a').format(order.createdAt!)
        : 'N/A';

    return GestureDetector(
      onTap: () {
        final dashboardController = Get.find<AdminDashboardController>();
        Get.dialog(
          OrderDetailDialog(order: order, controller: dashboardController),
          barrierDismissible: true,
        );
      },
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
                width16,
                Icon(Icons.shopping_bag, size: 14.sp, color: AppColors.blackColor.withOpacity(0.5)),
                width6,
                Text(
                  '${items.length} items',
                  style: AppTextstyles.xSmallText.copyWith(
                    color: AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            height12,
            Row(
              children: [
                Icon(Icons.location_on, size: 14.sp, color: AppColors.blackColor.withOpacity(0.5)),
                width6,
                Expanded(
                  child: Text(
                    order.customerAddress,
                    style: AppTextstyles.xSmallText.copyWith(
                      color: AppColors.blackColor.withOpacity(0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
