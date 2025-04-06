import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/faculty_model.dart';
import '../models/review_model.dart';
import 'package:uuid/uuid.dart';

class FacultyRatingProvider with ChangeNotifier {
  // Current student info (simplified for this demo)
  final String _currentStudentId = 's12345';
  final String _currentStudentName = 'John Doe';

  // Mock data
  List<Faculty> _faculties = [
    Faculty(
      id: 'f1',
      name: 'Dr. Sarah Johnson',
      department: 'Computer Science',
      designation: 'Associate Professor',
      imageUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
      email: 'sarah.johnson@university.edu',
      specialization: 'Artificial Intelligence, Machine Learning',
      bio:
          'Dr. Johnson has over 15 years of teaching experience and has published numerous papers in top AI conferences.',
      isVerified: true,
      averageRatings: {'teaching': 4.5, 'grading': 4.2, 'engagement': 4.8},
      totalReviews: 45,
    ),
    Faculty(
      id: 'f2',
      name: 'Prof. Michael Chen',
      department: 'Electrical Engineering',
      designation: 'Professor',
      imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      email: 'michael.chen@university.edu',
      specialization: 'Digital Signal Processing, Communication Systems',
      bio:
          'Prof. Chen is the head of the Electrical Engineering department and has been teaching for over 20 years.',
      isVerified: true,
      averageRatings: {'teaching': 4.0, 'grading': 3.8, 'engagement': 4.2},
      totalReviews: 38,
    ),
    Faculty(
      id: 'f3',
      name: 'Dr. Emily Rodriguez',
      department: 'Mathematics',
      designation: 'Assistant Professor',
      imageUrl: 'https://randomuser.me/api/portraits/women/45.jpg',
      email: 'emily.rodriguez@university.edu',
      specialization: 'Differential Equations, Linear Algebra',
      bio:
          'Dr. Rodriguez joined the faculty 5 years ago after completing her PhD at MIT. She specializes in applied mathematics.',
      isVerified: true,
      averageRatings: {'teaching': 4.7, 'grading': 4.5, 'engagement': 4.9},
      totalReviews: 28,
    ),
    Faculty(
      id: 'f4',
      name: 'Prof. David Wilson',
      department: 'Physics',
      designation: 'Professor',
      imageUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
      email: 'david.wilson@university.edu',
      specialization: 'Quantum Mechanics, Theoretical Physics',
      bio:
          'Prof. Wilson has authored several textbooks on physics and has been teaching for over 25 years.',
      isVerified: true,
      averageRatings: {'teaching': 3.9, 'grading': 3.5, 'engagement': 4.1},
      totalReviews: 52,
    ),
    Faculty(
      id: 'f5',
      name: 'Dr. Lisa Patel',
      department: 'Computer Science',
      designation: 'Assistant Professor',
      imageUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
      email: 'lisa.patel@university.edu',
      specialization: 'Computer Networks, Cybersecurity',
      bio:
          'Dr. Patel worked in industry for 10 years before joining academia. She brings practical experience to her teachings.',
      isVerified: true,
      averageRatings: {'teaching': 4.3, 'grading': 4.0, 'engagement': 4.5},
      totalReviews: 19,
    ),
  ];

  List<FacultyReview> _reviews = [
    FacultyReview(
      id: 'r1',
      facultyId: 'f1',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 15)),
      ratings: {'teaching': 4.5, 'grading': 4.0, 'engagement': 5.0},
      comment:
          'One of the best professors in the department. Her lectures are engaging and she\'s always willing to help during office hours.',
      isAnonymous: false,
      studentId: 's54321',
      studentName: 'Emma Thompson',
      helpfulVotes: 12,
      reportedBy: [],
      isVerified: true,
      courseCode: 'CS301',
      semester: 'Fall 2023',
    ),
    FacultyReview(
      id: 'r2',
      facultyId: 'f1',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 45)),
      ratings: {'teaching': 4.0, 'grading': 3.5, 'engagement': 4.5},
      comment:
          'Dr. Johnson explains complex concepts clearly. Her grading can be strict but fair.',
      isAnonymous: true,
      studentId: 's98765',
      studentName: 'Anonymous',
      helpfulVotes: 5,
      reportedBy: [],
      isVerified: true,
      courseCode: 'CS401',
      semester: 'Spring 2023',
    ),
    FacultyReview(
      id: 'r3',
      facultyId: 'f2',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 10)),
      ratings: {'teaching': 3.5, 'grading': 3.0, 'engagement': 4.0},
      comment:
          'Prof. Chen is knowledgeable but sometimes lectures can be difficult to follow. Office hours are very helpful though.',
      isAnonymous: false,
      studentId: 's12345',
      studentName: 'John Doe',
      helpfulVotes: 3,
      reportedBy: [],
      isVerified: true,
      courseCode: 'EE201',
      semester: 'Fall 2023',
    ),
  ];

  // Getters
  List<Faculty> get faculties => [..._faculties];
  List<FacultyReview> get reviews => [..._reviews];

  // Get a single faculty
  Faculty getFaculty(String id) {
    return _faculties.firstWhere((faculty) => faculty.id == id);
  }

  // Get reviews for a faculty
  List<FacultyReview> getReviewsForFaculty(String facultyId) {
    return _reviews.where((review) => review.facultyId == facultyId).toList();
  }

  // Check if current student has reviewed a faculty
  bool hasReviewedFaculty(String facultyId) {
    return _reviews.any(
      (review) =>
          review.facultyId == facultyId &&
          review.studentId == _currentStudentId,
    );
  }

  // Search faculties
  List<Faculty> searchFaculties(String query) {
    if (query.isEmpty) return faculties;

    final lowercaseQuery = query.toLowerCase();
    return _faculties.where((faculty) {
      return faculty.name.toLowerCase().contains(lowercaseQuery) ||
          faculty.department.toLowerCase().contains(lowercaseQuery) ||
          faculty.specialization.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filter faculties by department and minimum rating
  List<Faculty> filterFaculties({
    String? department,
    double minimumRating = 0.0,
  }) {
    return _faculties.where((faculty) {
      final passesDepFilter =
          department == null || faculty.department == department;
      final passesRatingFilter =
          faculty.calculateOverallRating() >= minimumRating;
      return passesDepFilter && passesRatingFilter;
    }).toList();
  }

  // Sort faculties
  List<Faculty> sortFaculties(List<Faculty> faculties, String sortBy) {
    final result = [...faculties];

    switch (sortBy) {
      case 'rating_high':
        result.sort(
          (a, b) =>
              b.calculateOverallRating().compareTo(a.calculateOverallRating()),
        );
        break;
      case 'rating_low':
        result.sort(
          (a, b) =>
              a.calculateOverallRating().compareTo(b.calculateOverallRating()),
        );
        break;
      case 'name_asc':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return result;
  }

  // Sort reviews
  List<FacultyReview> sortReviews(List<FacultyReview> reviews, String sortBy) {
    final result = [...reviews];

    switch (sortBy) {
      case 'newest':
        result.sort((a, b) => b.dateSubmitted.compareTo(a.dateSubmitted));
        break;
      case 'oldest':
        result.sort((a, b) => a.dateSubmitted.compareTo(b.dateSubmitted));
        break;
      case 'highest':
        result.sort(
          (a, b) =>
              b.calculateOverallRating().compareTo(a.calculateOverallRating()),
        );
        break;
      case 'lowest':
        result.sort(
          (a, b) =>
              a.calculateOverallRating().compareTo(b.calculateOverallRating()),
        );
        break;
      case 'helpful':
        result.sort((a, b) => b.helpfulVotes.compareTo(a.helpfulVotes));
        break;
    }

    return result;
  }

  // Submit a review
  Future<bool> submitReview({
    required String facultyId,
    required Map<String, double> ratings,
    required String comment,
    required bool isAnonymous,
    required String courseCode,
    required String semester,
  }) async {
    try {
      // Check if user has already reviewed this faculty
      if (hasReviewedFaculty(facultyId)) {
        // Update existing review
        final existingReviewIndex = _reviews.indexWhere(
          (review) =>
              review.facultyId == facultyId &&
              review.studentId == _currentStudentId,
        );

        if (existingReviewIndex >= 0) {
          final existingReview = _reviews[existingReviewIndex];
          _reviews[existingReviewIndex] = existingReview.copyWith(
            ratings: ratings,
            comment: comment,
            isAnonymous: isAnonymous,
            courseCode: courseCode,
            semester: semester,
            dateSubmitted: DateTime.now(),
          );

          _updateFacultyRatings(facultyId);
          notifyListeners();
          return true;
        }

        return false;
      } else {
        // Create new review
        final newReview = FacultyReview(
          id: const Uuid().v4(),
          facultyId: facultyId,
          dateSubmitted: DateTime.now(),
          ratings: ratings,
          comment: comment,
          isAnonymous: isAnonymous,
          studentId: _currentStudentId,
          studentName: _currentStudentName,
          helpfulVotes: 0,
          reportedBy: [],
          isVerified: true,
          courseCode: courseCode,
          semester: semester,
        );

        _reviews.add(newReview);
        _updateFacultyRatings(facultyId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error submitting review: $e');
      return false;
    }
  }

  // Mark a review as helpful
  void markReviewAsHelpful(String reviewId) {
    final reviewIndex = _reviews.indexWhere((review) => review.id == reviewId);
    if (reviewIndex >= 0) {
      final review = _reviews[reviewIndex];
      _reviews[reviewIndex] = review.copyWith(
        helpfulVotes: review.helpfulVotes + 1,
      );
      notifyListeners();
    }
  }

  // Report a review
  void reportReview(String reviewId, String reason, String comment) {
    final reviewIndex = _reviews.indexWhere((review) => review.id == reviewId);
    if (reviewIndex >= 0) {
      final review = _reviews[reviewIndex];

      if (!review.reportedBy.contains(_currentStudentId)) {
        final List<String> reportedBy = [
          ...review.reportedBy,
          _currentStudentId,
        ];
        _reviews[reviewIndex] = review.copyWith(reportedBy: reportedBy);

        // In a real app, you'd send the reason and comment to the backend
        debugPrint(
          'Review $reviewId reported for reason: $reason. Comment: $comment',
        );

        notifyListeners();
      }
    }
  }

  // Update faculty ratings based on reviews
  void _updateFacultyRatings(String facultyId) {
    final facultyReviews = getReviewsForFaculty(facultyId);
    final facultyIndex = _faculties.indexWhere(
      (faculty) => faculty.id == facultyId,
    );

    if (facultyIndex >= 0 && facultyReviews.isNotEmpty) {
      final faculty = _faculties[facultyIndex];

      // Calculate average ratings
      Map<String, double> averageRatings = {};
      facultyReviews.first.ratings.keys.forEach((category) {
        double sum = 0;
        int count = 0;

        for (var review in facultyReviews) {
          if (review.ratings.containsKey(category)) {
            sum += review.ratings[category]!;
            count++;
          }
        }

        if (count > 0) {
          averageRatings[category] = sum / count;
        }
      });

      // Update faculty
      _faculties[facultyIndex] = faculty.copyWith(
        averageRatings: averageRatings,
        totalReviews: facultyReviews.length,
      );
    }
  }
}
