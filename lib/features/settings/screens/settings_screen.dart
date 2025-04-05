import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool _notifyScholarships = true;
  bool _notifyCanteen = true;
  bool _notifyLostFound = true;

  // Language settings
  String _selectedLanguage = 'English';
  final List<String> _availableLanguages = [
    'English',
    'Hindi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Marathi',
  ];

  @override
  Widget build(BuildContext context) {
    // Access the theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Information Card
          _buildAppInfoCard(),

          const SizedBox(height: 24),

          // Theme Settings
          _buildSettingsSection(
            title: 'Display',
            icon: Icons.palette_outlined,
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use darker colors for night viewing'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  // Toggle theme mode using the provider
                  themeProvider.toggleThemeMode();
                },
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              ),

              const Divider(),

              ListTile(
                title: const Text('Font Size'),
                subtitle: const Text('Adjust text size throughout the app'),
                leading: const Icon(Icons.format_size),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: themeProvider.fontSize,
                    min: 0.8,
                    max: 1.2,
                    divisions: 4,
                    label: themeProvider.getFontSizeLabel(),
                    onChanged: (value) {
                      // Update font size using the provider
                      themeProvider.setFontSize(value);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Notification Settings
          _buildSettingsSection(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            children: [
              SwitchListTile(
                title: const Text('Scholarship Updates'),
                subtitle: const Text('New matches and deadlines'),
                value: _notifyScholarships,
                onChanged: (value) {
                  setState(() {
                    _notifyScholarships = value;
                  });
                },
                secondary: const Icon(Icons.school_outlined),
              ),

              const Divider(),

              SwitchListTile(
                title: const Text('Canteen & Mess Alerts'),
                subtitle: const Text('Menu updates and meal reminders'),
                value: _notifyCanteen,
                onChanged: (value) {
                  setState(() {
                    _notifyCanteen = value;
                  });
                },
                secondary: const Icon(Icons.restaurant_outlined),
              ),

              const Divider(),

              SwitchListTile(
                title: const Text('Lost & Found Notifications'),
                subtitle: const Text('Matches and item updates'),
                value: _notifyLostFound,
                onChanged: (value) {
                  setState(() {
                    _notifyLostFound = value;
                  });
                },
                secondary: const Icon(Icons.search_outlined),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Language Settings
          _buildSettingsSection(
            title: 'Language & Region',
            icon: Icons.language_outlined,
            children: [
              ListTile(
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                leading: const Icon(Icons.translate),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageSelector();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account Settings
          _buildSettingsSection(
            title: 'Account',
            icon: Icons.person_outline,
            children: [
              ListTile(
                title: const Text('Edit Profile'),
                subtitle: const Text('Update your personal information'),
                leading: const Icon(Icons.edit_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to profile screen
                  Navigator.pushNamed(context, '/profile');
                },
              ),

              const Divider(),

              ListTile(
                title: const Text('Privacy'),
                subtitle: const Text('Manage your data and privacy settings'),
                leading: const Icon(Icons.privacy_tip_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to privacy settings
                },
              ),

              const Divider(),

              ListTile(
                title: const Text('Logout'),
                textColor: Colors.red,
                iconColor: Colors.red,
                leading: const Icon(Icons.logout),
                onTap: () {
                  _showLogoutConfirmation();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // About & Support
          _buildSettingsSection(
            title: 'About & Support',
            icon: Icons.info_outline,
            children: [
              ListTile(
                title: const Text('Help & FAQ'),
                leading: const Icon(Icons.help_outline),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to help screen
                },
              ),

              const Divider(),

              ListTile(
                title: const Text('Contact Support'),
                leading: const Icon(Icons.contact_support_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to support screen
                },
              ),

              const Divider(),

              ListTile(
                title: const Text('About Campus Aid'),
                subtitle: const Text('Version 1.0.0'),
                leading: const Icon(Icons.info_outline),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Show about dialog
                  showAboutDialog(
                    context: context,
                    applicationName: 'Campus Aid',
                    applicationVersion: '1.0.0',
                    applicationIcon: const FlutterLogo(size: 32),
                    applicationLegalese: '© 2023 Campus Aid Team',
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Campus Aid is a comprehensive student platform designed to streamline '
                        'essential campus services through technology and automation.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.school, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campus Aid',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Customize your app experience',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableLanguages.length,
              itemBuilder: (context, index) {
                final language = _availableLanguages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
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
                // In a real app, this would implement actual logout
                // and navigation to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
