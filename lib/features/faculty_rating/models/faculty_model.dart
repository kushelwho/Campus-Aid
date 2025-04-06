import 'package:flutter/foundation.dart';

class Faculty {
  final String id;
  final String name;
  final String department;
  final String designation;
  final String imageUrl;
  final String email;
  final String specialization;
  final String bio;
  final bool isVerified;
  final Map<String, double> averageRatings;
  final int totalReviews;

  const Faculty({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    required this.imageUrl,
    required this.email,
    required this.specialization,
    required this.bio,
    this.isVerified = true,
    required this.averageRatings,
    required this.totalReviews,
  });

  // Calculate overall rating as average of all rating categories
  double calculateOverallRating() {
    if (averageRatings.isEmpty) return 0.0;

    double sum = 0.0;
    for (var rating in averageRatings.values) {
      sum += rating;
    }
    return sum / averageRatings.length;
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'designation': designation,
      'imageUrl': imageUrl,
      'email': email,
      'specialization': specialization,
      'bio': bio,
      'isVerified': isVerified,
      'averageRatings': averageRatings,
      'totalReviews': totalReviews,
    };
  }

  // Create from Map
  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      id: map['id'],
      name: map['name'],
      department: map['department'],
      designation: map['designation'],
      imageUrl: map['imageUrl'],
      email: map['email'],
      specialization: map['specialization'],
      bio: map['bio'],
      isVerified: map['isVerified'] ?? true,
      averageRatings: Map<String, double>.from(map['averageRatings']),
      totalReviews: map['totalReviews'],
    );
  }

  // Create a copy with some changes
  Faculty copyWith({
    String? id,
    String? name,
    String? department,
    String? designation,
    String? imageUrl,
    String? email,
    String? specialization,
    String? bio,
    bool? isVerified,
    Map<String, double>? averageRatings,
    int? totalReviews,
  }) {
    return Faculty(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      averageRatings: averageRatings ?? this.averageRatings,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}
