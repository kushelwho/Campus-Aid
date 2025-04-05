import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'scholarship_detail_screen.dart';

class ScholarshipHome extends StatefulWidget {
  const ScholarshipHome({super.key});

  @override
  State<ScholarshipHome> createState() => _ScholarshipHomeState();
}

class _ScholarshipHomeState extends State<ScholarshipHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  // Filter options
  final List<String> _categories = [
    'All',
    'Merit',
    'Need-based',
    'Research',
    'Sports',
    'Cultural',
    'International',
  ];

  // Mock scholarship data
  final List<Map<String, dynamic>> _scholarships = [
    {
      'id': '1',
      'title': 'National Merit Scholarship',
      'category': 'Merit',
      'description':
          'Scholarship for students with outstanding academic achievements.',
      'amount': '₹50,000',
      'deadline': '2023-05-30',
      'eligibility': 'CGPA 8.5 or above, any discipline',
      'matchPercentage': 92,
      'isApplied': false,
      'status': 'Not Applied',
    },
    {
      'id': '2',
      'title': 'Financial Aid Scholarship',
      'category': 'Need-based',
      'description': 'Support for students from economically weaker sections.',
      'amount': '₹30,000',
      'deadline': '2023-06-15',
      'eligibility': 'Annual family income below ₹3,00,000',
      'matchPercentage': 78,
      'isApplied': true,
      'status': 'Under Review',
    },
    {
      'id': '3',
      'title': 'Engineering Excellence Scholarship',
      'category': 'Merit',
      'description': 'For top-performing engineering students.',
      'amount': '₹40,000',
      'deadline': '2023-05-20',
      'eligibility': 'Engineering students with CGPA 9.0 or above',
      'matchPercentage': 85,
      'isApplied': false,
      'status': 'Not Applied',
    },
    {
      'id': '4',
      'title': 'Sports Achievement Grant',
      'category': 'Sports',
      'description':
          'For students representing college in national sports events.',
      'amount': '₹25,000',
      'deadline': '2023-07-10',
      'eligibility': 'State or national level sports certificate',
      'matchPercentage': 65,
      'isApplied': true,
      'status': 'Approved',
    },
    {
      'id': '5',
      'title': 'Research Fellowship',
      'category': 'Research',
      'description': 'Support for students pursuing research projects.',
      'amount': '₹60,000',
      'deadline': '2023-06-30',
      'eligibility': 'Research proposal, faculty recommendation',
      'matchPercentage': 70,
      'isApplied': false,
      'status': 'Not Applied',
    },
  ];

  // Check if user profile is complete
  bool _isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Get filtered scholarships based on selected category
  List<Map<String, dynamic>> get _filteredScholarships {
    return _scholarships
        .where(
          (s) =>
              _selectedCategory == 'All' || s['category'] == _selectedCategory,
        )
        .toList();
  }

  // Get scholarships based on application status
  List<Map<String, dynamic>> get _myApplications {
    return _scholarships.where((s) => s['isApplied'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarships'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Discover'), Tab(text: 'My Applications')],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ).then((_) {
                // Refresh state when returning from profile
                setState(() {
                  _isProfileComplete = true; // Simulating profile completion
                });
              });
            },
            tooltip: 'My Profile',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Discover Tab
          _buildDiscoverTab(),

          // My Applications Tab
          _buildApplicationsTab(),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return Column(
      children: [
        if (!_isProfileComplete)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      const Text(
                        'To see your best scholarship matches, please complete your profile.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    ).then((_) {
                      setState(() {
                        _isProfileComplete =
                            true; // Simulating profile completion
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber[800],
                    side: BorderSide(color: Colors.amber[800]!),
                  ),
                  child: const Text('Complete'),
                ),
              ],
            ),
          ),

        // Filter options
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Category',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            checkmarkColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Scholarship list
        Expanded(
          child:
              _filteredScholarships.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No scholarships found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredScholarships.length,
                    itemBuilder: (context, index) {
                      final scholarship = _filteredScholarships[index];
                      return _buildScholarshipCard(scholarship);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildApplicationsTab() {
    return _myApplications.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No scholarship applications yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _tabController.animateTo(0); // Switch to Discover tab
                },
                icon: const Icon(Icons.search),
                label: const Text('Browse Scholarships'),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _myApplications.length,
          itemBuilder: (context, index) {
            final application = _myApplications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            application['title'] as String,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildStatusChip(application['status'] as String),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${application['category']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Amount: ${application['amount']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Deadline: ${_formatDate(application['deadline'] as String)}',
                      style: TextStyle(
                        color:
                            _isDeadlineNear(application['deadline'] as String)
                                ? Colors.red
                                : Colors.grey[600],
                        fontWeight:
                            _isDeadlineNear(application['deadline'] as String)
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Application progress tracker
                    if (application['status'] as String == 'Under Review')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Application Progress',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Submitted',
                                style: TextStyle(fontSize: 12),
                              ),
                              const Text(
                                'Under Review',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Approved',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ScholarshipDetailScreen(
                                      scholarshipId:
                                          application['id'] as String,
                                      isApplied: true,
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildScholarshipCard(Map<String, dynamic> scholarship) {
    final bool isApplied = scholarship['isApplied'] as bool;
    final int matchPercentage = scholarship['matchPercentage'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ScholarshipDetailScreen(
                    scholarshipId: scholarship['id'] as String,
                    isApplied: isApplied,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scholarship['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${scholarship['category']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$matchPercentage% Match',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
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
                scholarship['description'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount: ${scholarship['amount']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Deadline: ${_formatDate(scholarship['deadline'] as String)}',
                    style: TextStyle(
                      color:
                          _isDeadlineNear(scholarship['deadline'] as String)
                              ? Colors.red
                              : Colors.grey[600],
                      fontWeight:
                          _isDeadlineNear(scholarship['deadline'] as String)
                              ? FontWeight.bold
                              : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Eligibility: ${scholarship['eligibility']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  if (isApplied)
                    _buildStatusChip(scholarship['status'] as String)
                  else
                    Expanded(
                      flex: 3,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ScholarshipDetailScreen(
                                    scholarshipId: scholarship['id'] as String,
                                    isApplied: false,
                                  ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Apply Now',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color? backgroundColor;
    Color? textColor;

    switch (status) {
      case 'Approved':
        backgroundColor = Colors.green[100];
        textColor = Colors.green[800];
        break;
      case 'Under Review':
        backgroundColor = Colors.orange[100];
        textColor = Colors.orange[800];
        break;
      case 'Rejected':
        backgroundColor = Colors.red[100];
        textColor = Colors.red[800];
        break;
      default:
        backgroundColor = Colors.grey[100];
        textColor = Colors.grey[800];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;

    if (difference <= 0) {
      return 'Expired';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference <= 7) {
      return '$difference days left';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  bool _isDeadlineNear(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;

    return difference >= 0 && difference <= 7;
  }
}
