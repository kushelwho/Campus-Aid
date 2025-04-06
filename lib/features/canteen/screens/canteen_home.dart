import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/canteen_provider.dart';
import '../models/booking_model.dart';
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
          const BookingsScreen(),
          const FeedbackScreen(),
        ],
      ),
    );
  }
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    final canteenProvider = Provider.of<CanteenProvider>(context);
    final bookings = canteenProvider.userBookings;
    final isLoading = canteenProvider.bookingsLoading;

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
          const SizedBox(height: 8),

          // Debug Row - can be removed in production
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (kDebugMode)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final provider = Provider.of<CanteenProvider>(
                        context,
                        listen: false,
                      );
                      final success = await provider.createTestBooking();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test booking created'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.bug_report, size: 16),
                    label: const Text(
                      'Test Booking',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                // Refresh button for reloading bookings
                IconButton(
                  onPressed: () {
                    // Manually trigger a rebuild
                    setState(() {});

                    // Force refresh of bookings
                    final provider = Provider.of<CanteenProvider>(
                      context,
                      listen: false,
                    );
                    // Access the loadUserBookings through our test method
                    provider.createTestBooking().then(
                      (_) => provider.cancelBooking('dummy-id'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refreshing bookings...'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  tooltip: 'Refresh bookings',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : bookings.isEmpty
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
                        return _buildBookingCard(context, booking);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, MealBooking booking) {
    final dateFormat = DateFormat('E, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(booking.mealDate);
    final formattedTime = timeFormat.format(booking.mealDate);
    final canteenProvider = Provider.of<CanteenProvider>(
      context,
      listen: false,
    );

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
                  booking.mealType,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(booking.status),
                  backgroundColor:
                      booking.status == 'Confirmed'
                          ? Colors.green[100]
                          : booking.status == 'Cancelled'
                          ? Colors.red[100]
                          : Colors.orange[100],
                  labelStyle: TextStyle(
                    color:
                        booking.status == 'Confirmed'
                            ? Colors.green[700]
                            : booking.status == 'Cancelled'
                            ? Colors.red[700]
                            : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$formattedDate at $formattedTime',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (booking.specialInstructions != null &&
                booking.specialInstructions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Special Instructions: ${booking.specialInstructions}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            const Divider(height: 24),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  booking.items
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (booking.status != 'Cancelled')
                  TextButton.icon(
                    onPressed: () async {
                      final confirm = await _showCancelConfirmation(context);
                      if (confirm && context.mounted) {
                        final success = await canteenProvider.cancelBooking(
                          booking.id,
                        );
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Booking cancelled successfully'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                const SizedBox(width: 8),
                if (booking.status == 'Confirmed')
                  OutlinedButton.icon(
                    onPressed: () {
                      _showQRCode(context, booking.id);
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
  }

  Future<bool> _showCancelConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Cancel Booking'),
                content: const Text(
                  'Are you sure you want to cancel this meal booking?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes, Cancel'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showQRCode(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Booking QR Code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      'QR Code for\nBooking #${bookingId.substring(0, 8)}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Show this QR code at the counter to collect your meal',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showBookMealDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final mealTypeController = TextEditingController(text: 'Lunch');
    final dateController = TextEditingController(
      text: DateFormat('MMM d, yyyy').format(DateTime.now()),
    );
    final timeController = TextEditingController(
      text: DateFormat(
        'h:mm a',
      ).format(DateTime.now().add(const Duration(hours: 1))),
    );
    final specialInstructionsController = TextEditingController();

    // Default meal items
    final selectedItems = <String>['Rice', 'Dal', 'Salad'];

    // Available meal items
    final allItems = [
      'Rice',
      'Dal',
      'Paneer Curry',
      'Chicken Curry',
      'Fish Curry',
      'Roti',
      'Naan',
      'Salad',
      'Yogurt',
      'Soup',
      'Dessert',
    ];

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Book a Meal'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Choose meal type:'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: mealTypeController.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Breakfast',
                            child: Text('Breakfast'),
                          ),
                          DropdownMenuItem(
                            value: 'Lunch',
                            child: Text('Lunch'),
                          ),
                          DropdownMenuItem(
                            value: 'Dinner',
                            child: Text('Dinner'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            mealTypeController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a meal type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Date:'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 14),
                            ),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                              dateController.text = DateFormat(
                                'MMM d, yyyy',
                              ).format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Time:'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );

                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                              timeController.text = pickedTime.format(context);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a time';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Select items:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            allItems.map((item) {
                              final isSelected = selectedItems.contains(item);
                              return FilterChip(
                                label: Text(item),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedItems.add(item);
                                    } else {
                                      selectedItems.remove(item);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      if (selectedItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please select at least one item',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text('Any special instructions?'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: specialInstructionsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., No spicy food, allergies, etc.',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
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
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        selectedItems.isNotEmpty) {
                      // Combine date and time
                      final mealDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      final canteenProvider = Provider.of<CanteenProvider>(
                        context,
                        listen: false,
                      );
                      final success = await canteenProvider.bookMeal(
                        mealType: mealTypeController.text,
                        mealDate: mealDateTime,
                        items: selectedItems,
                        specialInstructions:
                            specialInstructionsController.text.isNotEmpty
                                ? specialInstructionsController.text
                                : null,
                      );

                      if (success && context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Meal booking request submitted!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to book meal. Please try again.',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else if (selectedItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one item'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Book'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
