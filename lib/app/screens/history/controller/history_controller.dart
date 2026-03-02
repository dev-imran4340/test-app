import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final storage = GetStorage();
  final pendingOrders = <Map<String, dynamic>>[].obs;
  final cancelledOrders = <Map<String, dynamic>>[].obs;
  final deliveredOrders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenToOrders();
  }

  void listenToOrders() {
    final userId = storage.read('userId') ?? '';
    if (userId.isEmpty) {
      if (kDebugMode) print('[HISTORY ERROR] No user ID found');
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      pendingOrders.clear();
      cancelledOrders.clear();
      deliveredOrders.clear();

      final allOrders = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        allOrders.add(data);
      }

      allOrders.sort((a, b) {
        final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      for (var data in allOrders) {
        final status = data['status']?.toString().toLowerCase() ?? 'pending';
        
        if (status == 'pending' || status == 'accepted') {
          pendingOrders.add(data);
        } else if (status == 'cancelled') {
          cancelledOrders.add(data);
        } else if (status == 'delivered') {
          deliveredOrders.add(data);
        }
      }

      isLoading.value = false;
      
      if (kDebugMode) {
        print('[HISTORY] Pending: ${pendingOrders.length}');
        print('[HISTORY] Cancelled: ${cancelledOrders.length}');
        print('[HISTORY] Delivered: ${deliveredOrders.length}');
      }
    });
  }

  Future<void> fetchOrders() async {
    if (kDebugMode) print('[HISTORY] Manual refresh triggered');
  }
}
