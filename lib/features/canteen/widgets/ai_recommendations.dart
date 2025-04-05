import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_aid/features/canteen/providers/canteen_provider.dart';

class AIRecommendationsWidget extends StatefulWidget {
  const AIRecommendationsWidget({Key? key}) : super(key: key);

  @override
  State<AIRecommendationsWidget> createState() => _AIRecommendationsWidgetState();
}

class _AIRecommendationsWidgetState extends State<AIRecommendationsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CanteenProvider>(context);
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recommendation header
          ListTile(
            dense: true,
            title: Text(
              'AI-Powered Recommendations',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Based on your preferences',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
              ),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                
                if (_isExpanded && provider.aiRecommendations.isEmpty) {
                  provider.loadAIRecommendations();
                }
              },
            ),
          ),
          
          // Expanded content
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.0),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Generating recommendations...',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  if (provider.error.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Failed to generate recommendations',
                              style: theme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => provider.loadAIRecommendations(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Try Again', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  if (provider.aiRecommendations.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: [
                            Text(
                              'No recommendations available yet',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => provider.loadAIRecommendations(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Generate', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...provider.aiRecommendations.map((recommendation) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  recommendation,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 4),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => provider.loadAIRecommendations(),
                              icon: const Icon(Icons.refresh, size: 16),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              label: const Text('Refresh', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 