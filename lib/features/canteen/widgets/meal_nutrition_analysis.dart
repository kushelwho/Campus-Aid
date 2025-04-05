import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_aid/features/canteen/providers/canteen_provider.dart';
import 'package:campus_aid/features/canteen/services/meal_service.dart';

class MealNutritionAnalysis extends StatelessWidget {
  final String mealId;
  
  const MealNutritionAnalysis({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CanteenProvider>(context);
    final theme = Theme.of(context);
    
    // Load nutrition data when mealId changes
    if (provider.selectedMealId != mealId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.selectMeal(mealId);
      });
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI-Powered Nutrition Analysis',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            
            if (provider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                      SizedBox(height: 12),
                      Text('Analyzing nutrition content...', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              )
            else if (provider.error.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to analyze nutrition',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.error,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => provider.selectMeal(mealId),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              )
            else if (provider.selectedMealNutrition == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No nutrition data available'),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.selectedMealNutrition?['analysis'] ?? 'No analysis available',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Powered by Gemini AI',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
} 