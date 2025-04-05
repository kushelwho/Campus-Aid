import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/lost_found_provider.dart';

class LostFoundService {
  final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://api.campusaid.example.com';
  final String _endpoint = '/lost-found';

  // Get all lost and found items
  Future<List<LostFoundItem>> getAllItems() async {
    try {
      // In a real app, this would make an API call
      // For now, we'll simulate a successful response
      await Future.delayed(const Duration(seconds: 1));

      // Return an empty list since we're using mock data in the provider
      return [];

      // Real implementation would look like:
      // final response = await http.get(Uri.parse('$_baseUrl$_endpoint/items'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((item) => LostFoundItem.fromJson(item)).toList();
      // } else {
      //   throw Exception('Failed to load items');
      // }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  // Submit a new lost item report
  Future<void> reportLostItem({
    required String title,
    required String category,
    required String description,
    required String location,
    required DateTime date,
    File? image,
    required String userId,
    required String userName,
    required String? verificationQuestion,
    required String? verificationAnswer,
  }) async {
    try {
      // In a real app, this would upload the image and submit the form data
      await Future.delayed(const Duration(seconds: 2));

      // For demonstration purposes - successfully completes without making real API call

      // Real implementation would look like:
      // final request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse('$_baseUrl$_endpoint/lost'),
      // );
      //
      // request.fields['title'] = title;
      // request.fields['category'] = category;
      // request.fields['description'] = description;
      // request.fields['location'] = location;
      // request.fields['date'] = date.toIso8601String();
      // request.fields['userId'] = userId;
      // request.fields['userName'] = userName;
      //
      // if (verificationQuestion != null) {
      //   request.fields['verificationQuestion'] = verificationQuestion;
      // }
      //
      // if (verificationAnswer != null) {
      //   request.fields['verificationAnswer'] = verificationAnswer;
      // }
      //
      // if (image != null) {
      //   final file = await http.MultipartFile.fromPath('image', image.path);
      //   request.files.add(file);
      // }
      //
      // final response = await request.send();
      // if (response.statusCode != 201) {
      //   throw Exception('Failed to report lost item');
      // }
    } catch (e) {
      throw Exception('Failed to report lost item: $e');
    }
  }

  // Submit a new found item report
  Future<void> reportFoundItem({
    required String title,
    required String category,
    required String description,
    required String location,
    required DateTime date,
    File? image,
    required String userId,
    required String userName,
  }) async {
    try {
      // Similar to reportLostItem but without verification fields
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('Failed to report found item: $e');
    }
  }

  // Verify and claim an item
  Future<bool> verifyAndClaimItem({
    required String itemId,
    required String answer,
  }) async {
    try {
      // In a real app, this would send the verification answer to the API
      await Future.delayed(const Duration(seconds: 1));

      // Simulate a successful verification for demo purposes
      return true;

      // Real implementation would look like:
      // final response = await http.post(
      //   Uri.parse('$_baseUrl$_endpoint/verify/$itemId'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'answer': answer}),
      // );
      //
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return data['success'] as bool;
      // } else {
      //   return false;
      // }
    } catch (e) {
      throw Exception('Failed to verify item: $e');
    }
  }

  // Get lost and found items near a location
  Future<List<LostFoundItem>> getNearbyItems({
    required double latitude,
    required double longitude,
    double radiusInKm = 1.0,
  }) async {
    try {
      // In a real app, this would fetch items near the given coordinates
      await Future.delayed(const Duration(seconds: 1));

      // Return an empty list for demo purposes
      return [];

      // Real implementation would look like:
      // final response = await http.get(
      //   Uri.parse(
      //     '$_baseUrl$_endpoint/nearby?lat=$latitude&lng=$longitude&radius=$radiusInKm',
      //   ),
      // );
      //
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((item) => LostFoundItem.fromJson(item)).toList();
      // } else {
      //   throw Exception('Failed to load nearby items');
      // }
    } catch (e) {
      throw Exception('Failed to load nearby items: $e');
    }
  }
}
