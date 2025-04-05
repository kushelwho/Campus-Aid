import 'package:flutter/material.dart';

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
  late Map<String, dynamic> _scholarship;
  bool _isLoading = true;

  // Document upload flags for UI
  bool _hasCertificatesUploaded = false;
  bool _hasTranscriptUploaded = false;
  bool _hasIncomeProofUploaded = false;
  bool _hasRecommendationUploaded = false;

  @override
  void initState() {
    super.initState();
    _loadScholarshipDetails();
  }

  Future<void> _loadScholarshipDetails() async {
    // Simulate loading from backend
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock scholarship details
    final Map<String, dynamic> scholarshipData = {
      'id': '1',
      'title': 'National Merit Scholarship',
      'category': 'Merit',
      'description':
          'The National Merit Scholarship is awarded to exceptional students who have demonstrated outstanding academic achievements and leadership abilities throughout their educational journey. This prestigious scholarship aims to recognize and support students who have consistently maintained high academic standards.',
      'amount': '₹50,000',
      'deadline': '2023-05-30',
      'eligibility': 'CGPA 8.5 or above, any discipline',
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
        'Financial assistance of ₹50,000',
        'Certificate of merit',
        'Internship opportunities with sponsor companies',
        'Mentorship from industry experts',
      ],
      'sponsoredBy': 'Ministry of Education',
      'matchPercentage': 92,
      'applicationProcess':
          'Submit all required documents through the portal. Shortlisted candidates will be called for an interview.',
      'isApplied': widget.isApplied,
      'status': widget.isApplied ? 'Under Review' : 'Not Applied',
    };

    setState(() {
      _scholarship = scholarshipData;
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
                      'Apply for ${_scholarship['title']}',
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
                          // Show success message and navigate back to scholarship details
                          setState(() {
                            _scholarship['isApplied'] = true;
                            _scholarship['status'] = 'Under Review';
                          });
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
    );
  }

  Widget _buildDocumentUploadTile(
    String title,
    String description,
    bool isUploaded,
    VoidCallback onUpload,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUploaded ? Colors.green[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.file_upload,
              color: isUploaded ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isUploaded ? 'Uploaded' : description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUploaded ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: isUploaded ? null : onUpload,
            child: Text(isUploaded ? 'Uploaded' : 'Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const Text('• '), Expanded(child: Text(item))],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scholarship Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bool isApplied = _scholarship['isApplied'] as bool;
    final String status = _scholarship['status'] as String;
    final int matchPercentage = _scholarship['matchPercentage'] as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Scholarship Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scholarship title and match
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _scholarship['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$matchPercentage% Match',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Category and amount
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _scholarship['category'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.amber[700],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _scholarship['amount'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Application status
            if (isApplied)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Application Status: $status',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your application is being reviewed. You will be notified once a decision is made.',
                      style: TextStyle(fontSize: 12),
                    ),
                    if (status == 'Under Review') ...[
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.blue[100],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Submitted',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                          Text(
                            'Under Review',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            'Decision',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[200],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            // Description
            _buildSectionTitle('Description'),
            Text(_scholarship['description'] as String),

            // Scholarship details
            _buildInfoRow('Deadline', _scholarship['deadline'] as String),
            _buildInfoRow('Eligibility', _scholarship['eligibility'] as String),
            _buildInfoRow(
              'Sponsored By',
              _scholarship['sponsoredBy'] as String,
            ),

            // Requirements
            _buildListSection(
              'Requirements',
              (_scholarship['requirements'] as List<dynamic>).cast<String>(),
            ),

            // Required documents
            _buildListSection(
              'Required Documents',
              (_scholarship['documents'] as List<dynamic>).cast<String>(),
            ),

            // Benefits
            _buildListSection(
              'Benefits',
              (_scholarship['benefits'] as List<dynamic>).cast<String>(),
            ),

            // Application process
            _buildSectionTitle('Application Process'),
            Text(_scholarship['applicationProcess'] as String),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child:
            isApplied
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Applied - $status',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
                : FilledButton(
                  onPressed: _applyForScholarship,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
      ),
    );
  }
}
