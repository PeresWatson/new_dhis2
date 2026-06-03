class Dhis2Dashboard {
  final String id;
  final String displayName;
  final bool starred;

  Dhis2Dashboard({
    required this.id,
    required this.displayName,
    required this.starred,
  });

  // Maps raw DHIS2 JSON fields cleanly to structured Dart models
  factory Dhis2Dashboard.fromJson(Map<String, dynamic> json) {
    return Dhis2Dashboard(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      starred: json['starred'] as bool? ?? false,
    );
  }
}