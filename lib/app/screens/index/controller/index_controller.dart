import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_app/app/notifications/app_notification.dart';

class IndexController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await AppNotification.initialize();
      if (kDebugMode) print('[INDEX] Notifications initialized successfully');
    } catch (e) {
      if (kDebugMode) print('[INDEX ERROR] Notification initialization failed: $e');
    }
  }

  void changeTab(int index) {
    if (kDebugMode) print('[INDEX] Changing tab to: $index');
    currentIndex.value = index;
  }
}
