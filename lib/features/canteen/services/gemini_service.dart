import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  
  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found. Please add it to your .env file.');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<String> getMenuRecommendations({
    required List<String> pastMeals,
    required String dietaryPreference,
    Map<String, dynamic>? nutritionGoals,
  }) async {
    final prompt = '''
    Based on these past meals: ${pastMeals.join(', ')}
    Dietary preference: $dietaryPreference
    ${nutritionGoals != null ? 'Nutrition goals: $nutritionGoals' : ''}
    
    Please recommend 3 meals for today that:
    1. Align with dietary preferences
    2. Provide balanced nutrition
    3. Offer variety from past meals
    4. Include a brief nutrition highlight for each
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate recommendations.';
    } catch (e) {
      return 'Error generating recommendations: $e';
    }
  }

  Future<Map<String, dynamic>> analyzeMealNutrition(String meal) async {
    final prompt = '''
    Analyze the nutritional content of this meal: $meal
    
    Provide estimated:
    - Calories
    - Protein (g)
    - Carbs (g)
    - Fat (g)
    - Key vitamins/minerals
    - Health benefits
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text ?? '';
      
      // Simple parsing of the response into a structured format
      // In a real app, you would want more robust parsing
      return {
        'analysis': responseText,
        'success': true,
      };
    } catch (e) {
      return {
        'analysis': 'Error analyzing meal nutrition',
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<String> generatePersonalizedFeedback(String meal, int rating) async {
    final prompt = '''
    A user just rated the meal "$meal" as $rating out of 5.
    
    Generate a brief, personalized response thanking them for their feedback.
    If rating is high (4-5), highlight what might have made the meal enjoyable.
    If rating is medium (3), acknowledge potential for improvement.
    If rating is low (1-2), express regret and commitment to improvement.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Thank you for your feedback!';
    } catch (e) {
      return 'Thank you for your feedback!';
    }
  }
} 