import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_app/app/models/order_model.dart';

class AdminOrdersController extends GetxController {
  final pendingOrders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingOrders();
  }

  void fetchPendingOrders() {
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      pendingOrders.clear();
      for (var doc in snapshot.docs) {
        pendingOrders.add(OrderModel.fromFirestore(doc));
      }
      isLoading.value = false;
      if (kDebugMode) print('[ADMIN ORDERS] Pending orders: ${pendingOrders.length}');
    });
  }
}
