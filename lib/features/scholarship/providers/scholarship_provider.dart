import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/scholarship_model.dart';

class ScholarshipProvider with ChangeNotifier {
  List<ScholarshipModel> _scholarships = [];
  bool _isLoading = true;
  bool _initialized = false;

  ScholarshipProvider() {
    _loadScholarships();
  }

  List<ScholarshipModel> get scholarships => [..._scholarships];
  bool get isLoading => _isLoading;

  List<ScholarshipModel> get appliedScholarships =>
      _scholarships.where((s) => s.isApplied).toList();

  List<ScholarshipModel> getFilteredScholarships(String category) {
    if (category == 'All') {
      return [..._scholarships];
    } else {
      return _scholarships.where((s) => s.category == category).toList();
    }
  }

  // Get scholarships with deadlines that are near (within 7 days)
  List<ScholarshipModel> getScholarshipsWithNearDeadlines() {
    final now = DateTime.now();
    return _scholarships.where((scholarship) {
      final deadline = DateTime.parse(scholarship.deadline);
      final daysRemaining = deadline.difference(now).inDays;
      return daysRemaining >= 0 && daysRemaining <= 7;
    }).toList();
  }

  // Get the scholarship with the nearest deadline
  ScholarshipModel? getScholarshipWithNearestDeadline() {
    final nearDeadlines = getScholarshipsWithNearDeadlines();
    if (nearDeadlines.isEmpty) {
      return null;
    }

    // Sort by deadline (ascending)
    nearDeadlines.sort((a, b) {
      final deadlineA = DateTime.parse(a.deadline);
      final deadlineB = DateTime.parse(b.deadline);
      return deadlineA.compareTo(deadlineB);
    });

    // Return the scholarship with the closest deadline
    return nearDeadlines.first;
  }

  // Load scholarships from SharedPreferences
  Future<void> _loadScholarships() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final scholarshipsJson = prefs.getString('scholarships');

      if (scholarshipsJson != null) {
        // If we have stored scholarships, use them
        final List<dynamic> decoded = jsonDecode(scholarshipsJson);
        _scholarships =
            decoded.map((item) => ScholarshipModel.fromJson(item)).toList();
        print(
          'Loaded ${_scholarships.length} scholarships from SharedPreferences',
        );
      } else {
        // First run, save the default scholarships
        print('No stored scholarships found, using defaults');
        _scholarships = _getDefaultScholarships();
        _saveScholarships();
      }

      _initialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('ERROR loading scholarships from SharedPreferences: $e');
      // Continue with default scholarships if there's an error
      _scholarships = _getDefaultScholarships();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save scholarships to SharedPreferences
  Future<void> _saveScholarships() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scholarshipsJson = jsonEncode(
        _scholarships.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('scholarships', scholarshipsJson);
      print('Saved ${_scholarships.length} scholarships to SharedPreferences');
    } catch (e) {
      print('ERROR saving scholarships to SharedPreferences: $e');
    }
  }

  // Apply for a scholarship
  Future<void> applyForScholarship(String id) async {
    final scholarshipIndex = _scholarships.indexWhere((s) => s.id == id);
    if (scholarshipIndex >= 0) {
      final scholarship = _scholarships[scholarshipIndex];
      final updatedScholarship = ScholarshipModel(
        id: scholarship.id,
        title: scholarship.title,
        category: scholarship.category,
        description: scholarship.description,
        amount: scholarship.amount,
        deadline: scholarship.deadline,
        eligibility: scholarship.eligibility,
        matchPercentage: scholarship.matchPercentage,
        isApplied: true,
        status: 'Under Review',
      );

      _scholarships[scholarshipIndex] = updatedScholarship;
      await _saveScholarships();
      notifyListeners();
    }
  }

  // Get a scholarship by ID
  ScholarshipModel? getScholarshipById(String id) {
    try {
      return _scholarships.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // Default scholarships data
  List<ScholarshipModel> _getDefaultScholarships() {
    return [
      ScholarshipModel(
        id: '1',
        title: 'National Merit Scholarship',
        category: 'Merit',
        description:
            'Scholarship for students with outstanding academic achievements.',
        amount: '₹50,000',
        deadline: '2023-05-30',
        eligibility: 'CGPA 8.5 or above, any discipline',
        matchPercentage: 92,
      ),
      ScholarshipModel(
        id: '2',
        title: 'Financial Aid Scholarship',
        category: 'Need-based',
        description: 'Support for students from economically weaker sections.',
        amount: '₹30,000',
        deadline: '2023-06-15',
        eligibility: 'Annual family income below ₹3,00,000',
        matchPercentage: 78,
        isApplied: true,
        status: 'Under Review',
      ),
      ScholarshipModel(
        id: '3',
        title: 'Engineering Excellence Scholarship',
        category: 'Merit',
        description: 'For top-performing engineering students.',
        amount: '₹40,000',
        deadline: '2023-05-20',
        eligibility: 'Engineering students with CGPA 9.0 or above',
        matchPercentage: 85,
      ),
      ScholarshipModel(
        id: '4',
        title: 'Sports Achievement Grant',
        category: 'Sports',
        description:
            'For students representing college in national sports events.',
        amount: '₹25,000',
        deadline: '2023-07-10',
        eligibility: 'State or national level sports certificate',
        matchPercentage: 65,
        isApplied: true,
        status: 'Approved',
      ),
      ScholarshipModel(
        id: '5',
        title: 'Research Fellowship',
        category: 'Research',
        description: 'Support for students pursuing research projects.',
        amount: '₹60,000',
        deadline: '2023-06-30',
        eligibility: 'Research proposal, faculty recommendation',
        matchPercentage: 70,
      ),
      ScholarshipModel(
        id: '6',
        title: 'Women in STEM Scholarship',
        category: 'Merit',
        description:
            'Encouraging women to pursue careers in science, technology, engineering, and mathematics.',
        amount: '₹45,000',
        deadline: '2023-07-15',
        eligibility: 'Female students in STEM disciplines with CGPA 8.0+',
        matchPercentage: 88,
      ),
      ScholarshipModel(
        id: '7',
        title: 'Cultural Talent Scholarship',
        category: 'Cultural',
        description:
            'For students with exceptional achievements in cultural activities.',
        amount: '₹20,000',
        deadline: '2023-06-25',
        eligibility:
            'Proven record of cultural achievements at state/national level',
        matchPercentage: 72,
      ),
      ScholarshipModel(
        id: '8',
        title: 'First Generation Learner Grant',
        category: 'Need-based',
        description:
            'Support for students who are first in their family to attend college.',
        amount: '₹35,000',
        deadline: '2023-08-05',
        eligibility: 'First-generation college student, family income criteria',
        matchPercentage: 90,
      ),
      ScholarshipModel(
        id: '9',
        title: 'International Exchange Program',
        category: 'International',
        description:
            'Funding for students participating in semester exchange programs abroad.',
        amount: '₹1,00,000',
        deadline: '2023-07-20',
        eligibility:
            'CGPA 8.0+, language proficiency, letter of recommendation',
        matchPercentage: 65,
      ),
      ScholarshipModel(
        id: '10',
        title: 'Innovation and Entrepreneurship Grant',
        category: 'Research',
        description:
            'For students with innovative startup ideas and entrepreneurial potential.',
        amount: '₹75,000',
        deadline: '2023-08-15',
        eligibility: 'Business plan, prototype or proof of concept',
        matchPercentage: 78,
      ),
      ScholarshipModel(
        id: '11',
        title: 'Community Service Scholarship',
        category: 'Need-based',
        description:
            'Recognizing students who contribute significantly to community service.',
        amount: '₹25,000',
        deadline: '2023-06-10',
        eligibility: 'Documented community service hours (100+ hours)',
        matchPercentage: 82,
      ),
      ScholarshipModel(
        id: '12',
        title: 'Disabled Students Support Grant',
        category: 'Need-based',
        description: 'Financial assistance for students with disabilities.',
        amount: '₹40,000',
        deadline: '2023-07-05',
        eligibility: 'Students with documented disabilities',
        matchPercentage: 95,
      ),
      ScholarshipModel(
        id: '13',
        title: 'Rural Student Scholarship',
        category: 'Need-based',
        description: 'Support for students from rural and underserved areas.',
        amount: '₹30,000',
        deadline: '2023-06-20',
        eligibility: 'Proof of residence in rural areas, income criteria',
        matchPercentage: 88,
      ),
      ScholarshipModel(
        id: '14',
        title: 'Computer Science Excellence Award',
        category: 'Merit',
        description:
            'For outstanding students in computer science and IT fields.',
        amount: '₹50,000',
        deadline: '2023-07-25',
        eligibility:
            'CS/IT students with CGPA 9.0+, coding competition achievements',
        matchPercentage: 76,
      ),
      ScholarshipModel(
        id: '15',
        title: 'Environmental Studies Grant',
        category: 'Research',
        description:
            'Supporting research in environmental conservation and sustainability.',
        amount: '₹35,000',
        deadline: '2023-08-10',
        eligibility:
            'Research proposal in environmental studies, faculty endorsement',
        matchPercentage: 80,
      ),
    ];
  }
}
