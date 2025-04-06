import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/faculty_rating_provider.dart';
import '../widgets/rating_input.dart';

class AddReviewScreen extends StatefulWidget {
  final String facultyId;
  final String facultyName;

  const AddReviewScreen({
    super.key,
    required this.facultyId,
    required this.facultyName,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentController = TextEditingController();
  final _courseCodeController = TextEditingController();

  final Map<String, double> _ratings = {
    'teaching': 0.0,
    'grading': 0.0,
    'engagement': 0.0,
  };

  bool _isAnonymous = false;
  String _selectedSemester = 'Fall 2023';
  bool _isSubmitting = false;

  final List<String> _semesters = [
    'Fall 2023',
    'Summer 2023',
    'Spring 2023',
    'Fall 2022',
    'Summer 2022',
    'Spring 2022',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _courseCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FacultyRatingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faculty info
            Text(
              'Reviewing: ${widget.facultyName}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Course information
            const Text(
              'Course Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Course code
            TextField(
              controller: _courseCodeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                hintText: 'E.g., CS101, MATH201',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Semester dropdown
            DropdownButtonFormField<String>(
              value: _selectedSemester,
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
              items:
                  _semesters
                      .map(
                        (semester) => DropdownMenuItem<String>(
                          value: semester,
                          child: Text(semester),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSemester = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Ratings
            const Text(
              'Ratings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Teaching rating
            RatingInput(
              label: 'Teaching Quality',
              initialRating: _ratings['teaching'] ?? 0,
              onRatingChanged: (rating) {
                setState(() {
                  _ratings['teaching'] = rating;
                });
              },
            ),
            const SizedBox(height: 16),

            // Grading rating
            RatingInput(
              label: 'Grading Fairness',
              initialRating: _ratings['grading'] ?? 0,
              onRatingChanged: (rating) {
                setState(() {
                  _ratings['grading'] = rating;
                });
              },
            ),
            const SizedBox(height: 16),

            // Engagement rating
            RatingInput(
              label: 'Engagement',
              initialRating: _ratings['engagement'] ?? 0,
              onRatingChanged: (rating) {
                setState(() {
                  _ratings['engagement'] = rating;
                });
              },
            ),
            const SizedBox(height: 24),

            // Review comment
            const Text(
              'Your Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Share your experience with this faculty member...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            // Anonymous option
            SwitchListTile(
              title: const Text(
                'Post Anonymously',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Your name will not be displayed with your review.',
              ),
              value: _isAnonymous,
              onChanged: (value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
            ),

            const SizedBox(height: 8),

            // Guidelines
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Review Guidelines',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Be respectful and constructive.\n'
                      '• Focus on your personal experience.\n'
                      '• Do not include other students\' names.\n'
                      '• Avoid profanity or discriminatory language.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    _isSubmitting
                        ? null
                        : () => _submitReview(context, provider),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview(
    BuildContext context,
    FacultyRatingProvider provider,
  ) async {
    // Validate inputs
    if (_courseCodeController.text.isEmpty) {
      _showErrorSnackBar(context, 'Please enter a course code');
      return;
    }

    if (_ratings.values.any((rating) => rating == 0)) {
      _showErrorSnackBar(context, 'Please rate all categories');
      return;
    }

    if (_commentController.text.isEmpty) {
      _showErrorSnackBar(context, 'Please enter a review comment');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await provider.submitReview(
        facultyId: widget.facultyId,
        ratings: _ratings,
        comment: _commentController.text,
        isAnonymous: _isAnonymous,
        courseCode: _courseCodeController.text,
        semester: _selectedSemester,
      );

      if (success) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your review was submitted successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        if (!mounted) return;
        _showErrorSnackBar(
          context,
          'Failed to submit your review. Please try again.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(context, 'An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
