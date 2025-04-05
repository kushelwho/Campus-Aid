class ScholarshipModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String amount;
  final String deadline;
  final String eligibility;
  final int matchPercentage;
  final bool isApplied;
  final String status;

  ScholarshipModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.eligibility,
    required this.matchPercentage,
    this.isApplied = false,
    this.status = 'Not Applied',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'amount': amount,
      'deadline': deadline,
      'eligibility': eligibility,
      'matchPercentage': matchPercentage,
      'isApplied': isApplied,
      'status': status,
    };
  }

  // Create from JSON for retrieval
  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      amount: json['amount'],
      deadline: json['deadline'],
      eligibility: json['eligibility'],
      matchPercentage: json['matchPercentage'],
      isApplied: json['isApplied'],
      status: json['status'],
    );
  }
}
