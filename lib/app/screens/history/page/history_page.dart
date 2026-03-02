import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_spaces.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';
import 'package:test_app/app/screens/history/controller/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'Pending'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Delivered'),
            ],
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

          return TabBarView(
            children: [
              _buildOrderList(controller.pendingOrders, 'pending'),
              _buildOrderList(controller.cancelledOrders, 'cancelled'),
              _buildOrderList(controller.deliveredOrders, 'delivered'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'pending'
                  ? Icons.pending_outlined
                  : status == 'cancelled'
                      ? Icons.cancel_outlined
                      : Icons.check_circle_outline,
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
      onRefresh: () => controller.fetchOrders(),
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

  Widget _buildOrderCard(Map<String, dynamic> order, String status) {
    final items = order['items'] as List<dynamic>? ?? [];
    final totalAmount = (order['totalAmount'] ?? 0.0).toDouble();
    final createdAt = order['createdAt'];
    final dateStr = createdAt != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(createdAt.toDate())
        : 'N/A';

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'delivered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

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
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
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
                '${totalAmount.toStringAsFixed(0)}',
                style: AppTextstyles.xMediumText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          height10,
          Text(
            dateStr,
            style: AppTextstyles.xSmallText.copyWith(
              color: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          height10,
          Text(
            '${items.length} item${items.length > 1 ? 's' : ''}',
            style: AppTextstyles.smallText.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          if (items.isNotEmpty) ...[
            height8,
            ...items.take(2).map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    '• ${item['name']} x ${item['quantity']}',
                    style: AppTextstyles.xSmallText.copyWith(
                      color: AppColors.blackColor.withOpacity(0.7),
                    ),
                  ),
                )),
            if (items.length > 2)
              Text(
                '  and ${items.length - 2} more...',
                style: AppTextstyles.xSmallText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
