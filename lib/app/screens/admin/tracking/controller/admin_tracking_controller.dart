import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/models/order_model.dart';
import 'package:test_app/app/notifications/app_notification.dart';

class AdminTrackingController extends GetxController {
  final acceptedOrders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedOrders();
  }

  void fetchAcceptedOrders() {
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'accepted')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      acceptedOrders.clear();
      for (var doc in snapshot.docs) {
        acceptedOrders.add(OrderModel.fromFirestore(doc));
      }
      isLoading.value = false;
      if (kDebugMode) print('[ADMIN TRACKING] Accepted orders: ${acceptedOrders.length}');
    });
  }

  Future<void> updateTrackingStatus(String orderId, String newStatus) async {
    try {
      final steps = [
        'Order Placed',
        'In Kitchen',
        'Assembling',
        'Ready for Pickup',
        'On the Way',
        'Arrived'
      ];

      final stepIndex = steps.indexOf(newStatus);
      if (stepIndex == -1) return;

      final order = acceptedOrders.firstWhere((o) => o.orderId == orderId);
      final updatedSteps = List<Map<String, dynamic>>.from(
          order.trackingSteps.map((s) => s.toMap()));

      for (int i = 0; i <= stepIndex; i++) {
        if (i < updatedSteps.length) {
          updatedSteps[i]['completed'] = true;
          updatedSteps[i]['timestamp'] = DateTime.now().toIso8601String();
        }
      }

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'trackingStatus': newStatus,
        'trackingSteps': updatedSteps,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await AppNotification.sendOrderNotification(
        title: 'Order Update',
        body: 'Your order is now: $newStatus',
      );

      if (newStatus == 'Arrived') {
        await AppNotification.sendOrderNotification(
          title: 'Delivery Arrived!',
          body: 'Your order has arrived at your address. Please confirm receipt.',
        );
      }

      UI.showSnackBar(Get.context!, 'Status updated to $newStatus', isError: false);
      if (kDebugMode) print('[ADMIN TRACKING] Order $orderId updated to $newStatus');
    } catch (e) {
      if (kDebugMode) print('[ADMIN TRACKING ERROR] Failed to update status: $e');
      UI.showSnackBar(Get.context!, 'Failed to update status', isError: true);
    }
  }
}
