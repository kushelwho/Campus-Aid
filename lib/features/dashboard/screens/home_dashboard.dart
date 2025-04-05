import 'package:flutter/material.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Aid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
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
              Text(
                'Hello, Student!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    title: 'Profile',
                    description: 'Manage your information',
                    icon: Icons.person,
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to profile
                    },
                  ),
                ],
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
              ),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                context,
                title: 'Scholarship Deadline',
                description: 'Merit scholarship application closes tomorrow',
                icon: Icons.school,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
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
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
