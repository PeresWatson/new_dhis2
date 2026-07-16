import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dhis_2/common/utils/charts/visualization_widget.dart';

// The relative-period model we worked on earlier (Days / Weeks / Bi-weeks /
// Months / Bi-months / Quarters / Six-months / Financial Years / Years).
// Adjust the import path below to wherever it actually lives in your project.
import 'relative_period.dart';

const Color kBrandColor = Color(0xFF1D5288);

// ---------------------------------------------------------------------------
// Domain models
// ---------------------------------------------------------------------------

/// A selectable DHIS2 data element.
class DataElementItem {
  final String id;
  final String name;
  final String valueType;

  const DataElementItem({required this.id, required this.name, this.valueType = 'Number'});
}

/// A selectable DHIS2 organisation unit.
class OrgUnitItem {
  final String id;
  final String name;
  final String level;
  final double latitude;
  final double longitude;

  const OrgUnitItem({
    required this.id,
    required this.name,
    required this.level,
    required this.latitude,
    required this.longitude,
  });
}

/// The set of chart/visualization render types we support, mirrored from
/// DHIS2's `availableRenderTypes` (line, bar, pie, map, pivot).
enum VisualizationType { line, bar, pie, map, pivot }

extension VisualizationTypeX on VisualizationType {
  String get id => name;

  String get label {
    switch (this) {
      case VisualizationType.line:
        return 'Line Chart';
      case VisualizationType.bar:
        return 'Bar Chart';
      case VisualizationType.pie:
        return 'Pie Chart';
      case VisualizationType.map:
        return 'Map';
      case VisualizationType.pivot:
        return 'Pivot Table';
    }
  }

  IconData get icon {
    switch (this) {
      case VisualizationType.line:
        return Icons.show_chart;
      case VisualizationType.bar:
        return Icons.bar_chart;
      case VisualizationType.pie:
        return Icons.pie_chart;
      case VisualizationType.map:
        return Icons.map;
      case VisualizationType.pivot:
        return Icons.table_chart;
    }
  }
}

/// Everything needed to fire an analytics request. `toDhis2Params` maps
/// straight onto the DHIS2 analytics `dx` / `ou` / `pe` dimensions.
class AnalyticsQuery {
  final List<String> dataElementIds;
  final List<String> orgUnitIds;
  final RelativePeriod period;
  final VisualizationType visualizationType;

  const AnalyticsQuery({
    required this.dataElementIds,
    required this.orgUnitIds,
    required this.period,
    required this.visualizationType,
  });

  Map<String, String> toDhis2Params() => {
        'dx': dataElementIds.join(';'),
        'ou': orgUnitIds.join(';'),
        'pe': period.id,
      };
}

// ---------------------------------------------------------------------------
// Mock catalogues (swap these for real metadata/dataStore lookups)
// ---------------------------------------------------------------------------

const List<DataElementItem> kMockDataElements = [
  DataElementItem(id: 'de1', name: 'ANC 1st Visit'),
  DataElementItem(id: 'de2', name: 'ANC 4th Visit'),
  DataElementItem(id: 'de3', name: 'Penta 3 Doses Given'),
  DataElementItem(id: 'de4', name: 'Measles Doses Given'),
  DataElementItem(id: 'de5', name: 'Institutional Deliveries'),
  DataElementItem(id: 'de6', name: 'Malaria Cases Confirmed'),
  DataElementItem(id: 'de7', name: 'OPD Attendance'),
  DataElementItem(id: 'de8', name: 'Facility Reporting Rate', valueType: 'Percentage'),
];

const List<OrgUnitItem> kMockOrgUnits = [
  OrgUnitItem(id: 'ou1', name: 'Western Area', level: 'District', latitude: 8.484, longitude: -13.234),
  OrgUnitItem(id: 'ou2', name: 'Bo', level: 'District', latitude: 7.964, longitude: -11.738),
  OrgUnitItem(id: 'ou3', name: 'Kenema', level: 'District', latitude: 7.876, longitude: -11.190),
  OrgUnitItem(id: 'ou4', name: 'Pujehun', level: 'District', latitude: 7.35, longitude: -11.7167),
  OrgUnitItem(id: 'ou5', name: 'Koinadugu', level: 'District', latitude: 9.4167, longitude: -11.4333),
  OrgUnitItem(id: 'ou6', name: 'Kambia', level: 'District', latitude: 9.13, longitude: -12.92),
  OrgUnitItem(id: 'ou7', name: 'Bombali', level: 'District', latitude: 9.0, longitude: -12.15),
];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final List<DataElementItem> _dataElements = kMockDataElements;
  final List<OrgUnitItem> _orgUnits = kMockOrgUnits;

  final Set<String> _selectedDataElementIds = {};
  final Set<String> _selectedOrgUnitIds = {};
  RelativePeriod _selectedPeriod = RelativePeriods.defaultPeriod;
  VisualizationType _selectedVisualization = VisualizationType.line;

  final GlobalKey _dataElementKey = GlobalKey();
  final GlobalKey _orgUnitKey = GlobalKey();
  final GlobalKey _periodKey = GlobalKey();
  final GlobalKey _visualizationKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _isOverlayOpen = false;
  bool _isLoading = false;
  Map<String, dynamic>? _analyticsItem;

  bool get _canFetch => _selectedDataElementIds.isNotEmpty && _selectedOrgUnitIds.isNotEmpty;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  // -- generic floating overlay, positioned under the tapped field ---------

  void _showOverlay({
    required GlobalKey anchorKey,
    required WidgetBuilder contentBuilder,
  }) {
    _closeOverlay();

    final renderBox = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = (screenHeight - offset.dy - size.height - 40).clamp(220.0, 420.0);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeOverlay,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 6,
              width: size.width,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: contentBuilder(overlayContext),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOverlayOpen = true);
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOverlayOpen) setState(() => _isOverlayOpen = false);
  }

  // -- field openers ---------------------------------------------------------

  void _openDataElementSelector() {
    _showOverlay(
      anchorKey: _dataElementKey,
      contentBuilder: (_) => _MultiSelectPanel<DataElementItem>(
        items: _dataElements,
        selectedIds: _selectedDataElementIds,
        idOf: (e) => e.id,
        labelOf: (e) => e.name,
        subtitleOf: (e) => e.valueType,
        hintText: 'Search data elements...',
        onChanged: (ids) => setState(() {
          _selectedDataElementIds
            ..clear()
            ..addAll(ids);
        }),
        onDone: _closeOverlay,
      ),
    );
  }

  void _openOrgUnitSelector() {
    _showOverlay(
      anchorKey: _orgUnitKey,
      contentBuilder: (_) => _MultiSelectPanel<OrgUnitItem>(
        items: _orgUnits,
        selectedIds: _selectedOrgUnitIds,
        idOf: (e) => e.id,
        labelOf: (e) => e.name,
        subtitleOf: (e) => e.level,
        hintText: 'Search organisation units...',
        onChanged: (ids) => setState(() {
          _selectedOrgUnitIds
            ..clear()
            ..addAll(ids);
        }),
        onDone: _closeOverlay,
      ),
    );
  }

  void _openPeriodSelector() {
    _showOverlay(
      anchorKey: _periodKey,
      contentBuilder: (_) => _PeriodSelectPanel(
        selected: _selectedPeriod,
        onSelected: (p) {
          setState(() => _selectedPeriod = p);
          _closeOverlay();
        },
      ),
    );
  }

  void _openVisualizationSelector() {
    _showOverlay(
      anchorKey: _visualizationKey,
      contentBuilder: (_) => _VisualizationSelectPanel(
        selected: _selectedVisualization,
        onSelected: (v) {
          setState(() => _selectedVisualization = v);
          _closeOverlay();
        },
      ),
    );
  }

  // -- field display text ----------------------------------------------------

  String get _dataElementDisplay {
    if (_selectedDataElementIds.isEmpty) return 'Select data element(s)';
    if (_selectedDataElementIds.length == 1) {
      return _dataElements.firstWhere((e) => e.id == _selectedDataElementIds.first).name;
    }
    return '${_selectedDataElementIds.length} data elements selected';
  }

  String get _orgUnitDisplay {
    if (_selectedOrgUnitIds.isEmpty) return 'Select organisation unit(s)';
    if (_selectedOrgUnitIds.length == 1) {
      return _orgUnits.firstWhere((e) => e.id == _selectedOrgUnitIds.first).name;
    }
    return '${_selectedOrgUnitIds.length} org units selected';
  }

  String get _periodDisplay => _selectedPeriod.label;

  String get _visualizationDisplay => _selectedVisualization.label;

  // -- fetch -------------------------------------------------------------

  Future<void> _fetchAnalytics() async {
    _closeOverlay();
    setState(() => _isLoading = true);

    final query = AnalyticsQuery(
      dataElementIds: _selectedDataElementIds.toList(),
      orgUnitIds: _selectedOrgUnitIds.toList(),
      period: _selectedPeriod,
      visualizationType: _selectedVisualization,
    );

    // TODO: replace this mock with a real call, e.g.:
    // final params = query.toDhis2Params();
    // final item = await AnalyticsRepository().fetchAnalytics(params, renderType: query.visualizationType.id);
    await Future.delayed(const Duration(milliseconds: 600));
    final item = _buildMockAnalyticsItem(query);

    if (!mounted) return;
    setState(() {
      _analyticsItem = item;
      _isLoading = false;
    });
  }

  Map<String, dynamic> _buildMockAnalyticsItem(AnalyticsQuery query) {
    final categories = resolvePeriodCategoryLabels(query.period);
    final rnd = Random(query.period.id.hashCode ^ query.dataElementIds.join().hashCode);

    final series = query.dataElementIds.map((id) {
      final de = _dataElements.firstWhere((e) => e.id == id);
      final base = 55 + rnd.nextInt(30);
      final values = List.generate(
        categories.length,
        (i) => (base + rnd.nextInt(15) - 7 + i).toDouble().clamp(0, 100),
      );
      return {'name': de.name, 'values': values};
    }).toList();

    final locations = query.orgUnitIds.map((id) {
      final ou = _orgUnits.firstWhere((e) => e.id == id);
      return {
        'name': ou.name,
        'latitude': ou.latitude,
        'longitude': ou.longitude,
        'value': (50 + rnd.nextInt(45)).toDouble(),
      };
    }).toList();

    final titleNames = query.dataElementIds.map((id) => _dataElements.firstWhere((e) => e.id == id).name);

    return {
      'id': 'AN_${DateTime.now().millisecondsSinceEpoch}',
      'dashboardId': 'ANALYTICS',
      'title': titleNames.join(', '),
      'description': '${query.period.label} across ${query.orgUnitIds.length} organisation unit(s).',
      'defaultRenderType': query.visualizationType.id,
      'availableRenderTypes': VisualizationType.values.map((v) => v.id).toList(),
      'metadata': {'periodType': query.period.category.label, 'indicatorType': 'Coverage'},
      'data': {'categories': categories, 'series': series, 'locations': locations},
    };
  }

  // -- reusable field button ----------------------------------------------

  Widget _filterField({
    required String title,
    required String value,
    required GlobalKey fieldKey,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: fieldKey,
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: kBrandColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: kBrandColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBrandColor,
        title: const Text('Analytics', style: TextStyle(fontSize: 15, color: Colors.white)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _filterField(
                title: 'Data',
                value: _dataElementDisplay,
                fieldKey: _dataElementKey,
                icon: Icons.dns_outlined,
                onTap: _openDataElementSelector,
              ),
              const SizedBox(height: 12),
              _filterField(
                title: 'Period',
                value: _periodDisplay,
                fieldKey: _periodKey,
                icon: Icons.calendar_today_outlined,
                onTap: _openPeriodSelector,
              ),
              const SizedBox(height: 12),
              _filterField(
                title: 'Organisation unit',
                value: _orgUnitDisplay,
                fieldKey: _orgUnitKey,
                icon: Icons.account_tree_outlined,
                onTap: _openOrgUnitSelector,
              ),
              const SizedBox(height: 12),
              _filterField(
                title: 'Visualization',
                value: _visualizationDisplay,
                fieldKey: _visualizationKey,
                icon: Icons.bar_chart,
                onTap: _openVisualizationSelector,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _canFetch && !_isLoading ? _fetchAnalytics : null,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.query_stats),
                  label: Text(_isLoading ? 'Fetching...' : 'Fetch Analytics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrandColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _analyticsItem == null
                      ? const SizedBox(
                          height: 180,
                          child: Center(
                            child: Text(
                              'Choose a data element, period and organisation unit,\nthen tap "Fetch Analytics".',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : VisualizationWidget(item: _analyticsItem!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared overlay panels
// ---------------------------------------------------------------------------

/// Searchable checkbox list used for both the data-element and org-unit
/// selectors (DHIS2 analytics accepts multiple `dx` / `ou` values).
class _MultiSelectPanel<T> extends StatefulWidget {
  final List<T> items;
  final Set<String> selectedIds;
  final String Function(T) idOf;
  final String Function(T) labelOf;
  final String Function(T)? subtitleOf;
  final ValueChanged<Set<String>> onChanged;
  final VoidCallback onDone;
  final String hintText;

  const _MultiSelectPanel({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.idOf,
    required this.labelOf,
    required this.onChanged,
    required this.onDone,
    this.subtitleOf,
    this.hintText = 'Search...',
  });

  @override
  State<_MultiSelectPanel<T>> createState() => _MultiSelectPanelState<T>();
}

class _MultiSelectPanelState<T> extends State<_MultiSelectPanel<T>> {
  late Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.of(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items
        .where((e) => widget.labelOf(e).toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final id = widget.idOf(item);
                final checked = _selected.contains(id);

                return CheckboxListTile(
                  value: checked,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: kBrandColor,
                  title: Text(widget.labelOf(item), style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: widget.subtitleOf != null ? Text(widget.subtitleOf!(item)) : null,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(id);
                      } else {
                        _selected.remove(id);
                      }
                    });
                    widget.onChanged(_selected);
                  },
                );
              },
            ),
          ),
          const Divider(height: 16),
          Row(
            children: [
              Text('${_selected.length} selected', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const Spacer(),
              TextButton(
                onPressed: widget.onDone,
                style: TextButton.styleFrom(foregroundColor: kBrandColor),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Two-level period selector: pick a category (Days, Weeks, Months, ...)
/// then a specific relative period within it (e.g. "This week", "Yesterday").
class _PeriodSelectPanel extends StatefulWidget {
  final RelativePeriod selected;
  final ValueChanged<RelativePeriod> onSelected;

  const _PeriodSelectPanel({required this.selected, required this.onSelected});

  @override
  State<_PeriodSelectPanel> createState() => _PeriodSelectPanelState();
}

class _PeriodSelectPanelState extends State<_PeriodSelectPanel> {
  PeriodCategory? _activeCategory;

  @override
  void initState() {
    super.initState();
    // Jump straight into the current selection's category for convenience.
    _activeCategory = widget.selected.category;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: _activeCategory == null ? _categoryList() : _periodList(_activeCategory!),
    );
  }

  Widget _categoryList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('Select a period type', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: PeriodCategory.values.map((c) {
              final isCurrent = widget.selected.category == c;
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: isCurrent ? kBrandColor : Colors.grey.shade200,
                  child: Icon(Icons.calendar_month, size: 16, color: isCurrent ? Colors.white : Colors.grey),
                ),
                title: Text(c.label),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => setState(() => _activeCategory = c),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _periodList(PeriodCategory category) {
    final options = RelativePeriods.byCategory(category);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: kBrandColor,
              onPressed: () => setState(() => _activeCategory = null),
            ),
            Text(category.label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final p = options[index];
              final selected = p.id == widget.selected.id;
              return ListTile(
                dense: true,
                title: Text(p.label),
                trailing: selected ? const Icon(Icons.check_circle, color: kBrandColor) : null,
                onTap: () => widget.onSelected(p),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Single-select list of render/visualization types.
class _VisualizationSelectPanel extends StatelessWidget {
  final VisualizationType selected;
  final ValueChanged<VisualizationType> onSelected;

  const _VisualizationSelectPanel({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: VisualizationType.values.map((v) {
          final isSelected = v == selected;
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: isSelected ? kBrandColor : Colors.grey.shade200,
              child: Icon(v.icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
            ),
            title: Text(v.label),
            trailing: isSelected ? const Icon(Icons.check_circle, color: kBrandColor) : null,
            onTap: () => onSelected(v),
          );
        }).toList(),
      ),
    );
  }
}