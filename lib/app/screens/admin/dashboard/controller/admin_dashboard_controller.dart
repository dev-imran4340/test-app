import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/models/order_model.dart';
import 'package:test_app/app/routes/app_routes.dart';

class AdminDashboardController extends GetxController {
  final storage = GetStorage();
  final googleSignIn = GoogleSignIn();
  
  final allOrders = <OrderModel>[].obs;
  final pendingOrders = <OrderModel>[].obs;
  final deliveredOrders = <OrderModel>[].obs;
  final cancelledOrders = <OrderModel>[].obs;
  final isLoading = false.obs;
  
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final pendingCount = 0.obs;
  final deliveredToday = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  void fetchAllOrders() {
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      allOrders.clear();
      pendingOrders.clear();
      deliveredOrders.clear();
      cancelledOrders.clear();

      for (var doc in snapshot.docs) {
        final order = OrderModel.fromFirestore(doc);
        allOrders.add(order);

        if (order.status == 'pending') {
          pendingOrders.add(order);
        } else if (order.status == 'delivered') {
          deliveredOrders.add(order);
        } else if (order.status == 'cancelled') {
          cancelledOrders.add(order);
        }
      }

      _calculateStats();
      isLoading.value = false;
    });
  }

  void _calculateStats() {
    totalOrders.value = allOrders.length;
    totalRevenue.value = deliveredOrders.fold(
        0.0, (sum, order) => sum + order.totalAmount);
    pendingCount.value = pendingOrders.length;

    final now = DateTime.now();
    deliveredToday.value = deliveredOrders.where((order) {
      if (order.createdAt != null) {
        final orderDate = order.createdAt!;
        return orderDate.year == now.year &&
            orderDate.month == now.month &&
            orderDate.day == now.day;
      }
      return false;
    }).length;
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      UI.showSnackBar(Get.context!, 'Order accepted', isError: false);
      if (kDebugMode) print('[ADMIN] Order $orderId accepted');
    } catch (e) {
      if (kDebugMode) print('[ADMIN ERROR] Failed to accept order: $e');
      UI.showSnackBar(Get.context!, 'Failed to accept order', isError: true);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      UI.showSnackBar(Get.context!, 'Order cancelled', isError: false);
      if (kDebugMode) print('[ADMIN] Order $orderId cancelled');
    } catch (e) {
      if (kDebugMode) print('[ADMIN ERROR] Failed to cancel order: $e');
      UI.showSnackBar(Get.context!, 'Failed to cancel order', isError: true);
    }
  }

  Future<void> logout() async {
    try {
      if (kDebugMode) print('[LOGOUT] Starting logout process...');

      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      await storage.erase();

      if (kDebugMode) print('[LOGOUT] Redirecting to login screen...');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      if (kDebugMode) print('[LOGOUT ERROR] Exception occurred: $e');
    }
  }
}
