import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/lost_found_provider.dart';

class ItemCardWidget extends StatelessWidget {
  final LostFoundItem item;
  final VoidCallback onTap;

  const ItemCardWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLostItem = item.status == 'lost';
    final Color statusColor = isLostItem ? Colors.red : Colors.green;
    final DateFormat dateFormatter = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              color: statusColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  isLostItem ? 'LOST' : 'FOUND',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          item.category,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Location and Date
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatter.format(item.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // "Found" or "Owner Found" button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmItemResolution(context),
                      icon: Icon(
                        isLostItem ? Icons.check_circle : Icons.person_search,
                        color: isLostItem ? Colors.green : Colors.blue,
                      ),
                      label: Text(isLostItem ? 'Found' : 'Owner Found'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLostItem ? Colors.green[50] : Colors.blue[50],
                        foregroundColor:
                            isLostItem ? Colors.green[800] : Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmItemResolution(BuildContext context) {
    final bool isLostItem = item.status == 'lost';
    final String title =
        isLostItem ? 'Mark Item as Found?' : 'Mark as Owner Found?';
    final String content =
        isLostItem
            ? 'Has this item been found? It will be removed from the lost items list.'
            : 'Has the owner claimed this item? It will be removed from the found items list.';
    final String buttonText = isLostItem ? 'Mark as Found' : 'Mark as Claimed';
    final String reason = isLostItem ? 'Item was found' : 'Owner claimed item';

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  // Get the provider and remove the item
                  final provider = Provider.of<LostFoundProvider>(
                    context,
                    listen: false,
                  );
                  provider.removeItem(item.id, reason).then((_) {
                    // Close the dialog
                    Navigator.of(ctx).pop();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isLostItem
                              ? 'Item marked as found and removed from the list'
                              : 'Item marked as claimed and removed from the list',
                        ),
                        backgroundColor:
                            isLostItem ? Colors.green : Colors.blue,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  });
                },
                child: Text(buttonText),
              ),
            ],
          ),
    );
  }
}
