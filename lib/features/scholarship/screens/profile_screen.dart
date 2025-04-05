import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Profile form controllers
  final _nameController = TextEditingController(text: 'Alex Johnson');
  final _emailController = TextEditingController(
    text: 'alex.johnson@example.com',
  );
  final _mobileController = TextEditingController(text: '');
  final _addressController = TextEditingController(text: '');

  // Academic details
  String _department = 'Computer Science';
  String _year = 'Second Year';
  final _cgpaController = TextEditingController(text: '');

  // Family income
  String _incomeCategory = 'Less than ₹3,00,000';

  // Departments list
  final List<String> _departments = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Electronics & Communication',
    'Information Technology',
    'Biotechnology',
    'Physics',
    'Chemistry',
    'Mathematics',
    'Management',
    'Commerce',
    'Humanities',
    'Other',
  ];

  // Years list
  final List<String> _years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
    'Postgraduate',
    'PhD',
  ];

  // Income categories
  final List<String> _incomeCategories = [
    'Less than ₹3,00,000',
    '₹3,00,000 - ₹6,00,000',
    '₹6,00,000 - ₹9,00,000',
    '₹9,00,000 - ₹12,00,000',
    'Above ₹12,00,000',
  ];

  // Skills/interests
  final List<String> _availableSkills = [
    'Leadership',
    'Entrepreneurship',
    'Research',
    'Programming',
    'Design',
    'Public Speaking',
    'Writing',
    'Sports',
    'Music',
    'Art',
    'Community Service',
  ];

  // Selected skills
  final List<String> _selectedSkills = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cgpaController.dispose();
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scholarship Profile')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile completion note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Your Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const Text(
                            'A complete profile helps us find the best scholarship matches for you.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal Information section
              Text(
                'Personal Information',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email*',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Usually email is synced from auth
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Academic details section
              Text(
                'Academic Details',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _department,
                decoration: const InputDecoration(
                  labelText: 'Department*',
                  border: OutlineInputBorder(),
                ),
                items:
                    _departments
                        .map(
                          (dept) =>
                              DropdownMenuItem(value: dept, child: Text(dept)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _department = value!;
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
                value: _year,
                decoration: const InputDecoration(
                  labelText: 'Year of Study*',
                  border: OutlineInputBorder(),
                ),
                items:
                    _years
                        .map(
                          (year) =>
                              DropdownMenuItem(value: year, child: Text(year)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _year = value!;
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
                  labelText: 'CGPA*',
                  hintText: 'e.g. 8.5',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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
              const SizedBox(height: 32),

              // Family income section
              Text(
                'Family Income',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _incomeCategory,
                decoration: const InputDecoration(
                  labelText: 'Annual Family Income*',
                  border: OutlineInputBorder(),
                ),
                items:
                    _incomeCategories
                        .map(
                          (income) => DropdownMenuItem(
                            value: income,
                            child: Text(income),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _incomeCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your family income category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: You may need to provide income certificate during scholarship verification.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 32),

              // Skills & Interests section
              Text(
                'Skills & Interests',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select skills and interests relevant to scholarship applications',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
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
              const SizedBox(height: 32),

              // Save button
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
