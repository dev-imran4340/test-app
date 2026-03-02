import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? orderId;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final String trackingStatus;
  final List<TrackingStep> trackingSteps;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.orderId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.trackingStatus,
    required this.trackingSteps,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      customerAddress: data['customerAddress'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      trackingStatus: data['trackingStatus'] ?? 'Order Placed',
      trackingSteps: (data['trackingSteps'] as List<dynamic>?)
              ?.map((step) => TrackingStep.fromMap(step))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'trackingStatus': trackingStatus,
      'trackingSteps': trackingSteps.map((step) => step.toMap()).toList(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class TrackingStep {
  final String step;
  final String timestamp;
  final bool completed;

  TrackingStep({
    required this.step,
    required this.timestamp,
    required this.completed,
  });

  factory TrackingStep.fromMap(Map<String, dynamic> map) {
    return TrackingStep(
      step: map['step'] ?? '',
      timestamp: map['timestamp'] ?? '',
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'step': step,
      'timestamp': timestamp,
      'completed': completed,
    };
  }
}
