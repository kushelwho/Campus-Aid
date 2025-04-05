import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lost_found_provider.dart';
import 'dart:math'; // For generating random IDs

class ItemSubmitScreen extends StatefulWidget {
  final String type; // 'lost' or 'found'

  const ItemSubmitScreen({super.key, required this.type});

  @override
  State<ItemSubmitScreen> createState() => _ItemSubmitScreenState();
}

class _ItemSubmitScreenState extends State<ItemSubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _verificationQuestionController = TextEditingController();
  final _verificationAnswerController = TextEditingController();
  String _selectedCategory = 'Electronics';
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final List<String> _categories = [
    'Electronics',
    'Books & Notes',
    'ID Cards',
    'Wallets',
    'Keys',
    'Clothing',
    'Others',
  ];

  @override
  void initState() {
    super.initState();

    // For debugging, print available items when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final provider = Provider.of<LostFoundProvider>(context, listen: false);
        print('==== SUBMIT SCREEN INIT ====');
        print('Lost items: ${provider.lostItems.length}');
        print('Found items: ${provider.foundItems.length}');
        print('=============================');
      } catch (e) {
        print('ERROR in submit screen init: $e');
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _verificationQuestionController.dispose();
    _verificationAnswerController.dispose();
    super.dispose();
  }

  void _submitItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Debug print before attempting to get provider
        print('==== STARTING ITEM SUBMISSION ====');
        print('Item type: ${widget.type}');

        // Get the provider using context directly from the widget tree
        final provider = Provider.of<LostFoundProvider>(context, listen: false);
        print('Got provider reference successfully');

        // Print existing items before adding
        print('Existing items: ${provider.items.length}');
        print('Existing lost items: ${provider.lostItems.length}');
        print('Existing found items: ${provider.foundItems.length}');

        // Generate a random ID (in a real app, this would come from the backend)
        final id =
            '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
        print('Generated new item ID: $id');

        // Create a new item
        final newItem = LostFoundItem(
          id: id,
          title: _titleController.text,
          category: _selectedCategory,
          description: _descriptionController.text,
          location: _locationController.text,
          date: _date,
          status: widget.type, // 'lost' or 'found'
          reporter: {
            'name': 'Current User', // In a real app, use actual user name
            'id': 'user123', // In a real app, use actual user ID
          },
          // Only include verification for lost items
          verificationQuestion:
              widget.type == 'lost'
                  ? _verificationQuestionController.text
                  : null,
          verificationAnswer:
              widget.type == 'lost' ? _verificationAnswerController.text : null,
        );

        // Debug print item properties
        print('Created new ${widget.type} item:');
        print(' - ID: ${newItem.id}');
        print(' - Title: ${newItem.title}');
        print(' - Category: ${newItem.category}');
        print(' - Description: ${newItem.description}');
        print(' - Location: ${newItem.location}');
        print(' - Status: ${newItem.status}');

        // Add the item to the provider
        print('Adding item to provider...');
        await provider.addItem(newItem);
        print('Item successfully added to provider');

        // Print item counts after adding
        print('After adding - Total items: ${provider.items.length}');
        print('After adding - Lost items: ${provider.lostItems.length}');
        print('After adding - Found items: ${provider.foundItems.length}');
        print('================================');

        if (mounted) {
          // Show a success message before navigating away
          final successMessage =
              widget.type == 'lost'
                  ? 'Lost item reported successfully!'
                  : 'Found item reported successfully!';

          // First set the state to not loading
          setState(() {
            _isLoading = false;
          });

          // Then show a simple in-app message instead of a SnackBar
          _showSuccessAndNavigateBack(successMessage);
        }
      } catch (e) {
        print('ERROR during item submission: $e');
        print(e.toString());

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show error without using SnackBar
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Error: ${e.toString()}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    }
  }

  // Show success and navigate back after a short delay
  void _showSuccessAndNavigateBack(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
    );

    // Delay navigation to allow the dialog to be seen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(
          context,
        ).pop(true); // Go back to previous screen with result
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLostItem = widget.type == 'lost';

    // Check if provider is accessible
    try {
      final provider = Provider.of<LostFoundProvider>(context, listen: false);
      print('Provider accessible in build method');
    } catch (e) {
      print('ERROR: Provider not accessible in build method: $e');
    }

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLostItem ? 'Report Lost Item' : 'Report Found Item'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLostItem
                      ? 'Please provide details about your lost item'
                      : 'Please provide details about the item you found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Item Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Item Title*',
                    hintText: 'e.g. Blue Backpack, Student ID Card',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide an item title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category*',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description*',
                    hintText:
                        isLostItem
                            ? 'Describe your item in detail (color, brand, distinguishing features)'
                            : 'Describe the item you found in detail',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a description';
                    }
                    if (value.trim().length < 10) {
                      return 'Description should be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText:
                          isLostItem
                              ? 'When did you lose it?*'
                              : 'When did you find it?*',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText:
                        isLostItem ? 'Last seen location*' : 'Found location*',
                    hintText: 'e.g. Library 2nd floor, Cafeteria',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () {
                        // In a real app, this would get the current location
                        _locationController.text = 'Current Location';
                      },
                      tooltip: 'Use current location',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Image Upload (placeholder)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Image upload functionality would be implemented here
                          _scaffoldKey.currentState?.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Image upload not implemented in demo',
                              ),
                              // Don't use floating behavior to avoid the error
                            ),
                          );
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Image'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Verification fields - only for lost items
                if (isLostItem) ...[
                  const Divider(),
                  const SizedBox(height: 16),

                  Text(
                    'Verification Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Text(
                    'This will help verify the person who found your item',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Verification Question
                  TextFormField(
                    controller: _verificationQuestionController,
                    decoration: const InputDecoration(
                      labelText: 'Verification Question*',
                      hintText: 'e.g. What is the brand of the laptop?',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (isLostItem &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please provide a verification question';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Verification Answer
                  TextFormField(
                    controller: _verificationAnswerController,
                    decoration: const InputDecoration(
                      labelText: 'Verification Answer*',
                      hintText: 'e.g. Apple',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (isLostItem &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please provide an answer to your verification question';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLostItem ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              isLostItem
                                  ? 'Report Lost Item'
                                  : 'Report Found Item',
                              style: const TextStyle(fontSize: 16),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
