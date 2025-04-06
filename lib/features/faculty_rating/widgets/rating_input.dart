import 'package:flutter/material.dart';

class RatingInput extends StatelessWidget {
  final String label;
  final double initialRating;
  final Function(double) onRatingChanged;

  const RatingInput({
    super.key,
    required this.label,
    required this.initialRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final rating = index + 1.0;
                  return _buildStar(context, rating);
                }),
              ),
            ),
            Container(
              width: 48,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                initialRating == 0 ? "-" : initialRating.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Poor', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              'Excellent',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStar(BuildContext context, double rating) {
    final isSelected = rating <= initialRating;
    final isHalfSelected = rating == initialRating + 0.5;

    return GestureDetector(
      onTap: () => onRatingChanged(rating),
      child: Icon(
        isSelected ? Icons.star : Icons.star_border,
        color: isSelected ? Colors.amber : Colors.grey,
        size: 36,
      ),
    );
  }
}
