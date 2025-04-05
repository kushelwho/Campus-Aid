import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _showVegOnly = false;
  String _selectedDay = 'Today';
  final List<String> _days = [
    'Today',
    'Tomorrow',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Mock data for menu items
  final List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Vegetable Biryani',
      'description': 'Fragrant rice cooked with mixed vegetables and spices',
      'price': '₹120',
      'category': 'Main Course',
      'isVeg': true,
      'nutrition': {
        'calories': 350,
        'protein': '8g',
        'carbs': '45g',
        'fat': '12g',
      },
      'image': 'https://example.com/veg-biryani.jpg', // URL to be replaced
    },
    {
      'name': 'Chicken Curry',
      'description': 'Tender chicken pieces cooked in spicy tomato gravy',
      'price': '₹180',
      'category': 'Main Course',
      'isVeg': false,
      'nutrition': {
        'calories': 420,
        'protein': '25g',
        'carbs': '15g',
        'fat': '28g',
      },
      'image': 'https://example.com/chicken-curry.jpg', // URL to be replaced
    },
    {
      'name': 'Paneer Butter Masala',
      'description': 'Cottage cheese cubes in rich and creamy tomato gravy',
      'price': '₹150',
      'category': 'Main Course',
      'isVeg': true,
      'nutrition': {
        'calories': 380,
        'protein': '18g',
        'carbs': '12g',
        'fat': '28g',
      },
      'image': 'https://example.com/paneer.jpg', // URL to be replaced
    },
    {
      'name': 'Roti',
      'description': 'Traditional Indian bread',
      'price': '₹15',
      'category': 'Bread',
      'isVeg': true,
      'nutrition': {
        'calories': 120,
        'protein': '3g',
        'carbs': '20g',
        'fat': '2g',
      },
      'image': 'https://example.com/roti.jpg', // URL to be replaced
    },
    {
      'name': 'Rice',
      'description': 'Steamed basmati rice',
      'price': '₹50',
      'category': 'Rice',
      'isVeg': true,
      'nutrition': {
        'calories': 200,
        'protein': '4g',
        'carbs': '45g',
        'fat': '0g',
      },
      'image': 'https://example.com/rice.jpg', // URL to be replaced
    },
    {
      'name': 'Fish Curry',
      'description': 'Fresh fish cooked in tangy curry',
      'price': '₹200',
      'category': 'Main Course',
      'isVeg': false,
      'nutrition': {
        'calories': 310,
        'protein': '28g',
        'carbs': '10g',
        'fat': '18g',
      },
      'image': 'https://example.com/fish-curry.jpg', // URL to be replaced
    },
  ];

  List<Map<String, dynamic>> get _filteredMenuItems {
    return _menuItems
        .where((item) => !_showVegOnly || item['isVeg'] as bool)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  items:
                      _days
                          .map(
                            (day) =>
                                DropdownMenuItem(value: day, child: Text(day)),
                          )
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
          Text(
            'Menu for $_selectedDay',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Expanded(
            child:
                _filteredMenuItems.isEmpty
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
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredMenuItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredMenuItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () {
                              _showMenuItemDetails(context, item);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.restaurant,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              item['isVeg'] as bool
                                                  ? Icons.circle
                                                  : Icons.square,
                                              color:
                                                  item['isVeg'] as bool
                                                      ? Colors.green
                                                      : Colors.red,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                item['name'] as String,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['description'] as String,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item['price'] as String,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                // Handle book now
                                              },
                                              child: const Text('Book Now'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showMenuItemDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    item['isVeg'] as bool ? Icons.circle : Icons.square,
                    color: item['isVeg'] as bool ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['name'] as String,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item['description'] as String,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Category: ${item['category']}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text(
                'Nutrition Information',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nutritionItem(
                    context,
                    label: 'Calories',
                    value: '${item['nutrition']['calories']}',
                  ),
                  _nutritionItem(
                    context,
                    label: 'Protein',
                    value: item['nutrition']['protein'] as String,
                  ),
                  _nutritionItem(
                    context,
                    label: 'Carbs',
                    value: item['nutrition']['carbs'] as String,
                  ),
                  _nutritionItem(
                    context,
                    label: 'Fat',
                    value: item['nutrition']['fat'] as String,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle booking
                      },
                      child: const Text('Book This Dish'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _nutritionItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
