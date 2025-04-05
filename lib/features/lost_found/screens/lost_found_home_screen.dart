import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lost_found_provider.dart';
import '../widgets/item_card_widget.dart';
import 'item_submit_screen.dart';
import 'item_detail_screen.dart';

class LostFoundHomeScreen extends StatefulWidget {
  const LostFoundHomeScreen({super.key});

  @override
  State<LostFoundHomeScreen> createState() => _LostFoundHomeScreenState();
}

class _LostFoundHomeScreenState extends State<LostFoundHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  bool _isSearching = false;
  Key _refreshKey = UniqueKey(); // Add a key for forcing rebuilds

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Print items on init for debugging
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LostFoundProvider>(context, listen: false);
      print('HOME SCREEN INIT - Lost items: ${provider.lostItems.length}');
      print('HOME SCREEN INIT - Found items: ${provider.foundItems.length}');

      // Force refresh to ensure we have the latest data
      _forceRefresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _forceRefresh() {
    setState(() {
      _refreshKey = UniqueKey(); // Generate a new key to force rebuild
    });
  }

  List<LostFoundItem> _getFilteredItems(
    BuildContext context,
    bool showLostItems,
  ) {
    final provider = Provider.of<LostFoundProvider>(context);
    final searchQuery = _searchController.text.toLowerCase();

    // Get the appropriate items based on the tab and print for debugging
    final items = showLostItems ? provider.lostItems : provider.foundItems;

    if (showLostItems) {
      print('DISPLAYING LOST ITEMS: ${items.length}');
      for (var item in items) {
        print(' - ${item.title} (${item.category})');
      }
    }

    // Apply category filter
    final categoryFiltered =
        _selectedCategory == 'All'
            ? items
            : items
                .where((item) => item.category == _selectedCategory)
                .toList();

    // Apply search filter if searching
    if (_isSearching && searchQuery.isNotEmpty) {
      return categoryFiltered.where((item) {
        return item.title.toLowerCase().contains(searchQuery) ||
            item.description.toLowerCase().contains(searchQuery) ||
            item.location.toLowerCase().contains(searchQuery);
      }).toList();
    }

    return categoryFiltered;
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild when the provider changes
    return Consumer<LostFoundProvider>(
      builder: (context, provider, _) {
        print('REBUILD HOME - Lost items: ${provider.lostItems.length}');
        print('REBUILD HOME - Found items: ${provider.foundItems.length}');

        return Scaffold(
          key: _refreshKey, // Add key to force rebuilds
          appBar: AppBar(
            title:
                _isSearching
                    ? TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for items...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) => setState(() {}),
                    )
                    : const Text('Lost & Found'),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: _toggleSearch,
                tooltip: _isSearching ? 'Clear search' : 'Search',
              ),
              // Add refresh button for debugging
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _forceRefresh,
                tooltip: 'Force Refresh',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Lost Items'), Tab(text: 'Found Items')],
              onTap: (_) => setState(() {}),
            ),
          ),
          body: Column(
            children: [
              // Category filter dropdown
              Padding(
                padding: const EdgeInsets.all(16.0),
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

              // Items list
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Lost Items Tab
                    _buildItemsList(isLostItems: true),
                    // Found Items Tab
                    _buildItemsList(isLostItems: false),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final type = _tabController.index == 0 ? 'lost' : 'found';
              print('Opening ItemSubmitScreen for $type item');

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemSubmitScreen(type: type),
                ),
              ).then((_) {
                // Force a rebuild after returning
                _forceRefresh();

                // Debug print items after returning
                final currentProvider = Provider.of<LostFoundProvider>(
                  context,
                  listen: false,
                );
                print(
                  'AFTER SUBMIT - Lost items: ${currentProvider.lostItems.length}',
                );
                print(
                  'AFTER SUBMIT - Found items: ${currentProvider.foundItems.length}',
                );
              });
            },
            icon: Icon(
              _tabController.index == 0 ? Icons.report_problem : Icons.search,
            ),
            label: Text(
              _tabController.index == 0
                  ? 'Report Lost Item'
                  : 'Report Found Item',
            ),
            backgroundColor:
                _tabController.index == 0 ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }

  Widget _buildItemsList({required bool isLostItems}) {
    return Consumer<LostFoundProvider>(
      builder: (context, provider, _) {
        final items = _getFilteredItems(context, isLostItems);

        print(
          'BUILDING ${isLostItems ? "LOST" : "FOUND"} ITEMS LIST with ${items.length} items',
        );
        for (var item in items) {
          print(' - ${item.id}: ${item.title}');
        }

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLostItems ? Icons.search_off : Icons.emoji_objects_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  isLostItems
                      ? 'No lost items in this category'
                      : 'No found items in this category',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ItemSubmitScreen(
                              type: isLostItems ? 'lost' : 'found',
                            ),
                      ),
                    ).then((_) {
                      // Force refresh after returning from submission
                      _forceRefresh();

                      // Print updated items count
                      print('After submission - refreshing list');
                      print(
                        'Updated ${isLostItems ? "lost" : "found"} items: ${isLostItems ? provider.lostItems.length : provider.foundItems.length}',
                      );
                    });
                  },
                  child: Text(
                    isLostItems ? 'Report a Lost Item' : 'Report a Found Item',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ItemCardWidget(
              item: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(itemId: item.id),
                  ),
                ).then(
                  (_) => _forceRefresh(),
                ); // Refresh when returning from details
              },
            );
          },
        );
      },
    );
  }
}
