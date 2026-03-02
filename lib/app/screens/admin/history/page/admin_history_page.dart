import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/admin/history/controller/admin_history_controller.dart';

class AdminHistoryPage extends GetView<AdminHistoryController> {
  const AdminHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffloadColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Order History',
            style: AppTextstyles.mediumText.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.whiteColor,
            labelColor: AppColors.whiteColor,
            unselectedLabelColor: AppColors.whiteColor.withOpacity(0.6),
            tabs: const [
              Tab(text: 'Delivered'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return TabBarView(
            children: [
              _buildOrderList(controller.deliveredOrders, 'delivered'),
              _buildOrderList(controller.cancelledOrders, 'cancelled'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List orders, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'delivered'
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              size: 80.sp,
              color: AppColors.blackColor.withOpacity(0.3),
            ),
            height20,
            Text(
              'No $status orders',
              style: AppTextstyles.mediumText.copyWith(
                color: AppColors.blackColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchHistory(),
      color: AppColors.primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, status);
        },
      ),
    );
  }

  Widget _buildOrderCard(order, String status) {
    final items = order.items as List<dynamic>;
    final dateStr = order.createdAt != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt!)
        : 'N/A';

    Color statusColor = status == 'delivered' ? Colors.green : Colors.red;
    IconData statusIcon = status == 'delivered' ? Icons.check_circle : Icons.cancel;

    return Container(
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
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20.sp),
                  width8,
                  Text(
                    status.toUpperCase(),
                    style: AppTextstyles.smallText.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
          height6,
          Text(
            dateStr,
            style: AppTextstyles.xSmallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          height8,
          Text(
            '${items.length} item${items.length > 1 ? 's' : ''}',
            style: AppTextstyles.smallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
