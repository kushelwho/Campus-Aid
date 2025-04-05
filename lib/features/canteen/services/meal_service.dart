import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:campus_aid/features/canteen/services/gemini_service.dart';

class Meal {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isVegetarian;
  final Map<String, dynamic>? nutritionInfo;
  final List<String> ingredients;
  final double rating;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isVegetarian,
    this.nutritionInfo,
    required this.ingredients,
    this.rating = 0.0,
  });

  Meal copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isVegetarian,
    Map<String, dynamic>? nutritionInfo,
    List<String>? ingredients,
    double? rating,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isVegetarian': isVegetarian,
      'nutritionInfo': nutritionInfo,
      'ingredients': ingredients,
      'rating': rating,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isVegetarian: json['isVegetarian'],
      nutritionInfo: json['nutritionInfo'],
      ingredients: List<String>.from(json['ingredients']),
      rating: json['rating'] ?? 0.0,
    );
  }
}

class MealService {
  final GeminiService _geminiService;
  
  MealService(this._geminiService);
  
  // Mock meal data - in a real app, this would come from an API
  final List<Meal> _meals = [
    Meal(
      id: '1',
      name: 'Vegetable Biryani',
      description: 'Fragrant rice dish with assorted vegetables and spices',
      price: 120.0,
      imageUrl: 'assets/images/veg_biryani.jpg',
      isVegetarian: true,
      ingredients: ['Basmati rice', 'Mixed vegetables', 'Spices', 'Herbs'],
    ),
    Meal(
      id: '2',
      name: 'Chicken Curry',
      description: 'Tender chicken pieces in rich and aromatic curry sauce',
      price: 150.0,
      imageUrl: 'assets/images/chicken_curry.jpg',
      isVegetarian: false,
      ingredients: ['Chicken', 'Tomato', 'Onion', 'Spices', 'Cream'],
    ),
    Meal(
      id: '3',
      name: 'Paneer Tikka',
      description: 'Grilled cottage cheese with vegetables and spices',
      price: 130.0,
      imageUrl: 'assets/images/paneer_tikka.jpg',
      isVegetarian: true,
      ingredients: ['Paneer', 'Bell peppers', 'Onion', 'Spices', 'Yogurt'],
    ),
    Meal(
      id: '4',
      name: 'Fish Curry',
      description: 'Fresh fish in a tangy and spicy curry',
      price: 160.0,
      imageUrl: 'assets/images/fish_curry.jpg',
      isVegetarian: false,
      ingredients: ['Fish', 'Tomato', 'Onion', 'Spices', 'Coconut milk'],
    ),
    Meal(
      id: '5',
      name: 'Dal Makhani',
      description: 'Creamy lentil dish with butter and cream',
      price: 110.0,
      imageUrl: 'assets/images/dal_makhani.jpg',
      isVegetarian: true,
      ingredients: ['Black lentils', 'Kidney beans', 'Butter', 'Cream', 'Spices'],
    ),
  ];

  // Get all meals
  List<Meal> getAllMeals() {
    return _meals;
  }

  // Get meals by dietary preference
  List<Meal> getMealsByDietaryPreference(bool vegetarianOnly) {
    if (vegetarianOnly) {
      return _meals.where((meal) => meal.isVegetarian).toList();
    }
    return _meals;
  }

  // Get meal by ID
  Meal? getMealById(String id) {
    try {
      return _meals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get AI-powered meal recommendations
  Future<List<String>> getAIRecommendations({
    required bool isVegetarian,
    Map<String, dynamic>? nutritionGoals,
  }) async {
    // Get past meals to provide context to the AI
    final pastMeals = _meals
        .take(3)
        .map((meal) => meal.name)
        .toList();

    final dietaryPreference = isVegetarian ? 'Vegetarian' : 'Non-vegetarian';
    
    final recommendations = await _geminiService.getMenuRecommendations(
      pastMeals: pastMeals,
      dietaryPreference: dietaryPreference,
      nutritionGoals: nutritionGoals,
    );
    
    // Simple parsing - in a real app, you'd want more robust parsing
    return recommendations
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  // Get nutrition analysis for a meal
  Future<Map<String, dynamic>> getAINutritionAnalysis(String mealId) async {
    final meal = getMealById(mealId);
    if (meal == null) {
      return {
        'success': false,
        'analysis': 'Meal not found',
      };
    }

    if (meal.nutritionInfo != null) {
      return {
        'success': true,
        'analysis': meal.nutritionInfo,
      };
    }

    return await _geminiService.analyzeMealNutrition(meal.name);
  }

  // Submit feedback and get AI-generated response
  Future<String> submitFeedbackWithAI(String mealId, int rating, String? comment) async {
    final meal = getMealById(mealId);
    if (meal == null) {
      return 'Meal not found';
    }

    // In a real app, you would save the feedback to a database here

    return await _geminiService.generatePersonalizedFeedback(meal.name, rating);
  }
}
