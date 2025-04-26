class ErrorDetails {
  final dynamic details;
  final String? description;

  ErrorDetails({
    this.details,
    this.description
  });

  factory ErrorDetails.fromJson(Map<String, dynamic> json){
    return ErrorDetails(
      details: json['details'],
      description: json['description'] as String?
    );
  }
}
