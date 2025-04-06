import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventsProvider extends ChangeNotifier {
  // Mock data for events - in a real app, this would come from an API
  final List<Event> _events = [
    Event(
      id: 'e1',
      title: 'Annual Tech Fest',
      description:
          'Join us for a day of technology, innovation, and fun at the campus annual tech fest. Features coding competitions, robotics demonstrations, and tech talks from industry experts.',
      date: DateTime.now().add(const Duration(days: 7)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 0),
      location: 'Main Auditorium',
      organizer: 'Computer Science Society',
      imageUrl:
          'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      tags: ['Technology', 'Competition', 'Workshop'],
      capacity: 500,
      registeredCount: 327,
    ),
    Event(
      id: 'e2',
      title: 'Cultural Night',
      description:
          'Experience diverse cultures through performances, food, and art. An evening celebrating the rich diversity of our campus community.',
      date: DateTime.now().add(const Duration(days: 14)),
      startTime: const TimeOfDay(hour: 17, minute: 0),
      endTime: const TimeOfDay(hour: 22, minute: 0),
      location: 'Campus Grounds',
      organizer: 'Cultural Club',
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      tags: ['Cultural', 'Music', 'Food'],
      capacity: 1000,
      registeredCount: 567,
    ),
    Event(
      id: 'e3',
      title: 'Career Fair 2023',
      description:
          'Connect with top employers, explore internship and job opportunities, and network with industry professionals. Bring your resume!',
      date: DateTime.now().add(const Duration(days: 21)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
      location: 'Central Library Hall',
      organizer: 'Career Services',
      imageUrl:
          'https://images.unsplash.com/photo-1560523159-4a9692d222f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      tags: ['Career', 'Networking', 'Professional'],
      capacity: 300,
      registeredCount: 198,
      isPaid: true,
      fee: 5.0,
    ),
    Event(
      id: 'e4',
      title: 'Sports Tournament',
      description:
          'Annual inter-college sports competition with events including cricket, football, basketball, and athletics. Come support your college team!',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      location: 'Sports Complex',
      organizer: 'Sports Department',
      imageUrl:
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      tags: ['Sports', 'Competition', 'Outdoor'],
      capacity: 800,
      registeredCount: 542,
    ),
    Event(
      id: 'e5',
      title: 'Entrepreneurship Workshop',
      description:
          'Learn from successful entrepreneurs about starting your own business, securing funding, and scaling your startup.',
      date: DateTime.now().add(const Duration(days: 10)),
      startTime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 0),
      location: 'Business School Auditorium',
      organizer: 'E-Cell',
      imageUrl:
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      tags: ['Business', 'Workshop', 'Networking'],
      capacity: 150,
      registeredCount: 87,
      isPaid: true,
      fee: 10.0,
    ),
  ];

  // Get all events
  List<Event> get events => [..._events];

  // Get upcoming events (next 7 days)
  List<Event> get upcomingEvents {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));
    return _events
        .where(
          (event) =>
              event.date.isAfter(now) && event.date.isBefore(sevenDaysLater),
        )
        .toList();
  }

  // Get events by month and year
  List<Event> getEventsByMonth(int year, int month) {
    return _events
        .where((event) => event.date.year == year && event.date.month == month)
        .toList();
  }

  // Get events for a specific date
  List<Event> getEventsByDate(DateTime date) {
    return _events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();
  }

  // Get event by ID
  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  // Register for an event
  Future<bool> registerForEvent(String eventId) async {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return false;

    final event = _events[index];

    // Check if capacity has been reached
    if (event.registeredCount >= event.capacity) {
      return false;
    }

    // Update the event with increased registration count and mark as registered
    _events[index] = event.copyWith(
      registeredCount: event.registeredCount + 1,
      isRegistered: true,
    );

    notifyListeners();
    return true;
  }

  // Cancel registration for an event
  Future<bool> cancelRegistration(String eventId) async {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return false;

    final event = _events[index];

    // Check if user is registered for this event
    if (!event.isRegistered) {
      return false;
    }

    // Update the event with decreased registration count and mark as not registered
    _events[index] = event.copyWith(
      registeredCount: event.registeredCount - 1,
      isRegistered: false,
    );

    notifyListeners();
    return true;
  }

  // Get registered events
  List<Event> get registeredEvents {
    return _events.where((event) => event.isRegistered).toList();
  }

  // Get events by tag
  List<Event> getEventsByTag(String tag) {
    return _events.where((event) => event.tags.contains(tag)).toList();
  }
}
