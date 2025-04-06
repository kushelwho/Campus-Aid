import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/scholarship/providers/scholarship_provider.dart';
import '../../../features/scholarship/screens/scholarship_detail_screen.dart';
import '../../../features/events/screens/events_calendar_screen.dart';
import '../../../features/faculty_rating/screens/faculty_list_screen.dart';
import '../../../features/auth/providers/auth_provider.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Meal Booking Confirmed',
      'description': 'Your lunch booking for today has been confirmed.',
      'time': 'Just now',
      'icon': Icons.restaurant,
      'read': false,
    },
    {
      'title': 'New Scholarship Available',
      'description': 'Merit-based scholarship for engineering students.',
      'time': '2 hours ago',
      'icon': Icons.school,
      'read': false,
    },
    {
      'title': 'Lost Item Matched',
      'description': 'Someone found a wallet that matches your lost item.',
      'time': 'Yesterday',
      'icon': Icons.search,
      'read': true,
    },
    {
      'title': 'New Campus Event',
      'description': 'Annual Tech Fest is coming up next week.',
      'time': '3 days ago',
      'icon': Icons.event,
      'read': true,
    },
    {
      'title': 'New Faculty Ratings',
      'description': 'Students have added new ratings for your professors.',
      'time': '1 day ago',
      'icon': Icons.star,
      'read': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get the scholarship provider to access scholarships with near deadlines
    final scholarshipProvider = Provider.of<ScholarshipProvider>(
      context,
      listen: false,
    );
    final scholarshipWithNearDeadline =
        scholarshipProvider.getScholarshipWithNearestDeadline();

    String scholarshipDescription = 'No scholarships with upcoming deadlines';
    if (scholarshipWithNearDeadline != null) {
      // Calculate days remaining
      final deadline = DateTime.parse(scholarshipWithNearDeadline.deadline);
      final now = DateTime.now();
      final daysRemaining = deadline.difference(now).inDays;

      String timeframe;
      if (daysRemaining == 0) {
        timeframe = 'today';
      } else if (daysRemaining == 1) {
        timeframe = 'tomorrow';
      } else {
        timeframe = 'in $daysRemaining days';
      }

      scholarshipDescription =
          '${scholarshipWithNearDeadline.title} application closes $timeframe';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Aid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  // Get email and extract name (part before @)
                  final email = authProvider.userEmail;
                  final name =
                      email != null ? email.split('@').first : 'Student';

                  return Text(
                    'Hello, ${name.isNotEmpty ? name : 'Student'}!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome to your campus companion',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Quick access tiles grid
              Text(
                'Quick Access',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureTile(
                    context,
                    title: 'Canteen',
                    description: 'Order meals, view menu',
                    icon: Icons.restaurant,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(context, '/canteen');
                    },
                  ),
                  _buildFeatureTile(
                    context,
                    title: 'Lost & Found',
                    description: 'Report or find items',
                    icon: Icons.search,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, '/lost-found');
                    },
                  ),
                  _buildFeatureTile(
                    context,
                    title: 'Scholarships',
                    description: 'Find opportunities',
                    icon: Icons.school,
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/scholarship');
                    },
                  ),
                  _buildFeatureTile(
                    context,
                    title: 'Events Calendar',
                    description: 'Campus events & registration',
                    icon: Icons.event,
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to the events calendar screen
                      Navigator.pushNamed(context, '/events');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Faculty Rating Tile (Centered)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: _buildFeatureTile(
                    context,
                    title: 'Faculty Ratings',
                    description: 'Rate & review professors',
                    icon: Icons.star,
                    color: Colors.amber,
                    onTap: () {
                      // Use the named route for navigation
                      Navigator.pushNamed(context, '/faculty-rating');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recommendations section
              Text(
                'Recommended For You',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                context,
                title: 'Today\'s Special Meal',
                description: 'Paneer Butter Masala with Rice and Naan',
                icon: Icons.restaurant,
                color: Colors.orange,
                onTap: () {
                  // Direct navigation to canteen with immediate booking dialog
                  _directlyOpenCanteenBooking(context);
                },
              ),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                context,
                title: 'Scholarship Deadline',
                description: scholarshipDescription,
                icon: Icons.school,
                color: Colors.green,
                onTap: () {
                  if (scholarshipWithNearDeadline != null) {
                    // Navigate directly to scholarship detail
                    _directlyOpenScholarshipDetail(
                      context,
                      scholarshipWithNearDeadline.id,
                    );
                  } else {
                    // If no scholarships with near deadlines, just navigate to scholarship home
                    Navigator.pushNamed(context, '/scholarship');
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                context,
                title: 'Upcoming Campus Events',
                description: 'View and register for campus events',
                icon: Icons.event,
                color: Colors.purple,
                onTap: () {
                  // Navigate to the events calendar screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventsCalendarScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                context,
                title: 'Rate Your Professors',
                description:
                    'Help other students by rating your faculty members',
                icon: Icons.star,
                color: Colors.amber,
                onTap: () {
                  // Use the named route for navigation
                  Navigator.pushNamed(context, '/faculty-rating');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _directlyOpenCanteenBooking(BuildContext context) {
    // Navigate to canteen page
    Navigator.pushNamed(context, '/canteen');

    // Delay slightly to ensure the canteen screen is loaded
    Future.delayed(const Duration(milliseconds: 100), () {
      // After navigation, trigger the book meal dialog
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
    });
  }

  void _directlyOpenScholarshipDetail(
    BuildContext context,
    String scholarshipId,
  ) {
    // First navigate to the scholarship screen
    Navigator.pushNamed(context, '/scholarship');

    // Delay slightly to ensure the scholarship screen is loaded
    Future.delayed(const Duration(milliseconds: 100), () {
      // Then navigate to the specific scholarship detail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ScholarshipDetailScreen(
                scholarshipId: scholarshipId,
                isApplied: false, // The screen will check the actual status
              ),
        ),
      );
    });
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Mark all as read
                          Navigator.pop(context);
                        },
                        child: const Text('Mark all as read'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _notifications.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No notifications yet',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                          : ListView.separated(
                            controller: scrollController,
                            itemCount: _notifications.length,
                            separatorBuilder:
                                (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];
                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    notification['icon'] as IconData,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  notification['title'] as String,
                                  style: TextStyle(
                                    fontWeight:
                                        notification['read'] as bool
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notification['description'] as String),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification['time'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  // Handle notification tap
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
