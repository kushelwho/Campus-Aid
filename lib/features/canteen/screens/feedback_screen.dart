import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Mock data for previous meals
  final List<Map<String, dynamic>> _previousMeals = [
    {
      'name': 'Lunch',
      'date': 'Today, 12:30 PM',
      'items': ['Rice', 'Dal', 'Paneer Curry', 'Salad'],
      'rated': false,
    },
    {
      'name': 'Breakfast',
      'date': 'Today, 8:00 AM',
      'items': ['Poha', 'Tea', 'Boiled Eggs'],
      'rated': true,
      'rating': 4.5,
      'comment': 'Great breakfast, very tasty Poha!',
    },
    {
      'name': 'Dinner',
      'date': 'Yesterday, 8:00 PM',
      'items': ['Noodles', 'Manchurian', 'Soup'],
      'rated': true,
      'rating': 3.0,
      'comment': 'Soup was good but noodles were a bit overcooked.',
    },
  ];

  double _currentRating = 0;
  final _commentController = TextEditingController();
  Map<String, dynamic>? _selectedMeal;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate Your Meals',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your feedback helps us improve the canteen services',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _selectedMeal == null
              ? Expanded(
                child: ListView.builder(
                  itemCount: _previousMeals.length,
                  itemBuilder: (context, index) {
                    final meal = _previousMeals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  meal['name'] as String,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (meal['rated'] as bool)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${meal['rating']}',
                                          style: TextStyle(
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              meal['date'] as String,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children:
                                  (meal['items'] as List<String>)
                                      .map(
                                        (item) => Chip(
                                          label: Text(item),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                          side: BorderSide.none,
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 16),
                            if (meal['rated'] as bool)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Comment:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(meal['comment'] as String),
                                ],
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMeal = meal;
                                    _currentRating = 0;
                                    _commentController.text = '';
                                  });
                                },
                                child: const Text('Rate Now'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
              : Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rate ${_selectedMeal!['name']}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMeal = null;
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedMeal!['date'] as String,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Items: ${(_selectedMeal!['items'] as List<String>).join(', ')}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Text(
                              'How was your meal?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRatingEmoji(context, 1.0, '😞'),
                              _buildRatingEmoji(context, 2.0, '😕'),
                              _buildRatingEmoji(context, 3.0, '😐'),
                              _buildRatingEmoji(context, 4.0, '🙂'),
                              _buildRatingEmoji(context, 5.0, '😄'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Slider(
                            value: _currentRating,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label:
                                _currentRating > 0
                                    ? _currentRating.toString()
                                    : 'Rate',
                            onChanged: (value) {
                              setState(() {
                                _currentRating = value;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              labelText: 'Your comments (optional)',
                              hintText:
                                  'Tell us what you liked or didn\'t like...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed:
                                  _currentRating > 0 ? _submitFeedback : null,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Submit Feedback'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildRatingEmoji(BuildContext context, double rating, String emoji) {
    final isSelected =
        (_currentRating >= rating - 0.5 && _currentRating < rating + 0.5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRating = rating;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(color: Theme.of(context).colorScheme.primary)
                  : null,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }

  void _submitFeedback() {
    if (_selectedMeal != null) {
      // In a real app, this would send the feedback to a backend
      setState(() {
        // Update the meal in the list
        final index = _previousMeals.indexOf(_selectedMeal!);
        if (index != -1) {
          _previousMeals[index] = {
            ..._selectedMeal!,
            'rated': true,
            'rating': _currentRating,
            'comment': _commentController.text,
          };
        }

        // Reset state
        _selectedMeal = null;
        _currentRating = 0;
        _commentController.clear();
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
