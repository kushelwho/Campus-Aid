import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String organizer;
  final String imageUrl;
  final List<String> tags;
  final int capacity;
  final int registeredCount;
  final bool isRegistered;
  final bool isPaid;
  final double? fee;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.organizer,
    required this.imageUrl,
    required this.tags,
    required this.capacity,
    required this.registeredCount,
    this.isRegistered = false,
    this.isPaid = false,
    this.fee,
  });

  // Convert Event to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'location': location,
      'organizer': organizer,
      'imageUrl': imageUrl,
      'tags': tags,
      'capacity': capacity,
      'registeredCount': registeredCount,
      'isRegistered': isRegistered,
      'isPaid': isPaid,
      'fee': fee,
    };
  }

  // Create Event from Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      startTime: TimeOfDay(
        hour: map['startTime']['hour'],
        minute: map['startTime']['minute'],
      ),
      endTime: TimeOfDay(
        hour: map['endTime']['hour'],
        minute: map['endTime']['minute'],
      ),
      location: map['location'],
      organizer: map['organizer'],
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags']),
      capacity: map['capacity'],
      registeredCount: map['registeredCount'],
      isRegistered: map['isRegistered'] ?? false,
      isPaid: map['isPaid'] ?? false,
      fee: map['fee'],
    );
  }

  // Copy with method for creating a modified copy of an event
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? organizer,
    String? imageUrl,
    List<String>? tags,
    int? capacity,
    int? registeredCount,
    bool? isRegistered,
    bool? isPaid,
    double? fee,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      isRegistered: isRegistered ?? this.isRegistered,
      isPaid: isPaid ?? this.isPaid,
      fee: fee ?? this.fee,
    );
  }
}
