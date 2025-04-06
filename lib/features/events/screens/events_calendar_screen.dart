import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../models/event_model.dart';
import '../widgets/month_calendar.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class EventsCalendarScreen extends StatefulWidget {
  const EventsCalendarScreen({super.key});

  @override
  State<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends State<EventsCalendarScreen> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Event> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    // Get events for today
    Future.microtask(() {
      final eventsProvider = Provider.of<EventsProvider>(
        context,
        listen: false,
      );
      setState(() {
        _selectedDayEvents = eventsProvider.getEventsByDate(_selectedDay);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              // Go to today
              setState(() {
                _focusedMonth = DateTime.now();
                _selectedDay = DateTime.now();
                _updateSelectedDayEvents();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Navigate to registered events
              _showRegisteredEvents();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      // Go to previous month
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                        1,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      // Go to next month
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                        1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Monthly calendar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MonthCalendar(
              focusedMonth: _focusedMonth,
              onDaySelected: (day, events) {
                setState(() {
                  _selectedDay = day;
                  _selectedDayEvents = events;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Selected day header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Events on ${_formatDate(_selectedDay)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_selectedDayEvents.length} events',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Events list
          Expanded(
            child:
                _selectedDayEvents.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No events on this day',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _selectedDayEvents.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = _selectedDayEvents[index];

                        return EventCard(
                          event: event,
                          isCompact: true,
                          onTap: () {
                            // Navigate to event details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EventDetailScreen(eventId: event.id),
                              ),
                            ).then((_) {
                              // Refresh events after returning
                              _updateSelectedDayEvents();
                            });
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show upcoming events
          _showUpcomingEvents();
        },
        child: const Icon(Icons.view_agenda),
      ),
    );
  }

  void _updateSelectedDayEvents() {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    setState(() {
      _selectedDayEvents = eventsProvider.getEventsByDate(_selectedDay);
    });
  }

  void _showUpcomingEvents() {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final upcomingEvents = eventsProvider.upcomingEvents;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Upcoming Events',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      upcomingEvents.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No upcoming events',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                          : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: upcomingEvents.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final event = upcomingEvents[index];

                              return EventCard(
                                event: event,
                                isCompact: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EventDetailScreen(
                                            eventId: event.id,
                                          ),
                                    ),
                                  ).then((_) {
                                    // Refresh events after returning
                                    _updateSelectedDayEvents();
                                  });
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRegisteredEvents() {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final registeredEvents = eventsProvider.registeredEvents;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Your Registered Events',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      registeredEvents.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No registered events',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Register for events to see them here',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: registeredEvents.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final event = registeredEvents[index];

                              return EventCard(
                                event: event,
                                isCompact: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EventDetailScreen(
                                            eventId: event.id,
                                          ),
                                    ),
                                  ).then((_) {
                                    // Refresh events after returning
                                    _updateSelectedDayEvents();
                                  });
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
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

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return '$month $day, $year';
  }
}
