import 'package:flutter/material.dart';

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
  final _verificationController = TextEditingController();
  String _selectedCategory = 'Electronics';
  DateTime _date = DateTime.now();

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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  void _submitItem() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send the form data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.type == 'lost'
                ? 'Lost item reported successfully!'
                : 'Found item reported successfully!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
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

    return Scaffold(
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

              // Image upload (UI only for demo)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Image (Optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: InkWell(
                        onTap: () {
                          // In a real app, this would open image picker
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Verification question (only for lost items)
              if (isLostItem) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _verificationController,
                  decoration: const InputDecoration(
                    labelText: 'Verification Question*',
                    hintText:
                        'Question only the owner would know (e.g. What stickers are on it?)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (isLostItem && (value == null || value.trim().isEmpty)) {
                      return 'Please provide a verification question';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitItem,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isLostItem ? 'Report Lost Item' : 'Report Found Item',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
