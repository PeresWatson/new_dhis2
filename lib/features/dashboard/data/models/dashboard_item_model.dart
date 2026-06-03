class Dhis2DashboardItem {
  final String id;
  final String type;   // Expected variants: 'CHART', 'VISUALIZATION', 'REPORT_TABLE', 'MAP'
  final String shape;  // Expected variants: 'NORMAL', 'DOUBLE_WIDTH'
  final String? visualId;
  final String displayName;

  Dhis2DashboardItem({
    required this.id,
    required this.type,
    required this.shape,
    this.visualId,
    required this.displayName,
  });

  factory Dhis2DashboardItem.fromJson(Map<String, dynamic> json) {
    // DHIS2 uses distinct sub-objects based on the component type
    final Map<String, dynamic>? visualRef = 
        json['chart'] ?? json['visualization'] ?? json['map'] ?? json['reportTable'];
        
    return Dhis2DashboardItem(
      id: json['id'] as String,
      type: json['type'] as String,
      shape: json['shape'] as String? ?? 'NORMAL',
      visualId: visualRef?['id'] as String?,
      displayName: visualRef?['displayName'] as String? ?? 'Untitled Component',
    );
  }
}