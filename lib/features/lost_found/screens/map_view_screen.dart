import 'package:flutter/material.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  bool _showLostItems = true;
  bool _showFoundItems = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Books & Notes',
    'ID Cards',
    'Wallets',
    'Keys',
    'Clothing',
    'Others',
  ];

  // Mock data for map markers
  final List<Map<String, dynamic>> _markers = [
    {
      'id': '1',
      'title': 'MacBook Pro 13"',
      'category': 'Electronics',
      'location': 'Central Library, 2nd Floor',
      'status': 'lost',
      'position': const Point(0.3, 0.2), // x, y coordinates on the map (0 to 1)
    },
    {
      'id': '2',
      'title': 'Student ID Card',
      'category': 'ID Cards',
      'location': 'Engineering Block A',
      'status': 'found',
      'position': const Point(0.6, 0.4),
    },
    {
      'id': '3',
      'title': 'Black Wallet',
      'category': 'Wallets',
      'location': 'Canteen',
      'status': 'lost',
      'position': const Point(0.5, 0.7),
    },
    {
      'id': '4',
      'title': 'Calculator (Casio FX-991ES)',
      'category': 'Others',
      'location': 'Math Department',
      'status': 'found',
      'position': const Point(0.2, 0.6),
    },
  ];

  List<Map<String, dynamic>> get _filteredMarkers {
    return _markers.where((marker) {
      final matchesLostFilter =
          marker['status'] == 'lost' ? _showLostItems : true;
      final matchesFoundFilter =
          marker['status'] == 'found' ? _showFoundItems : true;
      final matchesCategory =
          _selectedCategory == 'All' || marker['category'] == _selectedCategory;

      return matchesLostFilter && matchesFoundFilter && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map')),
      body: Column(
        children: [
          // Filter controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Lost Items'),
                      selected: _showLostItems,
                      onSelected: (selected) {
                        setState(() {
                          _showLostItems = selected;
                        });
                      },
                      avatar: Icon(
                        Icons.search,
                        color: _showLostItems ? Colors.white : Colors.red,
                        size: 18,
                      ),
                      selectedColor: Colors.red,
                      checkmarkColor: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Found Items'),
                      selected: _showFoundItems,
                      onSelected: (selected) {
                        setState(() {
                          _showFoundItems = selected;
                        });
                      },
                      avatar: Icon(
                        Icons.emoji_objects,
                        color: _showFoundItems ? Colors.white : Colors.green,
                        size: 18,
                      ),
                      selectedColor: Colors.green,
                      checkmarkColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Campus map with markers
          Expanded(
            child: Stack(
              children: [
                // Placeholder for the actual map
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: Stack(
                      children: [
                        // Campus map image placeholder
                        Center(
                          child: Text(
                            'Campus Map',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Map markers
                        ..._filteredMarkers.map((marker) {
                          final position = marker['position'] as Point;
                          return Positioned(
                            left:
                                MediaQuery.of(context).size.width * position.x,
                            top:
                                (MediaQuery.of(context).size.height - 200) *
                                position.y,
                            child: _buildMarker(context, marker),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // In a real app, this would center the map on user's location
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Centered on your location'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMarker(BuildContext context, Map<String, dynamic> marker) {
    final isLost = marker['status'] == 'lost';

    return GestureDetector(
      onTap: () {
        _showMarkerDetails(context, marker);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLost ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLost ? Icons.search : Icons.emoji_objects,
              color: Colors.white,
              size: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              marker['title'] as String,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkerDetails(BuildContext context, Map<String, dynamic> marker) {
    final isLost = marker['status'] == 'lost';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isLost ? Colors.red[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isLost ? Icons.search : Icons.emoji_objects,
                      color: isLost ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker['title'] as String,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Category: ${marker['category']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isLost ? Colors.red[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isLost ? 'Lost' : 'Found',
                      style: TextStyle(
                        color: isLost ? Colors.red[800] : Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    marker['location'] as String,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to item details
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Simple Point class for positioning markers
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}
