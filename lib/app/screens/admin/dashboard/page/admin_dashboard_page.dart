import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/dashboard/controller/admin_dashboard_controller.dart';
import 'package:test_app/app/screens/admin/widgets/order_detail_dialog.dart';

class AdminDashboardPage extends GetView<AdminDashboardController> {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffloadColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Admin Dashboard',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchAllOrders(),
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Orders',
                        controller.totalOrders.value.toString(),
                        Icons.receipt_long_rounded,
                        Colors.blue,
                      ),
                    ),
                    width12,
                    Expanded(
                      child: _buildStatCard(
                        'Revenue',
                        '${controller.totalRevenue.value.toStringAsFixed(0)}',
                        Icons.attach_money_rounded,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                height12,
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Pending',
                        controller.pendingCount.value.toString(),
                        Icons.pending_rounded,
                        Colors.orange,
                      ),
                    ),
                    width12,
                    Expanded(
                      child: _buildStatCard(
                        'Today',
                        controller.deliveredToday.value.toString(),
                        Icons.check_circle_rounded,
                        Colors.teal,
                      ),
                    ),
                  ],
                ),
                height20,
                Text(
                  'Pending Orders',
                  style: AppTextstyles.xMediumText.copyWith(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height12,
                if (controller.pendingOrders.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60.sp,
                            color: AppColors.blackColor.withOpacity(0.3),
                          ),
                          height12,
                          Text(
                            'No pending orders',
                            style: AppTextstyles.smallText.copyWith(
                              color: AppColors.blackColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...controller.pendingOrders.map((order) {
                    return _buildOrderCard(order);
                  }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          height12,
          Text(
            value,
            style: AppTextstyles.xLargeText.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          height6,
          Text(
            title,
            style: AppTextstyles.xSmallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(order) {
    final items = order.items as List<dynamic>;
    final dateStr = order.createdAt != null
        ? DateFormat('MMM dd, hh:mm a').format(order.createdAt!)
        : 'N/A';

    return GestureDetector(
      onTap: () => Get.dialog(
        OrderDetailDialog(order: order, controller: controller),
        barrierDismissible: true,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
                  'Order #${order.orderId?.substring(0, 8)}',
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
            height8,
            Text(
              order.customerName,
              style: AppTextstyles.smallText.copyWith(
                color: AppColors.blackColor.withOpacity(0.7),
              ),
            ),
            height6,
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
          ],
        ),
      ),
    );
  }
}
