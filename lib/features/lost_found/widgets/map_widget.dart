import 'package:flutter/material.dart';
import '../providers/lost_found_provider.dart';

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}

class MapMarker {
  final LostFoundItem item;
  final Point position;

  const MapMarker({required this.item, required this.position});
}

class CampusMapWidget extends StatelessWidget {
  final List<MapMarker> markers;
  final Function(LostFoundItem) onMarkerTap;

  const CampusMapWidget({
    super.key,
    required this.markers,
    required this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 4.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // This would be replaced by an actual map image in a real app
          Image.asset(
            'assets/images/campus_map_placeholder.png',
            fit: BoxFit.cover,
          ),

          // Fallback if the image doesn't exist
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Center(
              child: Text(
                'Campus Map',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Position markers on map
          ...markers.map((marker) {
            final bool isLostItem = marker.item.status == 'lost';
            final Color markerColor = isLostItem ? Colors.red : Colors.green;

            return Positioned(
              left: MediaQuery.of(context).size.width * marker.position.x,
              top: MediaQuery.of(context).size.height * marker.position.y,
              child: GestureDetector(
                onTap: () => onMarkerTap(marker.item),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        marker.item.title,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: markerColor,
                        ),
                      ),
                    ),
                    Icon(
                      isLostItem ? Icons.search : Icons.pin_drop,
                      color: markerColor,
                      size: 32.0,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class MarkerInfoDialog extends StatelessWidget {
  final LostFoundItem item;

  const MarkerInfoDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isLostItem = item.status == 'lost';
    final Color statusColor = isLostItem ? Colors.red : Colors.green;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isLostItem ? Icons.search : Icons.emoji_objects,
            color: statusColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              style: TextStyle(color: statusColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.category, item.category),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.description, item.description),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, item.location),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            '${item.date.day}/${item.date.month}/${item.date.year}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate to item details/claim screen
            // This would be implemented in a real app
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: statusColor,
            foregroundColor: Colors.white,
          ),
          child: Text(isLostItem ? 'I Found It' : 'Claim Item'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
