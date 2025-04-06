import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review_model.dart';
import '../providers/faculty_rating_provider.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final FacultyReview review;
  final bool showActions;

  const ReviewCard({super.key, required this.review, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FacultyRatingProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with student info and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.isAnonymous
                              ? 'Anonymous Student'
                              : review.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${review.courseCode} • ${review.semester}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      review.getTimeAgoString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (review.isVerified)
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Overall rating
            Row(
              children: [
                RatingStars(rating: review.calculateOverallRating()),
                const SizedBox(width: 8),
                Text(
                  review.calculateOverallRating().toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            // Category ratings
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCategoryRating(
                  'Teaching',
                  review.ratings['teaching'] ?? 0,
                ),
                const SizedBox(width: 16),
                _buildCategoryRating('Grading', review.ratings['grading'] ?? 0),
                const SizedBox(width: 16),
                _buildCategoryRating(
                  'Engagement',
                  review.ratings['engagement'] ?? 0,
                ),
              ],
            ),

            // Review comment
            const SizedBox(height: 16),
            Text(review.comment, style: const TextStyle(fontSize: 14)),

            // Actions (helpful, report)
            if (showActions)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Helpful button
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.markReviewAsHelpful(review.id);
                      },
                      icon: const Icon(Icons.thumb_up_outlined, size: 16),
                      label: Text(
                        'Helpful ${review.helpfulVotes > 0 ? "(${review.helpfulVotes})" : ""}',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),

                    // Report button
                    TextButton.icon(
                      onPressed: () {
                        _showReportDialog(context, provider);
                      },
                      icon: const Icon(Icons.flag_outlined, size: 16),
                      label: const Text('Report'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRating(String category, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(Icons.star, size: 14, color: Colors.amber.shade600),
          ],
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context, FacultyRatingProvider provider) {
    final reasons = [
      'Offensive or inappropriate language',
      'Off-topic content',
      'Personal attack',
      'Spam',
      'Other',
    ];

    String? selectedReason;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Report Review'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why are you reporting this review?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...reasons.map(
                        (reason) => RadioListTile<String>(
                          title: Text(reason),
                          value: reason,
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Additional comments (optional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed:
                        selectedReason == null
                            ? null
                            : () {
                              // Call the reportReview method with the correct parameter order
                              if (selectedReason != null) {
                                provider.reportReview(
                                  review.id,
                                  selectedReason!,
                                  commentController.text,
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Review reported. Thank you for your feedback.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                    child: const Text('Submit Report'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
