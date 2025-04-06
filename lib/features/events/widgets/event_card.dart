import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isCompact;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: isCompact ? _buildCompactCard(context) : _buildFullCard(context),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    // Format time for display
    final startTimeStr = _formatTimeOfDay(event.startTime);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startTimeStr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    // Format date and time for display
    final dateStr = _formatDate(event.date);
    final timeStr =
        '${_formatTimeOfDay(event.startTime)} - ${_formatTimeOfDay(event.endTime)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event image with gradient overlay
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            image: DecorationImage(
              image: NetworkImage(event.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.6, 1.0],
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Event details
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and time
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(dateStr, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(timeStr, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 12),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Organizer
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    event.organizer,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    event.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),

              // Capacity indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capacity: ${event.registeredCount}/${event.capacity}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: event.registeredCount / event.capacity,
                    backgroundColor: Colors.grey[200],
                    color: _getProgressColor(
                      context,
                      event.registeredCount / event.capacity,
                    ),
                  ),
                ],
              ),

              // Fee if applicable
              if (event.isPaid) ...[
                const SizedBox(height: 12),
                Text(
                  'Fee: \$${event.fee?.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return '$month $day, $year';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  Color _getProgressColor(BuildContext context, double progressValue) {
    if (progressValue < 0.5) {
      return Colors.green;
    } else if (progressValue < 0.8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
