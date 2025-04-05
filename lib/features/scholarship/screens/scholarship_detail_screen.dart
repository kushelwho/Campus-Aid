import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scholarship_provider.dart';
import '../../../core/models/scholarship_model.dart';

class ScholarshipDetailScreen extends StatefulWidget {
  final String scholarshipId;
  final bool isApplied;

  const ScholarshipDetailScreen({
    super.key,
    required this.scholarshipId,
    required this.isApplied,
  });

  @override
  State<ScholarshipDetailScreen> createState() =>
      _ScholarshipDetailScreenState();
}

class _ScholarshipDetailScreenState extends State<ScholarshipDetailScreen> {
  late ScholarshipModel? _scholarship;
  bool _isLoading = true;

  // Document upload flags for UI
  bool _hasCertificatesUploaded = false;
  bool _hasTranscriptUploaded = false;
  bool _hasIncomeProofUploaded = false;
  bool _hasRecommendationUploaded = false;

  // Additional details that are not part of the ScholarshipModel
  late Map<String, dynamic> _additionalDetails;

  @override
  void initState() {
    super.initState();
    _loadScholarshipDetails();
  }

  Future<void> _loadScholarshipDetails() async {
    // Get scholarship from provider
    final provider = Provider.of<ScholarshipProvider>(context, listen: false);

    // Simulate a brief loading time
    await Future.delayed(const Duration(milliseconds: 300));

    _scholarship = provider.getScholarshipById(widget.scholarshipId);

    // Additional details that aren't part of the model
    _additionalDetails = {
      'requirements': [
        'Academic transcripts',
        'Recommendation letter from a faculty member',
        'Statement of purpose (500 words)',
        'Proof of extracurricular activities',
      ],
      'documents': [
        'Academic certificates',
        'Transcripts',
        'Income proof (if applicable)',
        'Recommendation letter',
      ],
      'benefits': [
        'Financial assistance of ${_scholarship?.amount}',
        'Certificate of merit',
        'Internship opportunities with sponsor companies',
        'Mentorship from industry experts',
      ],
      'sponsoredBy': 'Ministry of Education',
      'applicationProcess':
          'Submit all required documents through the portal. Shortlisted candidates will be called for an interview.',
    };

    setState(() {
      _isLoading = false;
    });
  }

  void _applyForScholarship() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Application'),
          content: const Text(
            'Are you sure you want to apply for this scholarship? Make sure you have all required documents ready.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showApplicationForm();
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  void _showApplicationForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Application Form')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply for ${_scholarship?.title}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please upload the following documents:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Documents upload section
                    _buildDocumentUploadTile(
                      'Academic Certificates',
                      'PDF or JPG format (Max size: 5MB)',
                      _hasCertificatesUploaded,
                      () {
                        setState(() {
                          _hasCertificatesUploaded = true;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDocumentUploadTile(
                      'Transcripts',
                      'PDF format (Max size: 5MB)',
                      _hasTranscriptUploaded,
                      () {
                        setState(() {
                          _hasTranscriptUploaded = true;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDocumentUploadTile(
                      'Income Proof (if applicable)',
                      'PDF or JPG format (Max size: 5MB)',
                      _hasIncomeProofUploaded,
                      () {
                        setState(() {
                          _hasIncomeProofUploaded = true;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDocumentUploadTile(
                      'Recommendation Letter',
                      'PDF format (Max size: 5MB)',
                      _hasRecommendationUploaded,
                      () {
                        setState(() {
                          _hasRecommendationUploaded = true;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Statement of purpose
                    const Text(
                      'Statement of Purpose',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explain why you deserve this scholarship (500 words)',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your statement here...',
                      ),
                      maxLines: 8,
                    ),
                    const SizedBox(height: 32),

                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const Expanded(
                          child: Text(
                            'I certify that all information provided is accurate and complete. I understand that any false information may result in rejection.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          // Update the scholarship in the provider
                          final provider = Provider.of<ScholarshipProvider>(
                            context,
                            listen: false,
                          );
                          provider.applyForScholarship(_scholarship!.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Application submitted successfully!',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    ).then((_) {
      // Refresh the scholarship details when returning from application form
      setState(() {});
    });
  }

  Widget _buildDocumentUploadTile(
    String title,
    String subtitle,
    bool isUploaded,
    VoidCallback onUpload,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing:
            isUploaded
                ? const Icon(Icons.check_circle, color: Colors.green)
                : OutlinedButton(
                  onPressed: onUpload,
                  child: const Text('Upload'),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to scholarship provider changes
    final provider = Provider.of<ScholarshipProvider>(context);

    // Refresh the scholarship if it might have changed
    if (!_isLoading) {
      _scholarship = provider.getScholarshipById(widget.scholarshipId);
    }

    if (_isLoading || _scholarship == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scholarship Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bool isDeadlineNear = _isDeadlineNear(_scholarship!.deadline);
    final bool isApplied = _scholarship!.isApplied;

    return Scaffold(
      appBar: AppBar(title: const Text('Scholarship Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scholarship Title and Category Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _scholarship!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _scholarship!.category,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status chip for applied scholarships
            if (isApplied)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(_scholarship!.status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _scholarship!.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Match Percentage Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_scholarship!.matchPercentage}% Match',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Scholarship Description
            Text(
              _scholarship!.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Key Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Amount',
                      _scholarship!.amount,
                      icon: Icons.payments,
                      isHighlighted: true,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Deadline',
                      _formatDate(_scholarship!.deadline),
                      icon: Icons.calendar_today,
                      isHighlighted: isDeadlineNear,
                      highlightColor: Colors.red,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Eligibility',
                      _scholarship!.eligibility,
                      icon: Icons.verified_user,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Sponsored By',
                      _additionalDetails['sponsoredBy'],
                      icon: Icons.business,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Requirements
            _buildExpandableSection(
              title: 'Requirements',
              icon: Icons.assignment,
              children:
                  _additionalDetails['requirements'].map<Widget>((req) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(req)),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Benefits
            _buildExpandableSection(
              title: 'Benefits',
              icon: Icons.star,
              children:
                  _additionalDetails['benefits'].map<Widget>((benefit) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.thumb_up, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(benefit)),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Application Process
            _buildExpandableSection(
              title: 'Application Process',
              icon: Icons.sync_alt,
              children: [Text(_additionalDetails['applicationProcess'])],
            ),
            const SizedBox(height: 32),

            // Apply button
            if (!isApplied)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _applyForScholarship,
                  icon: const Icon(Icons.edit_document),
                  label: const Text(
                    'Apply Now',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    bool isHighlighted = false,
    Color? highlightColor,
  }) {
    final textColor =
        isHighlighted
            ? highlightColor ?? Theme.of(context).colorScheme.primary
            : null;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : null,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      title: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(title)],
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;

    if (difference <= 0) {
      return 'Expired';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference <= 7) {
      return '$difference days left';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  bool _isDeadlineNear(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;

    return difference >= 0 && difference <= 7;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Under Review':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
