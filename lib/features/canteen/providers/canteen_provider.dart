import 'package:flutter/foundation.dart';
import 'package:campus_aid/features/canteen/services/gemini_service.dart';
import 'package:campus_aid/features/canteen/services/meal_service.dart';
import 'package:campus_aid/features/canteen/services/booking_service.dart';
import 'package:campus_aid/features/canteen/models/booking_model.dart';

class CanteenProvider with ChangeNotifier {
  final GeminiService _geminiService;
  late final MealService _mealService;
  final BookingService _bookingService = BookingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  bool _vegetarianOnly = false;
  bool get vegetarianOnly => _vegetarianOnly;

  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

  List<String> _aiRecommendations = [];
  List<String> get aiRecommendations => _aiRecommendations;

  Map<String, dynamic>? _selectedMealNutrition;
  Map<String, dynamic>? get selectedMealNutrition => _selectedMealNutrition;

  String _selectedMealId = '';
  String get selectedMealId => _selectedMealId;

  // For bookings
  List<MealBooking> _userBookings = [];
  List<MealBooking> get userBookings => _userBookings;
  bool _bookingsLoading = false;
  bool get bookingsLoading => _bookingsLoading;

  CanteenProvider(this._geminiService) {
    _mealService = MealService(_geminiService);
    _loadMeals();
    _loadUserBookings();
    debugPrint('[CanteenProvider] Initialized');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void toggleVegetarianFilter(bool value) {
    _vegetarianOnly = value;
    _loadMeals();
    notifyListeners();
  }

  void _loadMeals() {
    _meals = _mealService.getMealsByDietaryPreference(_vegetarianOnly);
    notifyListeners();
  }

  Future<void> loadAIRecommendations() async {
    _setLoading(true);
    _aiRecommendations = [];

    try {
      _aiRecommendations = await _mealService.getAIRecommendations(
        isVegetarian: _vegetarianOnly,
      );
    } catch (e) {
      _setError('Failed to load AI recommendations: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectMeal(String mealId) async {
    _selectedMealId = mealId;
    _selectedMealNutrition = null;
    notifyListeners();

    _setLoading(true);
    try {
      final nutritionData = await _mealService.getAINutritionAnalysis(mealId);
      _selectedMealNutrition = nutritionData;
    } catch (e) {
      _setError('Failed to analyze meal nutrition: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<String> submitFeedback(
    String mealId,
    int rating,
    String? comment,
  ) async {
    _setLoading(true);
    try {
      final response = await _mealService.submitFeedbackWithAI(
        mealId,
        rating,
        comment,
      );
      return response;
    } catch (e) {
      _setError('Failed to submit feedback: $e');
      return 'Thank you for your feedback!';
    } finally {
      _setLoading(false);
    }
  }

  // Booking related functions
  void _loadUserBookings() {
    _bookingsLoading = true;
    notifyListeners();
    debugPrint('[CanteenProvider] Loading user bookings');

    _bookingService.getUserBookings().listen(
      (bookings) {
        debugPrint('[CanteenProvider] Received ${bookings.length} bookings');
        _userBookings = bookings;
        _bookingsLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('[CanteenProvider] Error loading bookings: $e');
        _setError('Failed to load user bookings: $e');
        _bookingsLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> bookMeal({
    required String mealType,
    required DateTime mealDate,
    required List<String> items,
    String? specialInstructions,
  }) async {
    _setLoading(true);
    debugPrint('[CanteenProvider] Booking meal: $mealType for $mealDate');

    try {
      final booking = await _bookingService.bookMeal(
        mealType: mealType,
        mealDate: mealDate,
        items: items,
        specialInstructions: specialInstructions,
      );

      if (booking != null) {
        debugPrint('[CanteenProvider] Booking successful, ID: ${booking.id}');
        // Add the new booking to the list without waiting for Firebase listener
        _userBookings = [..._userBookings, booking];
        notifyListeners();
      } else {
        debugPrint('[CanteenProvider] Booking failed, null returned');
      }

      _setLoading(false);
      return booking != null;
    } catch (e) {
      debugPrint('[CanteenProvider] Error booking meal: $e');
      _setError('Failed to book meal: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _setLoading(true);
    debugPrint('[CanteenProvider] Cancelling booking: $bookingId');

    try {
      final success = await _bookingService.cancelBooking(bookingId);

      if (success) {
        debugPrint('[CanteenProvider] Cancellation successful');
        // Update the local booking status without waiting for Firebase listener
        final index = _userBookings.indexWhere((b) => b.id == bookingId);
        if (index >= 0) {
          _userBookings[index] = _userBookings[index].copyWith(
            status: 'Cancelled',
          );
          notifyListeners();
        }
      } else {
        debugPrint('[CanteenProvider] Cancellation failed');
      }

      _setLoading(false);
      return success;
    } catch (e) {
      debugPrint('[CanteenProvider] Error cancelling booking: $e');
      _setError('Failed to cancel booking: $e');
      _setLoading(false);
      return false;
    }
  }

  // For testing only: Create a test booking
  Future<bool> createTestBooking() async {
    _setLoading(true);
    debugPrint('[CanteenProvider] Creating test booking');

    try {
      final booking = await _bookingService.createTestBooking();

      if (booking != null) {
        debugPrint('[CanteenProvider] Test booking created: ${booking.id}');
        // Add the test booking to the list
        _userBookings = [..._userBookings, booking];
        notifyListeners();
      }

      _setLoading(false);
      return booking != null;
    } catch (e) {
      debugPrint('[CanteenProvider] Error creating test booking: $e');
      _setError('Failed to create test booking: $e');
      _setLoading(false);
      return false;
    }
  }
}
