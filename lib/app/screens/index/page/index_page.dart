import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/screens/history/page/history_page.dart';
import 'package:test_app/app/screens/index/controller/index_controller.dart';
import 'package:test_app/app/screens/main/page/main_page.dart';
import 'package:test_app/app/screens/tracking/page/tracking_page.dart';

class IndexPage extends GetView<IndexController> {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            MainPage(),
            HistoryPage(),
            TrackingPage(),
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
                icon: Icon(Icons.restaurant_menu_rounded),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_rounded),
                label: 'Tracking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
