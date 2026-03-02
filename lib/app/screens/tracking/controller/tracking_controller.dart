import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/notifications/app_notification.dart';

class TrackingController extends GetxController {
  final storage = GetStorage();
  final activeOrders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveOrders();
    listenToActiveOrders();
  }

  Future<void> fetchActiveOrders() async {
    try {
      isLoading.value = true;
      final userId = storage.read('userId') ?? '';
      
      if (userId.isEmpty) {
        if (kDebugMode) print('[TRACKING ERROR] No user ID found');
        isLoading.value = false;
        return;
      }

      final pendingSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      final acceptedSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .orderBy('createdAt', descending: true)
          .get();

      activeOrders.clear();

      for (var doc in pendingSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        activeOrders.add(data);
      }

      for (var doc in acceptedSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        activeOrders.add(data);
      }

      activeOrders.sort((a, b) {
        final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      if (kDebugMode) print('[TRACKING] Active orders: ${activeOrders.length}');
    } catch (e) {
      if (kDebugMode) print('[TRACKING ERROR] Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void listenToActiveOrders() {
    final userId = storage.read('userId') ?? '';
    
    if (userId.isEmpty) {
      if (kDebugMode) print('[TRACKING ERROR] No user ID found');
      return;
    }

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      fetchActiveOrders();
    });

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((snapshot) {
      fetchActiveOrders();
    });
  }

  Future<void> markAsReceived(String orderId) async {
    try {
      if (kDebugMode) print('[TRACKING] Marking order $orderId as received...');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': 'delivered',
        'trackingStatus': 'Delivered',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await AppNotification.sendOrderNotification(
        title: 'Order Delivered!',
        body: 'Thank you for confirming receipt of your order.',
      );

      UI.showSnackBar(Get.context!, 'Order marked as delivered', isError: false);
      if (kDebugMode) print('[TRACKING] Order $orderId marked as delivered');
    } catch (e) {
      if (kDebugMode) print('[TRACKING ERROR] Failed to mark as received: $e');
      UI.showSnackBar(Get.context!, 'Failed to update order', isError: true);
    }
  }
}
