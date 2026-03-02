import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/app/notifications/app_notification.dart';
import 'package:test_app/app/routes/app_routes.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final storage = GetStorage();
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.text = storage.read('userEmail') ?? '';
  }

  Future<void> placeOrder() async {
    if (!formKey.currentState!.validate()) {
      if (kDebugMode) print('[CHECKOUT] Form validation failed');
      return;
    }

    try {
      isLoading.value = true;
      if (kDebugMode) print('[CHECKOUT] Starting order placement...');

      final mainController = Get.find<MainController>();
      final userId = storage.read('userId') ?? '';

      final orderData = {
        'userId': userId,
        'customerName': nameController.text.trim(),
        'customerEmail': emailController.text.trim(),
        'customerPhone': phoneController.text.trim(),
        'customerAddress': addressController.text.trim(),
        'items': mainController.cartItems.map((item) => item.toMap()).toList(),
        'totalAmount': mainController.totalAmount,
        'status': 'pending',
        'trackingStatus': 'Order Placed',
        'trackingSteps': [
          {
            'step': 'Order Placed',
            'timestamp': DateTime.now().toIso8601String(),
            'completed': true,
          },
          {
            'step': 'Being Prepared',
            'timestamp': '',
            'completed': false,
          },
          {
            'step': 'Ready for Pickup',
            'timestamp': '',
            'completed': false,
          },
          {
            'step': 'Out for Delivery',
            'timestamp': '',
            'completed': false,
          },
          {
            'step': 'Delivered',
            'timestamp': '',
            'completed': false,
          },
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(orderData);

      if (kDebugMode) print('[CHECKOUT] Order placed with ID: ${docRef.id}');

      await AppNotification.sendOrderNotification(
        title: 'Order Placed Successfully!',
        body: 'Your order of ${mainController.totalAmount.toStringAsFixed(0)} has been placed.',
      );

      mainController.clearCart();

      Get.back();
      Get.snackbar(
        'Order Placed!',
        'Your order has been placed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      Get.offAllNamed(AppRoutes.main);

      if (kDebugMode) print('[CHECKOUT] Order placement completed');
    } catch (e) {
      if (kDebugMode) {
        print('[CHECKOUT ERROR] Failed to place order: $e');
        print('  Type: ${e.runtimeType}');
      }
      Get.snackbar(
        'Error',
        'Failed to place order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
