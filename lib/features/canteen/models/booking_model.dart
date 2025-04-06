import 'package:cloud_firestore/cloud_firestore.dart';

class MealBooking {
  final String id;
  final String userId;
  final String mealType;
  final DateTime bookingDate;
  final DateTime mealDate;
  final List<String> items;
  final String status;
  final String? specialInstructions;

  MealBooking({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.bookingDate,
    required this.mealDate,
    required this.items,
    required this.status,
    this.specialInstructions,
  });

  // Create a MealBooking from Firestore document
  factory MealBooking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealBooking(
      id: doc.id,
      userId: data['userId'] ?? '',
      mealType: data['mealType'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      mealDate: (data['mealDate'] as Timestamp).toDate(),
      items: List<String>.from(data['items'] ?? []),
      status: data['status'] ?? 'Pending',
      specialInstructions: data['specialInstructions'],
    );
  }

  // Convert MealBooking to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mealType': mealType,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'mealDate': Timestamp.fromDate(mealDate),
      'items': items,
      'status': status,
      'specialInstructions': specialInstructions,
    };
  }

  // Create a copy of MealBooking with updated fields
  MealBooking copyWith({
    String? id,
    String? userId,
    String? mealType,
    DateTime? bookingDate,
    DateTime? mealDate,
    List<String>? items,
    String? status,
    String? specialInstructions,
  }) {
    return MealBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      bookingDate: bookingDate ?? this.bookingDate,
      mealDate: mealDate ?? this.mealDate,
      items: items ?? this.items,
      status: status ?? this.status,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
