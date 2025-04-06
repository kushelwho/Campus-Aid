import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/faculty_rating_provider.dart';
import '../models/faculty_model.dart';
import '../widgets/rating_stars.dart';
import 'faculty_detail_screen.dart';

class FacultyListScreen extends StatefulWidget {
  const FacultyListScreen({super.key});

  @override
  State<FacultyListScreen> createState() => _FacultyListScreenState();
}

class _FacultyListScreenState extends State<FacultyListScreen> {
  String _searchQuery = '';
  String? _selectedDepartment;
  double _minRating = 0.0;
  String _sortBy =
      'rating_high'; // Options: rating_high, rating_low, name_asc, name_desc

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FacultyRatingProvider>(context);

    // Filter and sort faculties
    List<Faculty> faculties = provider.searchFaculties(_searchQuery);
    faculties = provider.filterFaculties(
      department: _selectedDepartment,
      minimumRating: _minRating,
    );
    faculties = provider.sortFaculties(faculties, _sortBy);

    // Get all departments for the filter dropdown
    final List<String> departments =
        faculties.map((faculty) => faculty.department).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Ratings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, departments);
            },
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortDialog(context);
            },
            tooltip: 'Sort',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search faculty by name or department',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Active filters
          if (_selectedDepartment != null || _minRating > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Active filters:', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  if (_selectedDepartment != null)
                    Chip(
                      label: Text(_selectedDepartment!),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedDepartment = null;
                        });
                      },
                    ),
                  if (_minRating > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Chip(
                        label: Text('★ ${_minRating.toStringAsFixed(1)}+'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _minRating = 0.0;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${faculties.length} ${faculties.length == 1 ? 'faculty' : 'faculties'} found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          // Faculty list
          Expanded(
            child:
                faculties.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No faculty members found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or search terms',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: faculties.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final faculty = faculties[index];
                        return _buildFacultyCard(context, faculty);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyCard(BuildContext context, Faculty faculty) {
    final overallRating = faculty.calculateOverallRating();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to faculty detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacultyDetailScreen(facultyId: faculty.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Faculty image
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(faculty.imageUrl),
              ),
              const SizedBox(width: 16),

              // Faculty details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faculty.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${faculty.designation}, ${faculty.department}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingStars(rating: overallRating),
                        const SizedBox(width: 8),
                        Text(
                          overallRating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${faculty.totalReviews})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      faculty.specialization,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, List<String> departments) {
    String? tempDepartment = _selectedDepartment;
    double tempMinRating = _minRating;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Filter Faculties'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Department filter
                      const Text(
                        'Department',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String?>(
                        value: tempDepartment,
                        decoration: const InputDecoration(
                          hintText: 'Select department',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All Departments'),
                          ),
                          ...departments.map(
                            (dept) => DropdownMenuItem<String?>(
                              value: dept,
                              child: Text(dept),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tempDepartment = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Rating filter
                      const Text(
                        'Minimum Rating',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: tempMinRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: tempMinRating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            tempMinRating = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('No minimum'),
                          Text('${tempMinRating.toStringAsFixed(1)} stars'),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Reset filters
                      setState(() {
                        tempDepartment = null;
                        tempMinRating = 0.0;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      this.setState(() {
                        _selectedDepartment = tempDepartment;
                        _minRating = tempMinRating;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showSortDialog(BuildContext context) {
    String tempSortBy = _sortBy;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sort By'),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Highest Rating'),
                  value: 'rating_high',
                  groupValue: tempSortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Lowest Rating'),
                  value: 'rating_low',
                  groupValue: tempSortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Name (A-Z)'),
                  value: 'name_asc',
                  groupValue: tempSortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Name (Z-A)'),
                  value: 'name_desc',
                  groupValue: tempSortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
    );
  }
}
