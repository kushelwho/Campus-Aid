import 'package:flutter/foundation.dart';
import 'package:campus_aid/features/canteen/services/gemini_service.dart';
import 'package:campus_aid/features/canteen/services/meal_service.dart';

class CanteenProvider with ChangeNotifier {
  final GeminiService _geminiService;
  late final MealService _mealService;
  
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
  
  CanteenProvider(this._geminiService) {
    _mealService = MealService(_geminiService);
    _loadMeals();
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
  
  Future<String> submitFeedback(String mealId, int rating, String? comment) async {
    _setLoading(true);
    try {
      final response = await _mealService.submitFeedbackWithAI(mealId, rating, comment);
      return response;
    } catch (e) {
      _setError('Failed to submit feedback: $e');
      return 'Thank you for your feedback!';
    } finally {
      _setLoading(false);
    }
  }
}
