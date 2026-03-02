import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/screens/admin/dashboard/page/admin_dashboard_page.dart';
import 'package:test_app/app/screens/admin/history/page/admin_history_page.dart';
import 'package:test_app/app/screens/admin/index/controller/admin_index_controller.dart';
import 'package:test_app/app/screens/admin/orders/page/admin_orders_page.dart';
import 'package:test_app/app/screens/admin/tracking/page/admin_tracking_page.dart';

class AdminIndexPage extends GetView<AdminIndexController> {
  const AdminIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            AdminDashboardPage(),
            AdminOrdersPage(),
            AdminTrackingPage(),
            AdminHistoryPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.blackColor.withOpacity(0.5),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions_rounded),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_rounded),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
