import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _uuid = const Uuid();

  // Collection reference
  CollectionReference get _bookingsCollection =>
      _firestore.collection('meal_bookings');

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Book a meal
  Future<MealBooking?> bookMeal({
    required String mealType,
    required DateTime mealDate,
    required List<String> items,
    String? specialInstructions,
  }) async {
    try {
      // Check if user is logged in
      final userId = _currentUserId;
      debugPrint('Current user ID: $userId');

      if (userId == null) {
        debugPrint('Error: User not logged in');
        // Use a temporary ID for testing if user is not logged in
        // In production, you should require login
        // return null;
        throw Exception('User not logged in');
      }

      // Create booking data
      final bookingId = _uuid.v4();
      debugPrint('Generated booking ID: $bookingId');

      final bookingData = MealBooking(
        id: bookingId,
        userId: userId,
        mealType: mealType,
        bookingDate: DateTime.now(),
        mealDate: mealDate,
        items: items,
        status: 'Pending', // Always starts as pending
        specialInstructions: specialInstructions,
      );

      // Convert to Firestore data
      final firestoreData = bookingData.toFirestore();
      debugPrint('Saving booking to Firestore: $firestoreData');

      // Add to Firestore
      await _bookingsCollection
          .doc(bookingId)
          .set(firestoreData)
          .then((_) => debugPrint('Booking saved successfully'))
          .catchError((error) => debugPrint('Error saving booking: $error'));

      // Return the created booking
      return bookingData;
    } catch (e) {
      debugPrint('Error in bookMeal: $e');
      return null;
    }
  }

  // Get all bookings for current user
  Stream<List<MealBooking>> getUserBookings() {
    final userId = _currentUserId;
    debugPrint('Getting bookings for user: $userId');

    if (userId == null) {
      debugPrint('No user logged in, returning empty bookings');
      // Return empty list if user is not logged in
      return Stream.value([]);
    }

    return _bookingsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('mealDate', descending: false)
        .snapshots()
        .map((snapshot) {
          debugPrint('Got ${snapshot.docs.length} bookings from Firestore');
          return snapshot.docs
              .map((doc) => MealBooking.fromFirestore(doc))
              .toList();
        });
  }

  // Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      debugPrint('Attempting to cancel booking: $bookingId');

      // Get the booking
      final docSnapshot = await _bookingsCollection.doc(bookingId).get();
      if (!docSnapshot.exists) {
        debugPrint('Booking not found: $bookingId');
        throw Exception('Booking not found');
      }

      final bookingData = docSnapshot.data() as Map<String, dynamic>;

      // Verify that the booking belongs to the current user
      if (bookingData['userId'] != userId) {
        debugPrint(
          'User $userId not authorized to cancel booking owned by ${bookingData['userId']}',
        );
        throw Exception('Unauthorized to cancel this booking');
      }

      // Update the status to Cancelled
      await _bookingsCollection.doc(bookingId).update({'status': 'Cancelled'});
      debugPrint('Booking cancelled successfully');
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  // Get booking by ID
  Future<MealBooking?> getBookingById(String bookingId) async {
    try {
      final docSnapshot = await _bookingsCollection.doc(bookingId).get();
      if (!docSnapshot.exists) {
        return null;
      }
      return MealBooking.fromFirestore(docSnapshot);
    } catch (e) {
      debugPrint('Error getting booking: $e');
      return null;
    }
  }

  // For testing only: Force create a test booking
  Future<MealBooking?> createTestBooking() async {
    try {
      final userId = _currentUserId ?? 'test-user';
      final bookingId = _uuid.v4();

      final bookingData = MealBooking(
        id: bookingId,
        userId: userId,
        mealType: 'Test Lunch',
        bookingDate: DateTime.now(),
        mealDate: DateTime.now().add(const Duration(hours: 2)),
        items: ['Rice', 'Dal', 'Test Item'],
        status: 'Pending',
        specialInstructions: 'This is a test booking',
      );

      await _bookingsCollection.doc(bookingId).set(bookingData.toFirestore());
      debugPrint('Test booking created with ID: $bookingId');
      return bookingData;
    } catch (e) {
      debugPrint('Error creating test booking: $e');
      return null;
    }
  }
}
