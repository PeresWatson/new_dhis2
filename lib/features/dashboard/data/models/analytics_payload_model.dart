// lib/features/dashboard/data/models/analytics_payload_model.dart

class IndicatorDataRow {
  final String period;
  final double targetValue;
  final double actualValue;

  IndicatorDataRow({
    required this.period,
    required this.targetValue,
    required this.actualValue,
  });
}

class AnalyticsPayloadModel {
  final String indicatorName;
  final List<IndicatorDataRow> rows;

  AnalyticsPayloadModel({required this.indicatorName, required this.rows});

  factory AnalyticsPayloadModel.fromMock() {
    // Simulating parsed output derived from a heavy DHIS2 matrix json response block
    return AnalyticsPayloadModel(
      indicatorName: "ANC 1st Visit Coverage (Last 12 Months)",
      rows: [
        IndicatorDataRow(period: "Jul '25", targetValue: 95.0, actualValue: 95.58),
        IndicatorDataRow(period: "Aug '25", targetValue: 95.0, actualValue: 97.69),
        IndicatorDataRow(period: "Sep '25", targetValue: 95.0, actualValue: 79.79),
        IndicatorDataRow(period: "Oct '25", targetValue: 95.0, actualValue: 92.10),
        IndicatorDataRow(period: "Nov '25", targetValue: 95.0, actualValue: 94.31),
        IndicatorDataRow(period: "Dec '25", targetValue: 95.0, actualValue: 96.02),
      ],
    );
  }
}