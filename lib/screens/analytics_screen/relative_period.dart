/// DHIS2-style relative period model.
///
/// Relative periods are grouped into 9 categories (Days, Weeks, Bi-weeks,
/// Months, Bi-months, Quarters, Six-months, Financial Years, Years).
/// Each category has its own set of relative sub-options (e.g. "Last 12
/// months", "This quarter"). Selecting a sub-option yields a final DHIS2
/// period keyword (e.g. LAST_12_MONTHS) that can be sent as the `pe`
/// analytics dimension.
library relative_period;

enum PeriodCategory { days, weeks, biWeeks, months, biMonths, quarters, sixMonths, financialYears, years }

extension PeriodCategoryLabel on PeriodCategory {
  String get label {
    switch (this) {
      case PeriodCategory.days:
        return 'Days';
      case PeriodCategory.weeks:
        return 'Weeks';
      case PeriodCategory.biWeeks:
        return 'Bi-weeks';
      case PeriodCategory.months:
        return 'Months';
      case PeriodCategory.biMonths:
        return 'Bi-months';
      case PeriodCategory.quarters:
        return 'Quarters';
      case PeriodCategory.sixMonths:
        return 'Six-months';
      case PeriodCategory.financialYears:
        return 'Financial Years';
      case PeriodCategory.years:
        return 'Years';
    }
  }
}

class RelativePeriod {
  /// DHIS2 keyword, e.g. LAST_12_MONTHS. Sent as the `pe` dimension value.
  final String id;

  /// Human readable label, e.g. "Last 12 months".
  final String label;

  final PeriodCategory category;

  const RelativePeriod({required this.id, required this.label, required this.category});

  @override
  bool operator ==(Object other) => other is RelativePeriod && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class RelativePeriods {
  RelativePeriods._();

  static const List<RelativePeriod> all = [
    // Days
    RelativePeriod(id: 'TODAY', label: 'Today', category: PeriodCategory.days),
    RelativePeriod(id: 'YESTERDAY', label: 'Yesterday', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_3_DAYS', label: 'Last 3 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_7_DAYS', label: 'Last 7 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_14_DAYS', label: 'Last 14 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_30_DAYS', label: 'Last 30 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_60_DAYS', label: 'Last 60 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_90_DAYS', label: 'Last 90 days', category: PeriodCategory.days),
    RelativePeriod(id: 'LAST_180_DAYS', label: 'Last 180 days', category: PeriodCategory.days),

    // Weeks
    RelativePeriod(id: 'THIS_WEEK', label: 'This week', category: PeriodCategory.weeks),
    RelativePeriod(id: 'LAST_WEEK', label: 'Last week', category: PeriodCategory.weeks),
    RelativePeriod(id: 'LAST_4_WEEKS', label: 'Last 4 weeks', category: PeriodCategory.weeks),
    RelativePeriod(id: 'LAST_12_WEEKS', label: 'Last 12 weeks', category: PeriodCategory.weeks),
    RelativePeriod(id: 'LAST_52_WEEKS', label: 'Last 52 weeks', category: PeriodCategory.weeks),
    RelativePeriod(id: 'WEEKS_THIS_YEAR', label: 'Weeks this year', category: PeriodCategory.weeks),

    // Bi-weeks
    RelativePeriod(id: 'THIS_BIWEEK', label: 'This bi-week', category: PeriodCategory.biWeeks),
    RelativePeriod(id: 'LAST_BIWEEK', label: 'Last bi-week', category: PeriodCategory.biWeeks),
    RelativePeriod(id: 'LAST_4_BIWEEKS', label: 'Last 4 bi-weeks', category: PeriodCategory.biWeeks),
    RelativePeriod(id: 'BIWEEKS_THIS_YEAR', label: 'Bi-weeks this year', category: PeriodCategory.biWeeks),

    // Months
    RelativePeriod(id: 'THIS_MONTH', label: 'This month', category: PeriodCategory.months),
    RelativePeriod(id: 'LAST_MONTH', label: 'Last month', category: PeriodCategory.months),
    RelativePeriod(id: 'LAST_3_MONTHS', label: 'Last 3 months', category: PeriodCategory.months),
    RelativePeriod(id: 'LAST_6_MONTHS', label: 'Last 6 months', category: PeriodCategory.months),
    RelativePeriod(id: 'LAST_12_MONTHS', label: 'Last 12 months', category: PeriodCategory.months),
    RelativePeriod(id: 'MONTHS_THIS_YEAR', label: 'Months this year', category: PeriodCategory.months),

    // Bi-months
    RelativePeriod(id: 'THIS_BIMONTH', label: 'This bi-month', category: PeriodCategory.biMonths),
    RelativePeriod(id: 'LAST_BIMONTH', label: 'Last bi-month', category: PeriodCategory.biMonths),
    RelativePeriod(id: 'LAST_6_BIMONTHS', label: 'Last 6 bi-months', category: PeriodCategory.biMonths),
    RelativePeriod(id: 'BIMONTHS_THIS_YEAR', label: 'Bi-months this year', category: PeriodCategory.biMonths),

    // Quarters
    RelativePeriod(id: 'THIS_QUARTER', label: 'This quarter', category: PeriodCategory.quarters),
    RelativePeriod(id: 'LAST_QUARTER', label: 'Last quarter', category: PeriodCategory.quarters),
    RelativePeriod(id: 'LAST_4_QUARTERS', label: 'Last 4 quarters', category: PeriodCategory.quarters),
    RelativePeriod(id: 'QUARTERS_THIS_YEAR', label: 'Quarters this year', category: PeriodCategory.quarters),

    // Six-months
    RelativePeriod(id: 'THIS_SIX_MONTH', label: 'This six-month', category: PeriodCategory.sixMonths),
    RelativePeriod(id: 'LAST_SIX_MONTH', label: 'Last six-month', category: PeriodCategory.sixMonths),
    RelativePeriod(id: 'LAST_2_SIXMONTHS', label: 'Last 2 six-months', category: PeriodCategory.sixMonths),
    RelativePeriod(id: 'SIXMONTHS_THIS_YEAR', label: 'Six-months this year', category: PeriodCategory.sixMonths),

    // Financial Years
    RelativePeriod(id: 'THIS_FINANCIAL_YEAR', label: 'This financial year', category: PeriodCategory.financialYears),
    RelativePeriod(id: 'LAST_FINANCIAL_YEAR', label: 'Last financial year', category: PeriodCategory.financialYears),
    RelativePeriod(id: 'LAST_5_FINANCIAL_YEARS', label: 'Last 5 financial years', category: PeriodCategory.financialYears),
    RelativePeriod(id: 'LAST_10_FINANCIAL_YEARS', label: 'Last 10 financial years', category: PeriodCategory.financialYears),

    // Years
    RelativePeriod(id: 'THIS_YEAR', label: 'This year', category: PeriodCategory.years),
    RelativePeriod(id: 'LAST_YEAR', label: 'Last year', category: PeriodCategory.years),
    RelativePeriod(id: 'LAST_5_YEARS', label: 'Last 5 years', category: PeriodCategory.years),
    RelativePeriod(id: 'LAST_10_YEARS', label: 'Last 10 years', category: PeriodCategory.years),
  ];

  static List<RelativePeriod> byCategory(PeriodCategory category) =>
      all.where((p) => p.category == category).toList(growable: false);

  static RelativePeriod get defaultPeriod =>
      all.firstWhere((p) => p.id == 'LAST_6_MONTHS', orElse: () => all.first);

  static RelativePeriod? fromId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}

/// Resolves a [RelativePeriod] into a list of short chart-axis labels
/// relative to "now", e.g. LAST_6_MONTHS -> [Feb, Mar, Apr, May, Jun, Jul].
/// This is only used to drive mock/preview data — a real integration should
/// use the DHIS2 analytics API response's own period labels.
List<String> resolvePeriodCategoryLabels(RelativePeriod period, {DateTime? now}) {
  final today = now ?? DateTime.now();
  const monthAbbrev = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  int countFrom(String id, int fallback) {
    final match = RegExp(r'_(\d+)_').firstMatch('_${id}_');
    if (match != null) return int.tryParse(match.group(1) ?? '') ?? fallback;
    return fallback;
  }

  switch (period.category) {
    case PeriodCategory.days:
      final n = period.id == 'TODAY' || period.id == 'YESTERDAY' ? 1 : countFrom(period.id, 7);
      return List.generate(n, (i) {
        final d = today.subtract(Duration(days: n - 1 - i));
        return '${d.day}/${d.month}';
      });

    case PeriodCategory.weeks:
    case PeriodCategory.biWeeks:
      final n = period.id.startsWith('THIS') || period.id.startsWith('LAST_') == false
          ? 8
          : countFrom(period.id, 8);
      return List.generate(n, (i) => 'Wk ${i + 1}');

    case PeriodCategory.months:
      final n = countFrom(period.id, 6).clamp(1, 12);
      return List.generate(n, (i) {
        final monthIndex = (today.month - 1 - (n - 1 - i)) % 12;
        final normalized = monthIndex < 0 ? monthIndex + 12 : monthIndex;
        return monthAbbrev[normalized];
      });

    case PeriodCategory.biMonths:
      final n = countFrom(period.id, 6).clamp(1, 6);
      return List.generate(n, (i) => 'BM ${i + 1}');

    case PeriodCategory.quarters:
      final n = countFrom(period.id, 4).clamp(1, 4);
      return List.generate(n, (i) => 'Q${i + 1}');

    case PeriodCategory.sixMonths:
      final n = countFrom(period.id, 2).clamp(1, 2);
      return List.generate(n, (i) => 'S${i + 1}');

    case PeriodCategory.financialYears:
    case PeriodCategory.years:
      final n = countFrom(period.id, 5).clamp(1, 10);
      return List.generate(n, (i) => '${today.year - (n - 1 - i)}');
  }
}