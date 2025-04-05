import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/lost_found_provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _verificationAnswerController = TextEditingController();
  bool _showVerificationForm = false;
  bool _verificationFailed = false;
  bool _isLoading = false;
  bool _verificationSuccess = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _verificationAnswerController.dispose();
    super.dispose();
  }

  Future<void> _submitVerification(
    BuildContext context,
    LostFoundItem item,
  ) async {
    if (_verificationAnswerController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _verificationFailed = false;
    });

    try {
      final provider = Provider.of<LostFoundProvider>(context, listen: false);
      final success = await provider.verifyAndClaimItem(
        item.id,
        _verificationAnswerController.text.trim(),
      );

      if (success) {
        if (mounted) {
          setState(() {
            _verificationSuccess = true;
            _showVerificationForm = false;
          });

          // Show a toast-like message instead of a SnackBar
          _showMessage(
            'Verification successful! You can now contact the reporter.',
            Colors.green,
          );
        }
      } else {
        setState(() {
          _verificationFailed = true;
        });
      }
    } catch (error) {
      // Handle any errors
      if (mounted) {
        _showMessage('An error occurred: $error', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show a message in a toast-like dialog instead of using SnackBar
  void _showMessage(String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder:
          (context) => AlertDialog(
            backgroundColor: color,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            content: Text(message, style: const TextStyle(color: Colors.white)),
          ),
    );

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LostFoundProvider>(context);
    final item = provider.items.firstWhere((i) => i.id == widget.itemId);
    final dateFormatter = DateFormat('MMMM d, yyyy');
    final bool isLostItem = item.status == 'lost';
    final Color statusColor = isLostItem ? Colors.red : Colors.green;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLostItem ? 'Lost Item' : 'Found Item'),
          backgroundColor: statusColor.withOpacity(0.8),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isLostItem ? 'LOST' : 'FOUND',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Item Image (if available)
              if (item.imageUrl != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),

              // Item Details
              _buildDetailSection(
                context: context,
                title: 'Details',
                children: [
                  _buildDetailRow(context, 'Category', item.category),
                  _buildDetailRow(context, 'Description', item.description),
                  _buildDetailRow(context, 'Location', item.location),
                  _buildDetailRow(
                    context,
                    'Date',
                    dateFormatter.format(item.date),
                  ),
                  _buildDetailRow(
                    context,
                    'Reported by',
                    item.reporter['name'] as String,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Information (Only shown after successful verification)
              if (_verificationSuccess)
                _buildDetailSection(
                  context: context,
                  title: 'Contact Information',
                  children: [
                    _buildDetailRow(
                      context,
                      'Name',
                      item.reporter['name'] as String,
                    ),
                    _buildDetailRow(
                      context,
                      'Email',
                      'contact@example.com', // In a real app, use actual email
                    ),
                    _buildDetailRow(
                      context,
                      'Phone',
                      '+1 (555) 123-4567', // In a real app, use actual phone
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // Email action would go here
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Call action would go here
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              // Action buttons
              if (!_verificationSuccess) ...[
                if (isLostItem) ...[
                  // For lost items: "I Found It" button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showVerificationForm = true;
                      });
                    },
                    icon: const Icon(Icons.emoji_objects),
                    label: const Text('I Found This Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ] else ...[
                  // For found items: "Claim Item" button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showVerificationForm = true;
                      });
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Claim This Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ],

              // Verification form (shown when user wants to claim)
              if (_showVerificationForm) ...[
                const SizedBox(height: 32),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLostItem
                              ? 'Verification Required'
                              : 'Please verify you are the owner',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isLostItem
                              ? item.verificationQuestion ??
                                  'Please answer the verification question:'
                              : 'Please describe something unique about this item that only the owner would know:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _verificationAnswerController,
                          decoration: InputDecoration(
                            labelText: 'Your answer',
                            border: const OutlineInputBorder(),
                            errorText:
                                _verificationFailed
                                    ? 'Incorrect answer. Please try again.'
                                    : null,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted:
                              (_) => _submitVerification(context, item),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () => _submitVerification(context, item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: statusColor,
                              foregroundColor: Colors.white,
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
