import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_aid/features/canteen/providers/canteen_provider.dart';
import 'package:campus_aid/features/canteen/widgets/ai_recommendations.dart';
import 'package:campus_aid/features/canteen/widgets/meal_nutrition_analysis.dart';
import 'package:campus_aid/features/canteen/services/meal_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _showVegOnly = false;
  String _selectedDay = 'Today';
  String? _selectedMealId;
  final List<String> _days = [
    'Today',
    'Tomorrow',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final canteenProvider = Provider.of<CanteenProvider>(context);
    final meals = canteenProvider.meals;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDay,
                      decoration: const InputDecoration(
                        labelText: 'Select Day',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: _days
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(day),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilterChip(
                    label: const Text('Veg Only'),
                    selected: _showVegOnly,
                    onSelected: (selected) {
                      setState(() {
                        _showVegOnly = selected;
                      });
                      canteenProvider.toggleVegetarianFilter(selected);
                    },
                    avatar: Icon(
                      Icons.eco,
                      color: _showVegOnly ? Colors.white : Colors.green,
                      size: 18,
                    ),
                    selectedColor: Colors.green,
                    checkmarkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // AI Recommendations Widget - Collapsible by default
              const AIRecommendationsWidget(),
              
              const SizedBox(height: 16),
              Text(
                'Menu for $_selectedDay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              
              // Scrollable Content
              Expanded(
                child: meals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_meals,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No menu items available',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          final meal = meals[index];
                          final isSelected = _selectedMealId == meal.id;
                          
                          return buildMealCard(context, meal, isSelected);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildMealCard(BuildContext context, Meal meal, bool isSelected) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          elevation: isSelected ? 4 : 1,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedMealId = isSelected ? null : meal.id;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal image placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: meal.imageUrl.startsWith('http')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  meal.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.fastfood, size: 40),
                                ),
                              )
                            : const Icon(Icons.fastfood, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (meal.isVegetarian)
                                  buildDietBadge(
                                    context,
                                    isVeg: true,
                                  )
                                else
                                  buildDietBadge(
                                    context,
                                    isVeg: false,
                                  ),
                                const Spacer(),
                                Text(
                                  '₹${meal.price.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              meal.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meal.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Action buttons
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedMealId = meal.id;
                          });
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Nutrition'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pre-booking ${meal.name}'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Pre-Book'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Show nutrition analysis if meal is selected - with fixed height
        if (isSelected)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              child: MealNutritionAnalysis(mealId: meal.id),
            ),
          ),
      ],
    );
  }
  
  Widget buildDietBadge(BuildContext context, {required bool isVeg}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: (isVeg ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVeg ? Icons.eco : Icons.restaurant_menu,
            color: isVeg ? Colors.green : Colors.red,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isVeg ? 'Veg' : 'Non-Veg',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isVeg ? Colors.green : Colors.red,
                ),
          ),
        ],
      ),
    );
  }
}
