import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // TEMPORARY: Hardcoded user data until backend implementation
  final Map<String, dynamic> _userData = {
    'name': 'Alex Johnson',
    'email': 'alex.johnson@example.com',
    'phone': '+91 9876543210',
    'department': 'Computer Science',
    'rollNumber': 'CS2021035',
    'year': '3rd Year',
    'hostel': 'Block-D, Room 304',
    'joinDate': 'August 2021',
    'bio':
        'Computer Science student with interest in AI/ML and mobile app development.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        // Edit functionality temporarily removed to avoid framework errors
        // Will be re-implemented with backend integration
        /*
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
        */
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Student Information
            _buildInfoSection(
              title: 'Student Information',
              icon: Icons.school_outlined,
              items: [
                {'label': 'Department', 'value': _userData['department']},
                {'label': 'Roll Number', 'value': _userData['rollNumber']},
                {'label': 'Year', 'value': _userData['year']},
                {'label': 'Joined', 'value': _userData['joinDate']},
              ],
            ),

            const SizedBox(height: 24),

            // Contact Information
            _buildInfoSection(
              title: 'Contact Information',
              icon: Icons.contact_phone_outlined,
              items: [
                {'label': 'Email', 'value': _userData['email']},
                {'label': 'Phone', 'value': _userData['phone']},
                {'label': 'Hostel', 'value': _userData['hostel']},
              ],
            ),

            const SizedBox(height: 24),

            // About Me
            _buildAboutMeSection(),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _userData['name'],
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Student',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Map<String, String>> items,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items.map(
              (item) => _buildInfoItem(item['label']!, item['value']!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'About Me',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              _userData['bio'],
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.school,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('My Scholarship Profile'),
          subtitle: const Text('View and edit scholarship details'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/scholarship');
          },
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: Icon(
            Icons.restaurant,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('My Canteen Preferences'),
          subtitle: const Text('Update dietary preferences and favorites'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/canteen');
          },
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('App Settings'),
          subtitle: const Text('Notifications, theme and language'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  // Edit functionality temporarily removed until backend implementation
  /*
  void _showEditProfileDialog() {
    // Implementation will be added when backend is ready
  }
  */
}
