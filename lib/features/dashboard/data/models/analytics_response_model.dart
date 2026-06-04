// lib/features/dashboard/data/models/analytics_response_model.dart

class AnalyticsDataPoint {
  final String periodId;
  final String periodName;
  final double value;

  AnalyticsDataPoint({
    required this.periodId,
    required this.periodName,
    required this.value,
  });
}

class AnalyticsResponseModel {
  final List<AnalyticsDataPoint> dataPoints;

  AnalyticsResponseModel({required this.dataPoints});

  /// Factory map constructor to parse raw DHIS2 multi-dimensional matrix rows
  factory AnalyticsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rows = json['rows'] ?? [];
    final Map<String, dynamic> metaData = json['metaData']?['items'] ?? {};
    
    List<AnalyticsDataPoint> parsedPoints = [];

    for (var row in rows) {
      if (row.length >= 3) {
        // Standard DHIS2 response structure grid layout index:
        // row = Data Element/Indicator ID
        // row = Period string ID (e.g., "202511")
        // row = Numeric value string (e.g., "84.3")
        final String peId = row.toString();
        final double val = double.tryParse(row.toString()) ?? 0.0;
        
        // Lookup human-readable translation string name from metadata block dictionary
        final String peName = metaData[peId]?['name']?.toString() ?? peId;

        parsedPoints.add(AnalyticsDataPoint(
          periodId: peId,
          periodName: peName,
          value: val,
        ));
      }
    }

    // Sort chronologically by period key ID string to ensure linear graphs move forwards
    parsedPoints.sort((a, b) => a.periodId.compareTo(b.periodId));
    return AnalyticsResponseModel(dataPoints: parsedPoints);
  }
}