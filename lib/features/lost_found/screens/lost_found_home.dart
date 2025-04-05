import 'package:flutter/material.dart';
import 'item_submit_screen.dart';
import 'map_view_screen.dart';

class LostFoundHome extends StatefulWidget {
  const LostFoundHome({super.key});

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showLostItems = true;
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

  // Mock data for lost and found items
  final List<Map<String, dynamic>> _items = [
    {
      'id': '1',
      'title': 'MacBook Pro 13"',
      'category': 'Electronics',
      'description': 'Space Gray MacBook Pro, has stickers on the back cover.',
      'location': 'Central Library, 2nd Floor',
      'date': '2023-04-04',
      'status': 'lost',
      'image': null, // URL placeholder
      'reporter': {'name': 'Alex Johnson', 'id': 'user123'},
    },
    {
      'id': '2',
      'title': 'Student ID Card',
      'category': 'ID Cards',
      'description': 'ID card for Engineering Department',
      'location': 'Engineering Block A',
      'date': '2023-04-03',
      'status': 'found',
      'image': null, // URL placeholder
      'reporter': {'name': 'Sarah Williams', 'id': 'user456'},
    },
    {
      'id': '3',
      'title': 'Black Wallet',
      'category': 'Wallets',
      'description': 'Leather wallet with student ID and some cash',
      'location': 'Canteen',
      'date': '2023-04-02',
      'status': 'lost',
      'image': null, // URL placeholder
      'reporter': {'name': 'Mike Chen', 'id': 'user789'},
    },
    {
      'id': '4',
      'title': 'Calculator (Casio FX-991ES)',
      'category': 'Others',
      'description': 'Scientific calculator with name written on back',
      'location': 'Math Department',
      'date': '2023-04-01',
      'status': 'found',
      'image': null, // URL placeholder
      'reporter': {'name': 'Emily Rodriguez', 'id': 'user101'},
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _items.where((item) {
      final matchesStatus =
          _showLostItems ? item['status'] == 'lost' : item['status'] == 'found';

      final matchesCategory =
          _selectedCategory == 'All' || item['category'] == _selectedCategory;

      return matchesStatus && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _showLostItems = _tabController.index == 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Lost Items'), Tab(text: 'Found Items')],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapViewScreen()),
              );
            },
            tooltip: 'Map View',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Show search dialog/screen
                  },
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lost Items Tab
                _buildItemsList(),
                // Found Items Tab
                _buildItemsList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ItemSubmitScreen(type: _showLostItems ? 'lost' : 'found'),
            ),
          );
        },
        icon: Icon(_showLostItems ? Icons.report_problem : Icons.search),
        label: Text(_showLostItems ? 'Report Lost Item' : 'Report Found Item'),
      ),
    );
  }

  Widget _buildItemsList() {
    return _filteredItems.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _showLostItems ? Icons.search_off : Icons.find_in_page_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _showLostItems
                    ? 'No lost items found'
                    : 'No found items reported',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ItemSubmitScreen(
                            type: _showLostItems ? 'lost' : 'found',
                          ),
                    ),
                  );
                },
                icon: Icon(
                  _showLostItems ? Icons.report_problem : Icons.search,
                ),
                label: Text(
                  _showLostItems ? 'Report Lost Item' : 'Report Found Item',
                ),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item image or placeholder
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              item['image'] != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['image'] as String,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Icon(
                                    item['status'] == 'lost'
                                        ? Icons.search
                                        : Icons.emoji_objects,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          item['status'] == 'lost'
                                              ? Colors.red[100]
                                              : Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['status'] == 'lost'
                                          ? 'Lost'
                                          : 'Found',
                                      style: TextStyle(
                                        color:
                                            item['status'] == 'lost'
                                                ? Colors.red[800]
                                                : Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Category: ${item['category']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['description'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['location'] as String,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatDate(item['date'] as String),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // View details
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Details'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () {
                            // Contact the reporter
                          },
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Contact'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateTime now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
