import 'package:flutter/foundation.dart';

class FacultyReview {
  final String id;
  final String facultyId;
  final DateTime dateSubmitted;
  final Map<String, double> ratings;
  final String comment;
  final bool isAnonymous;
  final String studentId;
  final String studentName;
  final int helpfulVotes;
  final List<String> reportedBy;
  final bool isVerified;
  final String courseCode;
  final String semester;

  const FacultyReview({
    required this.id,
    required this.facultyId,
    required this.dateSubmitted,
    required this.ratings,
    required this.comment,
    required this.isAnonymous,
    required this.studentId,
    required this.studentName,
    this.helpfulVotes = 0,
    this.reportedBy = const [],
    this.isVerified = false,
    required this.courseCode,
    required this.semester,
  });

  // Calculate overall rating as average of all rating categories
  double calculateOverallRating() {
    if (ratings.isEmpty) return 0.0;

    double sum = 0.0;
    for (var rating in ratings.values) {
      sum += rating;
    }
    return sum / ratings.length;
  }

  // Get a relative time string (e.g., "2 days ago")
  String getTimeAgoString() {
    final now = DateTime.now();
    final difference = now.difference(dateSubmitted);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // Convert review to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'facultyId': facultyId,
      'dateSubmitted': dateSubmitted.toIso8601String(),
      'ratings': ratings,
      'comment': comment,
      'isAnonymous': isAnonymous,
      'studentId': studentId,
      'studentName': studentName,
      'helpfulVotes': helpfulVotes,
      'reportedBy': reportedBy,
      'isVerified': isVerified,
      'courseCode': courseCode,
      'semester': semester,
    };
  }

  // Create review from Map
  factory FacultyReview.fromMap(Map<String, dynamic> map) {
    return FacultyReview(
      id: map['id'],
      facultyId: map['facultyId'],
      dateSubmitted: DateTime.parse(map['dateSubmitted']),
      ratings: Map<String, double>.from(map['ratings']),
      comment: map['comment'],
      isAnonymous: map['isAnonymous'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      helpfulVotes: map['helpfulVotes'],
      reportedBy: List<String>.from(map['reportedBy']),
      isVerified: map['isVerified'],
      courseCode: map['courseCode'],
      semester: map['semester'],
    );
  }

  // Create a copy with some changes
  FacultyReview copyWith({
    String? id,
    String? facultyId,
    DateTime? dateSubmitted,
    Map<String, double>? ratings,
    String? comment,
    bool? isAnonymous,
    String? studentId,
    String? studentName,
    int? helpfulVotes,
    List<String>? reportedBy,
    bool? isVerified,
    String? courseCode,
    String? semester,
  }) {
    return FacultyReview(
      id: id ?? this.id,
      facultyId: facultyId ?? this.facultyId,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
      ratings: ratings ?? this.ratings,
      comment: comment ?? this.comment,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      reportedBy: reportedBy ?? this.reportedBy,
      isVerified: isVerified ?? this.isVerified,
      courseCode: courseCode ?? this.courseCode,
      semester: semester ?? this.semester,
    );
  }
}
