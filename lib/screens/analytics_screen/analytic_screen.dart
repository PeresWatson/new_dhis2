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

  const DataElementItem({required this.id, required this.name});
}

/// A single facility / org unit leaf (level 4 in DHIS2's Sierra Leone tree).
class OrgUnitItem {
  final String id;
  final String name;

  const OrgUnitItem({required this.id, required this.name});
}

/// A district (level 2) with its facilities nested underneath — this is what
/// drives the two-level "district -> facility" selector, the same shape as
/// the period selector's "category -> relative period".
class DistrictOrgUnit {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<OrgUnitItem> facilities;

  const DistrictOrgUnit({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.facilities,
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
// Mock catalogues
// ---------------------------------------------------------------------------
//
// Data elements below are the real DHIS2 metadata you supplied. Org units
// are real facility id/displayName pairs you supplied, bucketed under three
// real districts (Bo, Bombali, Bonthe — whose ids also came from your data).
//
// NOTE: the source list didn't carry a parent/district id per facility, so
// the district <-> facility grouping here is a placeholder split (just to
// demonstrate the two-level UI). In production, replace `kMockDistricts`
// with a real call such as:
//   GET /api/organisationUnits.json?filter=level:eq:2&fields=id,displayName,children[id,displayName]
// or lazily fetch a district's children with:
//   GET /api/organisationUnits/{districtId}.json?fields=children[id,displayName]

const List<DataElementItem> kMockDataElements = [
  DataElementItem(id: 'rNEpbBxSyu7', name: 'ART No clients with new adverse drug reaction'),
  DataElementItem(id: 'CxlYcbqio4v', name: 'ART No started Opportunist Infection prophylaxis'),
  DataElementItem(id: 'ibL7BD2vn2C', name: 'ART treatment stopped due to death'),
  DataElementItem(id: 'TyQ1vOHM6JO', name: 'ART treatment stopped due to loss to follow-up'),
  DataElementItem(id: 's46m5MS0hxu', name: 'BCG doses given'),
  DataElementItem(id: 'uf3svrmp8Oj', name: 'Birth certificate'),
  DataElementItem(id: 'nzl75uHiWQO', name: 'Blood pressure monitor, electronic or manual available'),
  DataElementItem(id: 'yO0ZIegEsDk', name: 'Blood transfusion within 3 months before onset of symptoms'),
  DataElementItem(id: 'QYBJk7sqc1I', name: 'Burns follow-up'),
  DataElementItem(id: 'zMGEd921xd3', name: 'Burns new'),
  DataElementItem(id: 'BHvVPwWrrLC', name: 'Burns referrals'),
  DataElementItem(id: 'A21lT9x7pmc', name: 'Cabin fever'),
  DataElementItem(id: 'fazCI2ygYkq', name: 'Case detection'),
  DataElementItem(id: 'eYApmORDKgx', name: 'Case Investigation Conducted By'),
  DataElementItem(id: 'lvx6qda7SN0', name: 'Case species classification'),
  DataElementItem(id: 'hhevl49MXyA', name: 'Children from Gen.Paed. ward tested for HIV'),
  DataElementItem(id: 'HL77Pems4Cv', name: 'Children from Gen.Paed. ward with positive HIV result'),
  DataElementItem(id: 'ydvyXLhIbTn', name: 'Children from TB ward tested for HIV'),
  DataElementItem(id: 'AKJvJehDSb6', name: 'Children from TB ward with positive HIV result'),
  DataElementItem(id: 'xFpppWvT43s', name: 'Children from TFC tested for HIV'),
  DataElementItem(id: 'KWzP8OWYQL7', name: 'Children from TFC with positive HIV result'),
  DataElementItem(id: 'qw2sIef52Fu', name: 'Children getting therapeutic feeding'),
  DataElementItem(id: 'e73QxJpd88B', name: 'Children HIV 1&2 positive test'),
  DataElementItem(id: 'EnsFXKU7LEW', name: 'Children HIV 1 positive test'),
  DataElementItem(id: 'GhsYeB89HaL', name: 'Children HIV 2 positive test'),
  DataElementItem(id: 'MWEGBw0pmgU', name: 'Children initiated ARV treatment'),
  DataElementItem(id: 'SMrE2ByiyZp', name: 'Children on exclusive breastfeeding (HIV Paed.)'),
  DataElementItem(id: 'UMexg4VGfaY', name: 'Children on replacement feeding (HIV Paed.)'),
  DataElementItem(id: 'Y53Jcc9LBYh', name: 'Children supplied with food supplemements'),
  DataElementItem(id: 'LSJ5mKpyEv1', name: 'CHO'),
  DataElementItem(id: 'eY5ehpbEsB7', name: 'Cholera (Deaths < 5 yrs)'),
  DataElementItem(id: 'mxc1T932aWM', name: 'Cholera (Deaths < 5 yrs) Narrative'),
  DataElementItem(id: 'HJulLfnIAE3', name: 'Clinical Malnutrition follow-up'),
  DataElementItem(id: 'TBbCcJfZ91x', name: 'Clinical Malnutrition new'),
  DataElementItem(id: 'oNyB0VOXIM8', name: 'Clinical Malnutrition referrals'),
  DataElementItem(id: 'SzVk2KvkSSd', name: 'Clinical status'),
  DataElementItem(id: 'LHXqz53TmPe', name: 'CMC Clients offered information on range of methods exist'),
  DataElementItem(
      id: 'OJSkJXzhdU1',
      name: 'CMC COPE has been introduced at the facility and staff conducted a COPE exercise during the past quarter'),
  DataElementItem(
      id: 'DF0B07U2lPZ', name: 'CMC Counseling rooms in FP and CAC service units ensure client privacy and confidentiality'),
  DataElementItem(id: 'rkAZZFGFEQ7', name: 'CMC Date of clinical monitoring visit'),
  DataElementItem(id: 'wokFPoIO3NK', name: 'CMC Facility part of health care finance (HCF) board scheme'),
  DataElementItem(id: 'rTYZHPHVULr', name: 'CMC Facility receives FP referrals from community health workers'),
  DataElementItem(
      id: 'rZiGA1lv7Ah', name: 'CMC FP and CAC commodity requests correctly based on previous consumption / stock at hand'),
  DataElementItem(
      id: 'EonDTYTVXxM', name: 'CMC FP and CAC procedure rooms have adequate lighting for the performance of all procedures'),
  DataElementItem(id: 'LadMythncw2', name: 'CMC FP and CAC service units have dedicated hours or space for youth clients'),
  DataElementItem(id: 'UysSLXGhwrC', name: 'CMC FP services available - Contraceptive pills'),
  DataElementItem(id: 'ZVqZ600pgzC', name: 'CMC FP services available - Female condoms'),
  DataElementItem(id: 'X4SRfUAnrHD', name: 'CMC FP services available - Female Sterilization'),
  DataElementItem(id: 'xqlapchAEVR', name: 'CMC FP services available - Implanon'),
  DataElementItem(id: 'NKoGfjnFWcE', name: 'CMC FP services available - Injectables (DMPA)'),
  DataElementItem(id: 'XPyixxRoRFF', name: 'CMC FP services available - IUD'),
  DataElementItem(id: 'k7vxGJER2SH', name: 'CMC FP services available - Jadelle or Sino-Implant'),
  DataElementItem(id: 'FNa6RHwtpuV', name: 'CMC FP services available - Male condoms'),
  DataElementItem(id: 'dupnnRrJB9g', name: 'CMC FP services available - Male Sterilization'),
  DataElementItem(
      id: 'tY33H1Xmbiq', name: 'CMC Functioning set-up for decontamination in both FP and CAC service units exist'),
  DataElementItem(id: 'VEsHW11Ee9u', name: 'CMC IMPLANT INSERTION KITS (functional and in good condition) available'),
  DataElementItem(id: 'x7UR3a7PnFC', name: 'CMC IMPLANT REMOVAL KITS (functional and in good condition) available'),
  DataElementItem(id: 'eDO63WfftUO', name: 'CMC Incentives for staff in the FP or CAC service units to provide FP exist'),
  DataElementItem(
      id: 'e4r6eLK76M9', name: 'CMC Infection prevention protocol charts are posted in both FP and CAC service units'),
  DataElementItem(id: 'jhz73zxjuuy', name: 'CMC IUD KITS (functional and in good condition) available'),
  DataElementItem(id: 'ozL7F7k4l0S', name: 'CMC IUD REMOVAL KITS (functional and in good condition) available'),
  DataElementItem(id: 'ShRC4KSdfcw', name: 'CMC Leak-proof and puncture-proof containers in FP and CAC exist'),
  DataElementItem(id: 'W87PJK0RlJa', name: 'CMC MINILAPAROTOMY KITS (functional and in good condition) available'),
  DataElementItem(
      id: 'sjir9Ki2vuA',
      name: 'CMC Most recent delivery of FP and CAC commodities match the request made through the RRF'),
  DataElementItem(id: 'Els0dBuHtWJ', name: 'CMC MVA KITS (functional and in good condition) available'),
  DataElementItem(id: 'AX2JjzrU0oU', name: 'CMC National guidelines and standards for FP and CAC service provision available'),
  DataElementItem(id: 'KKEYwCcGvfl', name: 'CMC NSV KITS (functional and in good condition) available'),
  DataElementItem(id: 'A4R8Ns0wtJk', name: 'CMC Post-abortion FP methods provided in CAC unit - Contraceptive pills'),
  DataElementItem(id: 'H5q0J5EeytP', name: 'CMC Post-abortion FP methods provided in CAC unit - Female condoms'),
  DataElementItem(id: 'lLl7dD5jRhg', name: 'CMC Post-abortion FP methods provided in CAC unit - Implanon'),
  DataElementItem(id: 'R8X9WHD6Ta9', name: 'CMC Post-abortion FP methods provided in CAC unit - Injectables (DMPA)'),
  DataElementItem(id: 'J6KG9poh1WL', name: 'CMC Post-abortion FP methods provided in CAC unit - IUD'),
  DataElementItem(id: 'HcQqfCPHC79', name: 'CMC Post-abortion FP methods provided in CAC unit - Jadelle or Sino-Implant'),
  DataElementItem(id: 'MqeQ222wxN8', name: 'CMC Post-abortion FP methods provided in CAC unit - Male condoms'),
  DataElementItem(id: 'otxWZ2s0Iyg', name: 'CMC Post-abortion FP methods provided in CAC unit - Other (specify)'),
];

const List<DistrictOrgUnit> kMockDistricts = [
  DistrictOrgUnit(
    id: 'O6uvpzGd5pu',
    name: 'Bo',
    latitude: 7.964,
    longitude: -11.738,
    facilities: [
      OrgUnitItem(id: 'Y8foq27WLti', name: 'Baoma Oil Mill CHC'),
      OrgUnitItem(id: 'x8SUTSsJoeO', name: 'Baoma-Peje CHP'),
      OrgUnitItem(id: 'jNb63DIHuwU', name: 'Baoma Station CHP'),
      OrgUnitItem(id: 'QIp6DHlMGfb', name: 'Baptist Centre Kassirie'),
      OrgUnitItem(id: 'weLTzWrLXCO', name: 'Bapuya MCHP'),
      OrgUnitItem(id: 'eLLMnNjuluX', name: 'Barakuya MCHP'),
      OrgUnitItem(id: 'dGheVylzol6', name: 'Bargbe'),
      OrgUnitItem(id: 'zFDYIgyGmXG', name: 'Bargbo'),
      OrgUnitItem(id: 'y5hLlID8ihI', name: 'Barlie MCHP'),
      OrgUnitItem(id: 'XkA2vbJAWHG', name: 'Barmoi CHP'),
      OrgUnitItem(id: 'vyIl6s0lhKc', name: 'Barmoi Luma MCHP'),
      OrgUnitItem(id: 'vELaJEPLOPF', name: 'Barmoi Munu CHP'),
      OrgUnitItem(id: 'RzKeCma9qb1', name: 'Barri'),
      OrgUnitItem(id: 'tlvNeDXXrS7', name: 'Bassia MCHP'),
      OrgUnitItem(id: 'sDTodaygv5u', name: 'Bath Bana MCHP'),
      OrgUnitItem(id: 'UGVLYrO63mR', name: 'Bathurst MCHP'),
      OrgUnitItem(id: 'agM0BKQlTh3', name: 'Batkanu CHC'),
      OrgUnitItem(id: 'iMZihUMzH92', name: 'Bauya (Kongbora) CHC'),
      OrgUnitItem(id: 'cUNdCErxl9g', name: 'Bayama (K. Teng) MCHP'),
      OrgUnitItem(id: 'k92yudERPlv', name: 'Bayama MCHP'),
      OrgUnitItem(id: 'PwgoRuWEDvJ', name: 'Belebu CHP'),
      OrgUnitItem(id: 'qusWt6sESRU', name: 'Belentin MCHP'),
      OrgUnitItem(id: 'VpYAl8dXs6m', name: 'Bendoma (Malegohun) MCHP'),
      OrgUnitItem(id: 'EB1zRKdYjdY', name: 'Bendu Cha'),
    ],
  ),
  DistrictOrgUnit(
    id: 'fdc6uOvgoji',
    name: 'Bombali',
    latitude: 8.887,
    longitude: -12.045,
    facilities: [
      OrgUnitItem(id: 'uFp0ztDOFbI', name: 'Bendu CHC'),
      OrgUnitItem(id: 'o0BgK1dLhF8', name: 'Bendugu CHC'),
      OrgUnitItem(id: 'PMsF64R6OJX', name: 'Bendugu (Mongo) CHC'),
      OrgUnitItem(id: 'er9S4CQ9QOn', name: 'Bendu (Kowa) MCHP'),
      OrgUnitItem(id: 'n7wN9gMFfZ5', name: 'Benduma CHC'),
      OrgUnitItem(id: 'Wr8kmywwseZ', name: 'Benduma MCHP'),
      OrgUnitItem(id: 'amgb83zVxp5', name: 'Bendu Mameima CHC'),
      OrgUnitItem(id: 'DQHGtTGOP6b', name: 'Bendu (Yawei) CHP'),
      OrgUnitItem(id: 'yDFM5J6WeKU', name: 'Bengani MCHP'),
      OrgUnitItem(id: 'iPcreOldeV9', name: 'Benguema MI Room'),
      OrgUnitItem(id: 'ZKL5hlVG6F6', name: 'Benguima Grassfield MCHP'),
      OrgUnitItem(id: 'wQ71REGAMet', name: 'Benkeh MCHP'),
      OrgUnitItem(id: 'OcRCVRy2M7X', name: 'Benkia MCHP'),
      OrgUnitItem(id: 'GHHvGp7tgtZ', name: 'Binkolo CHC'),
      OrgUnitItem(id: 'fwH9ipvXde9', name: 'Biriwa'),
      OrgUnitItem(id: 'kUzpbgPCwVA', name: 'Blama CHC'),
      OrgUnitItem(id: 'xXhKbgwL39t', name: 'Blama Massaquoi CHP'),
      OrgUnitItem(id: 'WAjjFMDJKcx', name: 'Blamawo MCHP'),
      OrgUnitItem(id: 'kBP1UvZpsNj', name: 'Blessed Mokaba clinic'),
      OrgUnitItem(id: 'lPeZdUm9fD7', name: 'Blessed Mokaba East'),
      OrgUnitItem(id: 'waNtxFbPjrI', name: 'Blessed Mokaka East Clinic'),
      OrgUnitItem(id: 'ENHOJz3UH5L', name: 'BMC'),
      OrgUnitItem(id: 'L5gENbBNNup', name: 'Boajibu CHC'),
      OrgUnitItem(id: 'rZxk3S0qN63', name: 'Bo Govt. Hosp.'),
    ],
  ),
  DistrictOrgUnit(
    id: 'lc3eMKXaEfw',
    name: 'Bonthe',
    latitude: 7.526,
    longitude: -12.505,
    facilities: [
      OrgUnitItem(id: 'D6yiaX1K5sO', name: 'Bomaru CHP'),
      OrgUnitItem(id: 'KKkLOTpMXGV', name: 'Bombali Sebora'),
      OrgUnitItem(id: 'PB8FMGbn19r', name: 'Bombohun MCHP'),
      OrgUnitItem(id: 'YQYgz8exK9S', name: 'Bombordu MCHP'),
      OrgUnitItem(id: 'VXrJKs8hic4', name: 'Bomie MCHP'),
      OrgUnitItem(id: 'H97XE5Ea089', name: 'Bomotoke CHC'),
      OrgUnitItem(id: 'aVlSMMvgVzf', name: 'Bomu Saamba CHP'),
      OrgUnitItem(id: 'zAyK28LLaez', name: 'Bongor MCHP'),
      OrgUnitItem(id: 'IcVHzEm0b6Z', name: 'Bonkababay MCHP'),
      OrgUnitItem(id: 'VfZnZ6UKyn8', name: 'Bontiwo MCHP'),
      OrgUnitItem(id: 'uYG1rUdsJJi', name: 'Borma (YKK) MCHP'),
      OrgUnitItem(id: 'szbAJSWOXjT', name: 'Boroma MCHP'),
      OrgUnitItem(id: 'cZZG5BMDLps', name: 'Borongoh Makarankay CHP'),
      OrgUnitItem(id: 'GRc9WXp9gSy', name: 'Bradford CHC'),
      OrgUnitItem(id: 'kbPmt60yi0L', name: 'Bramaia'),
      OrgUnitItem(id: 'vRC0stJ5y9Q', name: 'Bucksal Clinic'),
      OrgUnitItem(id: 'tO01bqIipeD', name: 'Buedu CHC'),
      OrgUnitItem(id: 'iUauWFeH8Qp', name: 'Bum'),
      OrgUnitItem(id: 'AXZq6q7Dr6E', name: 'Buma MCHP'),
      OrgUnitItem(id: 'LZclRdyVk1t', name: 'Bumbanday MCHP'),
      OrgUnitItem(id: 'OI0BQUurVFS', name: 'Bumban MCHP'),
      OrgUnitItem(id: 'DwpbWkiqjMy', name: 'Bumbeh MCHP'),
      OrgUnitItem(id: 'MwfWgjMRgId', name: 'Bumbukoro MCHP'),
      OrgUnitItem(id: 'Q2USZSJmcNK', name: 'Bumbuna CHC'),
    ],
  ),
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
  final List<DistrictOrgUnit> _districts = kMockDistricts;

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

  /// Flat lookup of every facility across all districts, keyed by id.
  Iterable<OrgUnitItem> get _allFacilities => _districts.expand((d) => d.facilities);

  /// Finds which district a facility belongs to (used to attach coordinates).
  DistrictOrgUnit _districtOf(String facilityId) =>
      _districts.firstWhere((d) => d.facilities.any((f) => f.id == facilityId));

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
    final maxHeight = (screenHeight - offset.dy - size.height - 40).clamp(240.0, 460.0);

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
      contentBuilder: (_) => _OrgUnitSelectPanel(
        districts: _districts,
        selectedIds: _selectedOrgUnitIds,
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
      return _allFacilities.firstWhere((e) => e.id == _selectedOrgUnitIds.first).name;
    }
    return '${_selectedOrgUnitIds.length} facilities selected';
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

    // Facility-level coordinates aren't in the source metadata, so we use
    // the parent district's coordinates as a stand-in for map rendering.
    // Swap this for real facility lat/lng once available.
    final locations = query.orgUnitIds.map((id) {
      final facility = _allFacilities.firstWhere((e) => e.id == id);
      final district = _districtOf(id);
      return {
        'name': facility.name,
        'latitude': district.latitude,
        'longitude': district.longitude,
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
        padding: const EdgeInsets.only(left: 2, right: 2, top: 12, bottom: 8),
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
              Padding(
                padding: const EdgeInsets.all(4),
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

/// Searchable checkbox list used for the data-element selector (DHIS2
/// analytics accepts multiple `dx` values).
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

/// Two-level organisation unit selector: pick a district, then pick one or
/// more facilities within it — same "category -> item" shape as the period
/// selector, but with multi-select checkboxes at the leaf level plus a
/// "select all in district" shortcut. Selections persist across districts,
/// so you can pick facilities in Bo, go back, then add more in Bombali.
class _OrgUnitSelectPanel extends StatefulWidget {
  final List<DistrictOrgUnit> districts;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final VoidCallback onDone;

  const _OrgUnitSelectPanel({
    required this.districts,
    required this.selectedIds,
    required this.onChanged,
    required this.onDone,
  });

  @override
  State<_OrgUnitSelectPanel> createState() => _OrgUnitSelectPanelState();
}

class _OrgUnitSelectPanelState extends State<_OrgUnitSelectPanel> {
  DistrictOrgUnit? _activeDistrict;
  late Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.of(widget.selectedIds);
  }

  int _selectedCountIn(DistrictOrgUnit d) => d.facilities.where((f) => _selected.contains(f.id)).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: _activeDistrict == null ? _districtList() : _facilityList(_activeDistrict!),
    );
  }

  Widget _districtList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('Select a district', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.districts.length,
            itemBuilder: (context, index) {
              final d = widget.districts[index];
              final count = _selectedCountIn(d);
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: count > 0 ? kBrandColor : Colors.grey.shade200,
                  child: Icon(Icons.location_city, size: 16, color: count > 0 ? Colors.white : Colors.grey),
                ),
                title: Text(d.name),
                subtitle: count > 0 ? Text('$count selected') : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => setState(() => _activeDistrict = d),
              );
            },
          ),
        ),
        const Divider(height: 16),
        _footer(),
      ],
    );
  }

  Widget _facilityList(DistrictOrgUnit district) {
    final filtered =
        district.facilities.where((f) => f.name.toLowerCase().contains(_query.toLowerCase())).toList();
    final allSelected = district.facilities.isNotEmpty && district.facilities.every((f) => _selected.contains(f.id));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: kBrandColor,
              onPressed: () => setState(() {
                _activeDistrict = null;
                _query = '';
              }),
            ),
            Expanded(child: Text(district.name, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search facilities...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        CheckboxListTile(
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: kBrandColor,
          title: Text('Select all in ${district.name}', style: const TextStyle(fontWeight: FontWeight.w500)),
          value: allSelected,
          onChanged: (v) {
            setState(() {
              for (final f in district.facilities) {
                if (v == true) {
                  _selected.add(f.id);
                } else {
                  _selected.remove(f.id);
                }
              }
            });
            widget.onChanged(_selected);
          },
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final f = filtered[index];
              final checked = _selected.contains(f.id);
              return CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: kBrandColor,
                title: Text(f.name),
                value: checked,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selected.add(f.id);
                    } else {
                      _selected.remove(f.id);
                    }
                  });
                  widget.onChanged(_selected);
                },
              );
            },
          ),
        ),
        const Divider(height: 16),
        _footer(),
      ],
    );
  }

  Widget _footer() {
    return Row(
      children: [
        Text('${_selected.length} unit(s) selected', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const Spacer(),
        TextButton(
          onPressed: widget.onDone,
          style: TextButton.styleFrom(foregroundColor: kBrandColor),
          child: const Text('Done'),
        ),
      ],
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