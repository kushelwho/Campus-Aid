import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/faculty_rating_provider.dart';
import '../models/faculty_model.dart';
import '../models/review_model.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';
import 'add_review_screen.dart';

class FacultyDetailScreen extends StatefulWidget {
  final String facultyId;

  const FacultyDetailScreen({super.key, required this.facultyId});

  @override
  State<FacultyDetailScreen> createState() => _FacultyDetailScreenState();
}

class _FacultyDetailScreenState extends State<FacultyDetailScreen> {
  String _sortReviewsBy = 'newest';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FacultyRatingProvider>(context);
    final faculty = provider.getFaculty(widget.facultyId);
    final reviews = provider.getReviewsForFaculty(widget.facultyId);
    final sortedReviews = provider.sortReviews(reviews, _sortReviewsBy);
    final hasReviewed = provider.hasReviewedFaculty(widget.facultyId);

    return Scaffold(
      appBar: AppBar(title: Text(faculty.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faculty header with info and overall rating
            _buildFacultyHeader(context, faculty),

            const Divider(),

            // Ratings breakdown
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ratings (${faculty.totalReviews} ${faculty.totalReviews == 1 ? 'review' : 'reviews'})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRatingsBreakdown(faculty),
                ],
              ),
            ),

            const Divider(),

            // Reviews section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Reviews',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildSortDropdown(),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Reviews list
                  if (reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          'No reviews yet. Be the first to review!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedReviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCard(review: sortedReviews[index]);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          hasReviewed
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddReviewScreen(
                            facultyId: widget.facultyId,
                            facultyName: faculty.name,
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.rate_review),
                label: const Text('Write a Review'),
              ),
    );
  }

  Widget _buildFacultyHeader(BuildContext context, Faculty faculty) {
    final theme = Theme.of(context);
    final overallRating = faculty.calculateOverallRating();

    return Container(
      color: theme.primaryColor.withOpacity(0.05),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(faculty.imageUrl),
              ),
              const SizedBox(width: 16),

              // Faculty info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faculty.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${faculty.designation}, ${faculty.department}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingStars(rating: overallRating),
                        const SizedBox(width: 8),
                        Text(
                          overallRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${faculty.totalReviews})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Specialization
          if (faculty.specialization.isNotEmpty) ...[
            Text(
              'Specialization',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              faculty.specialization,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
          ],

          // Bio
          if (faculty.bio.isNotEmpty) ...[
            Text(
              'Bio',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              faculty.bio,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
          ],

          // Contact
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                faculty.email,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsBreakdown(Faculty faculty) {
    return Column(
      children: [
        _buildRatingBar(
          'Teaching Quality',
          faculty.averageRatings['teaching'] ?? 0,
        ),
        const SizedBox(height: 12),
        _buildRatingBar(
          'Grading Fairness',
          faculty.averageRatings['grading'] ?? 0,
        ),
        const SizedBox(height: 12),
        _buildRatingBar(
          'Engagement',
          faculty.averageRatings['engagement'] ?? 0,
        ),
      ],
    );
  }

  Widget _buildRatingBar(String label, double rating) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: rating / 5.0,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getRatingColor(rating),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Rating value
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingStars(rating: rating, size: 12),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortReviewsBy,
      icon: const Icon(Icons.sort),
      underline: Container(),
      borderRadius: BorderRadius.circular(8),
      items: const [
        DropdownMenuItem(value: 'newest', child: Text('Newest First')),
        DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
        DropdownMenuItem(value: 'highest', child: Text('Highest Rated')),
        DropdownMenuItem(value: 'lowest', child: Text('Lowest Rated')),
        DropdownMenuItem(value: 'helpful', child: Text('Most Helpful')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortReviewsBy = value;
          });
        }
      },
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.amber;
    if (rating >= 1.5) return Colors.orange;
    return Colors.red;
  }
}
