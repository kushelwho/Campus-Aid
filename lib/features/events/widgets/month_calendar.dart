import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../models/event_model.dart';

class MonthCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final Function(DateTime, List<Event>) onDaySelected;

  const MonthCalendar({
    super.key,
    required this.focusedMonth,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventsProvider>(context);
    final daysInMonth = _getDaysInMonth(focusedMonth.year, focusedMonth.month);
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    );

    // Calculate start offset (which day of the week is the 1st)
    final startOffset = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        _buildMonthHeader(context),
        const SizedBox(height: 16),
        _buildWeekdayHeader(context),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
          ),
          itemCount: lastDayOfMonth.day + startOffset,
          itemBuilder: (context, index) {
            if (index < startOffset) {
              return const SizedBox(); // Empty cells before month start
            }

            final day = index - startOffset + 1;
            final date = DateTime(focusedMonth.year, focusedMonth.month, day);
            final events = eventsProvider.getEventsByDate(date);
            final hasEvents = events.isNotEmpty;
            final isToday = _isToday(date);

            return GestureDetector(
              onTap: () => onDaySelected(date, events),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      isToday
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isToday
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (hasEvents)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${months[focusedMonth.month - 1]} ${focusedMonth.year}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    final weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          weekdays
              .map(
                (day) => SizedBox(
                  width: 30,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
