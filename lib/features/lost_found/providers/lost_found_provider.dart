import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LostFoundItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final String location;
  final DateTime date;
  final String status; // 'lost' or 'found'
  final String? imageUrl;
  final File? imageFile; // For new uploads
  final Map<String, dynamic> reporter;
  final String? verificationQuestion;
  final String? verificationAnswer;

  LostFoundItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    this.imageUrl,
    this.imageFile,
    required this.reporter,
    this.verificationQuestion,
    this.verificationAnswer,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
      // imageFile cannot be serialized, so we skip it
      'reporter': reporter,
      'verificationQuestion': verificationQuestion,
      'verificationAnswer': verificationAnswer,
    };
  }

  // Create from JSON for retrieval
  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      imageUrl: json['imageUrl'],
      reporter: json['reporter'],
      verificationQuestion: json['verificationQuestion'],
      verificationAnswer: json['verificationAnswer'],
    );
  }
}

class LostFoundProvider with ChangeNotifier {
  List<LostFoundItem> _items = [
    LostFoundItem(
      id: '1',
      title: 'MacBook Pro 13"',
      category: 'Electronics',
      description: 'Space Gray MacBook Pro, has stickers on the back cover.',
      location: 'Central Library, 2nd Floor',
      date: DateTime.parse('2023-04-04'),
      status: 'lost',
      reporter: {'name': 'Alex Johnson', 'id': 'user123'},
      verificationQuestion: 'What sticker is on the lid?',
      verificationAnswer: 'Programmer sticker',
    ),
    LostFoundItem(
      id: '2',
      title: 'Student ID Card',
      category: 'ID Cards',
      description: 'ID card for Engineering Department',
      location: 'Engineering Block A',
      date: DateTime.parse('2023-04-03'),
      status: 'found',
      reporter: {'name': 'Sarah Williams', 'id': 'user456'},
    ),
    LostFoundItem(
      id: '3',
      title: 'Black Wallet',
      category: 'Wallets',
      description: 'Leather wallet with student ID and some cash',
      location: 'Canteen',
      date: DateTime.parse('2023-04-02'),
      status: 'lost',
      reporter: {'name': 'Mike Chen', 'id': 'user789'},
      verificationQuestion: 'What is the brand of the wallet?',
      verificationAnswer: 'Fossil',
    ),
    LostFoundItem(
      id: '4',
      title: 'Calculator (Casio FX-991ES)',
      category: 'Others',
      description: 'Scientific calculator with name written on back',
      location: 'Math Department',
      date: DateTime.parse('2023-04-01'),
      status: 'found',
      reporter: {'name': 'Emily Rodriguez', 'id': 'user101'},
    ),
  ];

  bool _initialized = false;

  LostFoundProvider() {
    _loadItems();
  }

  // Load items from SharedPreferences
  Future<void> _loadItems() async {
    try {
      print('LOADING ITEMS from SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getString('lost_found_items');

      if (itemsJson != null) {
        // If we have stored items, use them
        final List<dynamic> decoded = jsonDecode(itemsJson);
        _items = decoded.map((item) => LostFoundItem.fromJson(item)).toList();
        print('Loaded ${_items.length} items from SharedPreferences');
      } else {
        // First run, save the default items
        print('No stored items found, using defaults');
        _saveItems();
      }

      _initialized = true;
      notifyListeners();
    } catch (e) {
      print('ERROR loading items from SharedPreferences: $e');
      // Continue with default items if there's an error
    }
  }

  // Save items to SharedPreferences
  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = jsonEncode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('lost_found_items', itemsJson);
      print('Saved ${_items.length} items to SharedPreferences');
    } catch (e) {
      print('ERROR saving items to SharedPreferences: $e');
    }
  }

  List<LostFoundItem> get items => [..._items];

  List<LostFoundItem> get lostItems =>
      _items.where((item) => item.status == 'lost').toList();

  List<LostFoundItem> get foundItems =>
      _items.where((item) => item.status == 'found').toList();

  List<LostFoundItem> getFilteredItems({
    required bool showLost,
    required bool showFound,
    required String category,
  }) {
    return _items.where((item) {
      final matchesStatus =
          (showLost && item.status == 'lost') ||
          (showFound && item.status == 'found');

      final matchesCategory = category == 'All' || item.category == category;

      return matchesStatus && matchesCategory;
    }).toList();
  }

  Future<void> addItem(LostFoundItem item) async {
    print('ADDING ITEM TO PROVIDER: ${item.title}, Status: ${item.status}');
    print(
      'BEFORE - Total items: ${_items.length}, Lost: ${lostItems.length}, Found: ${foundItems.length}',
    );

    // In a real app, this would make an API call to save the item
    // For now, just add it to our local list
    _items = [..._items, item]; // Create a new list to ensure state update

    // Save to persistent storage
    await _saveItems();

    print(
      'AFTER - Total items: ${_items.length}, Lost: ${lostItems.length}, Found: ${foundItems.length}',
    );
    print('All items: ${_items.map((e) => e.title).join(', ')}');

    // Make sure to notify listeners to rebuild the UI
    notifyListeners();
  }

  Future<bool> verifyAndClaimItem(String itemId, String answer) async {
    final item = _items.firstWhere((item) => item.id == itemId);

    // If there's no verification question (for found items), allow claim
    if (item.verificationAnswer == null) {
      return true;
    }

    // Check if answer matches
    bool isCorrect =
        item.verificationAnswer?.toLowerCase() == answer.toLowerCase();

    if (isCorrect) {
      // In a real app, this would update the item status in the backend
      // For now, just log the claim
      print('Item $itemId claimed successfully');
    }

    return isCorrect;
  }

  // Remove an item from the list when it's found or owner is found
  Future<void> removeItem(String itemId, String reason) async {
    print('REMOVING ITEM: $itemId, Reason: $reason');
    print(
      'BEFORE REMOVAL - Total items: ${_items.length}, Lost: ${lostItems.length}, Found: ${foundItems.length}',
    );

    _items = _items.where((item) => item.id != itemId).toList();

    // Save to persistent storage
    await _saveItems();

    print(
      'AFTER REMOVAL - Total items: ${_items.length}, Lost: ${lostItems.length}, Found: ${foundItems.length}',
    );

    // Notify listeners to rebuild the UI
    notifyListeners();
  }
}
