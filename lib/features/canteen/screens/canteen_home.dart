import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'feedback_screen.dart';

class CanteenHome extends StatefulWidget {
  const CanteenHome({super.key});

  @override
  State<CanteenHome> createState() => _CanteenHomeState();
}

class _CanteenHomeState extends State<CanteenHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen & Mess'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
            Tab(icon: Icon(Icons.food_bank), text: 'My Bookings'),
            Tab(icon: Icon(Icons.feedback), text: 'Feedback'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const MenuScreen(),
          const _BookingsScreen(),
          const FeedbackScreen(),
        ],
      ),
    );
  }
}

class _BookingsScreen extends StatelessWidget {
  const _BookingsScreen();

  @override
  Widget build(BuildContext context) {
    // Mock data for meal bookings
    final bookings = [
      {
        'mealType': 'Lunch',
        'date': 'Today, 12:30 PM',
        'status': 'Confirmed',
        'items': ['Rice', 'Dal', 'Paneer Curry', 'Salad'],
      },
      {
        'mealType': 'Dinner',
        'date': 'Today, 8:00 PM',
        'status': 'Pending',
        'items': ['Noodles', 'Manchurian', 'Soup'],
      },
      {
        'mealType': 'Breakfast',
        'date': 'Tomorrow, 8:00 AM',
        'status': 'Confirmed',
        'items': ['Poha', 'Tea', 'Boiled Eggs'],
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Meal Bookings',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                onPressed: () {
                  _showBookMealDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Book Meal'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                bookings.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_food,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No meal bookings yet',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showBookMealDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Book a Meal'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      booking['mealType'] as String,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Chip(
                                      label: Text(booking['status'] as String),
                                      backgroundColor:
                                          (booking['status'] as String) ==
                                                  'Confirmed'
                                              ? Colors.green[100]
                                              : Colors.orange[100],
                                      labelStyle: TextStyle(
                                        color:
                                            (booking['status'] as String) ==
                                                    'Confirmed'
                                                ? Colors.green[700]
                                                : Colors.orange[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  booking['date'] as String,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const Divider(height: 24),
                                const Text(
                                  'Items:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      (booking['items'] as List<String>)
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        // Implement cancellation
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if ((booking['status'] as String) ==
                                        'Confirmed')
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          // Implement QR code generation
                                        },
                                        icon: const Icon(Icons.qr_code),
                                        label: const Text('QR Code'),
                                      ),
                                  ],
                                ),
                              ],
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

  void _showBookMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book a Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose meal type:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: 'Lunch',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Breakfast',
                      child: Text('Breakfast'),
                    ),
                    DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                    DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const Text('Date and Time:'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Show date picker
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: const Text('Today, Apr 5, 2023'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Any special instructions?'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e.g., No spicy food, allergies, etc.',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meal booking request submitted!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }
}
