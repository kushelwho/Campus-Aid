import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cgpaController = TextEditingController();
  final _achievementsController = TextEditingController();

  // Dropdown selections
  String? _selectedDepartment;
  String? _selectedYear;
  String? _selectedIncome;

  // Departments list
  final List<String> _departments = [
    'Computer Science',
    'Electronics',
    'Mechanical',
    'Civil',
    'Chemical',
    'Electrical',
    'Information Technology',
    'Biotechnology',
  ];

  // Years list
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];

  // Income categories
  final List<String> _incomeCategories = [
    'Below ₹1,00,000',
    '₹1,00,000 - ₹3,00,000',
    '₹3,00,000 - ₹5,00,000',
    '₹5,00,000 - ₹8,00,000',
    'Above ₹8,00,000',
  ];

  // Skills
  final List<String> _availableSkills = [
    'Programming',
    'Data Analysis',
    'Design',
    'Leadership',
    'Communication',
    'Research',
    'Problem Solving',
    'Web Development',
    'Mobile Development',
    'AI/ML',
  ];

  final List<String> _selectedSkills = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cgpaController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would save the profile to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile picture section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionTitle('Personal Information'),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home_outlined),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Academic Details Section
            _buildSectionTitle('Academic Details'),

            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              items:
                  _departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your department';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year of Study',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              items:
                  _years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedYear = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your year of study';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _cgpaController,
              decoration: const InputDecoration(
                labelText: 'CGPA',
                prefixIcon: Icon(Icons.grade_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your CGPA';
                }
                try {
                  final cgpa = double.parse(value);
                  if (cgpa < 0 || cgpa > 10) {
                    return 'CGPA must be between 0 and 10';
                  }
                } catch (e) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Family Income Section
            _buildSectionTitle('Family Income'),

            DropdownButtonFormField<String>(
              value: _selectedIncome,
              decoration: const InputDecoration(
                labelText: 'Annual Family Income',
                prefixIcon: Icon(Icons.attach_money_outlined),
              ),
              items:
                  _incomeCategories.map((String income) {
                    return DropdownMenuItem<String>(
                      value: income,
                      child: Text(income),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIncome = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your family income';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Skills & Interests Section
            _buildSectionTitle('Skills & Interests'),

            const SizedBox(height: 8),

            Text(
              'Select all that apply:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children:
                  _availableSkills.map((skill) {
                    final isSelected = _selectedSkills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSkills.add(skill);
                          } else {
                            _selectedSkills.remove(skill);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _achievementsController,
              decoration: const InputDecoration(
                labelText: 'Achievements & Extracurricular Activities',
                hintText: 'List your notable achievements...',
                prefixIcon: Icon(Icons.emoji_events_outlined),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveProfile,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
        const SizedBox(height: 16),
      ],
    );
  }
}
