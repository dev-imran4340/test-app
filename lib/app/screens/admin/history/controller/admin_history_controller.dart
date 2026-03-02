import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_app/app/models/order_model.dart';

class AdminHistoryController extends GetxController {
  final deliveredOrders = <OrderModel>[].obs;
  final cancelledOrders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenToHistory();
  }

  void listenToHistory() {
    isLoading.value = true;

    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      deliveredOrders.clear();
      cancelledOrders.clear();

      final allOrders = <OrderModel>[];

      for (var doc in snapshot.docs) {
        final order = OrderModel.fromFirestore(doc);
        if (order.status == 'delivered' || order.status == 'cancelled') {
          allOrders.add(order);
        }
      }

      allOrders.sort((a, b) {
        final aTime = a.createdAt ?? DateTime.now();
        final bTime = b.createdAt ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      for (var order in allOrders) {
        if (order.status == 'delivered') {
          deliveredOrders.add(order);
        } else if (order.status == 'cancelled') {
          cancelledOrders.add(order);
        }
      }
      
      isLoading.value = false;
      if (kDebugMode) {
        print('[ADMIN HISTORY] Delivered: ${deliveredOrders.length}');
        print('[ADMIN HISTORY] Cancelled: ${cancelledOrders.length}');
      }
    });
  }

  Future<void> fetchHistory() async {
    if (kDebugMode) print('[ADMIN HISTORY] Manual refresh triggered');
  }
}
