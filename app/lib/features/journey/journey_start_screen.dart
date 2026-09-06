import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../app/app_dependencies.dart';
import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/time/approximate_birth.dart';
import '../../core/widgets/language_switcher.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../../services/journey_calculator/journey_profile.dart';
import 'journey_screen.dart';

/// Dedicated screen for editing journey-start precision (year, optional
/// month/day/time). Split out of Settings so birth data has its own menu
/// entry ("Journey Start") per the Codex additional instructions.
class JourneyStartScreen extends StatefulWidget {
  const JourneyStartScreen({
    super.key,
    required this.dependencies,
    required this.profile,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;

  @override
  State<JourneyStartScreen> createState() => _JourneyStartScreenState();
}

class _JourneyStartScreenState extends State<JourneyStartScreen> {
  late int _selectedYear;
  late final List<int> _years;
  late final FixedExtentScrollController _controller;
  int? _month;
  int? _day;
  TimeOfDay? _time;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final currentYear = widget.dependencies.clock.now().year;
    _years = [
      for (
        var year = ScienceConstants.earliestSupportedBirthYear;
        year <= currentYear;
        year++
      )
        year,
    ];
    _selectedYear = widget.profile.birthYear.clamp(
      ScienceConstants.earliestSupportedBirthYear,
      currentYear,
    );
    _month = widget.profile.birthMonth;
    _day = widget.profile.birthDay;
    if (widget.profile.hasTime) {
      _time = TimeOfDay(
        hour: widget.profile.birthHour!,
        minute: widget.profile.birthMinute!,
      );
    }
    _controller = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _daysInSelectedMonth {
    if (_month == null) {
      return 31;
    }
    return ApproximateBirth.daysInMonth(_selectedYear, _month!);
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final now = widget.dependencies.clock.now();
    final profile = JourneyProfile.fromParts(
      year: _selectedYear,
      month: _month,
      day: _month == null ? null : _day,
      hour: _month == null ? null : _time?.hour,
      minute: _month == null ? null : _time?.minute,
      nowUtc: now,
      localOffset: DateTime.now().timeZoneOffset,
      createdAt: widget.profile.createdAt,
    );
    await widget.dependencies.profileStore.save(profile);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondary) {
          return FadeTransition(
            opacity: animation,
            child: JourneyScreen(
              dependencies: widget.dependencies,
              profile: profile,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
      (route) => false,
    );
  }

  String _monthLabel(BuildContext context, int month) {
    return DateFormat.MMMM(Localizations.localeOf(context).toString())
        .format(DateTime(2000, month));
  }

  // Bottom-sheet row lists return this instead of null on tap, so a picker
  // dismissed via the back gesture/scrim (which resolves the future with
  // null) can be told apart from the user explicitly choosing "not set".
  static const _notSet = -1;

  Future<void> _pickMonth() async {
    final l10n = AppLocalizations.of(context);
    final picked = await _showRowPicker(
      title: l10n.birthMonthLabel,
      selected: _month ?? _notSet,
      options: [
        (_notSet, l10n.monthNotSet),
        for (var month = 1; month <= 12; month++)
          (month, _monthLabel(context, month)),
      ],
    );
    if (picked == null) {
      return;
    }
    final month = picked == _notSet ? null : picked;
    setState(() {
      _month = month;
      if (month == null) {
        _day = null;
        _time = null;
      } else if (_day != null && _day! > _daysInSelectedMonth) {
        _day = _daysInSelectedMonth;
      }
    });
  }

  Future<void> _pickDay() async {
    if (_month == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final picked = await _showRowPicker(
      title: l10n.birthDayLabel,
      selected: _day ?? _notSet,
      options: [
        (_notSet, l10n.dayNotSet),
        for (var day = 1; day <= _daysInSelectedMonth; day++) (day, '$day'),
      ],
    );
    if (picked == null) {
      return;
    }
    setState(() => _day = picked == _notSet ? null : picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<int?> _showRowPicker({
    required String title,
    required int selected,
    required List<(int, String)> options,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: CosmicTokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final (value, text) = options[index];
                      final isSelected = value == selected;
                      return ListTile(
                        title: Text(
                          text,
                          style: TextStyle(
                            color: isSelected
                                ? CosmicTokens.accent
                                : CosmicTokens.onBackground,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: CosmicTokens.accent)
                            : null,
                        onTap: () => Navigator.of(sheetContext).pop(value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentYear = widget.dependencies.clock.now().year;
    return SecondaryScaffold(
      title: l10n.journeyStartTitle,
      trailing: LanguageSwitcher(
        controller: widget.dependencies.localeController,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.birthPrecisionHint,
                style: TextStyle(
                  color: CosmicTokens.muted,
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.birthYearLabel,
                style: TextStyle(
                  color: CosmicTokens.muted,
                  letterSpacing: 1.4,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 44,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedYear = _years[index];
                    if (_day != null && _day! > _daysInSelectedMonth) {
                      _day = _daysInSelectedMonth;
                    }
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _years.length,
                  builder: (context, index) {
                    final year = _years[index];
                    final selected = year == _selectedYear;
                    return Center(
                      child: Text(
                        '$year',
                        style: TextStyle(
                          fontSize: selected ? 26 : 18,
                          color: selected
                              ? CosmicTokens.onBackground
                              : CosmicTokens.muted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _BirthFieldRow(
                    label: l10n.birthMonthLabel,
                    valueText: _month == null
                        ? l10n.monthNotSet
                        : _monthLabel(context, _month!),
                    isSet: _month != null,
                    onTap: _pickMonth,
                    onClear: _month == null
                        ? null
                        : () => setState(() {
                            _month = null;
                            _day = null;
                            _time = null;
                          }),
                  ),
                  const SizedBox(height: 12),
                  _BirthFieldRow(
                    label: l10n.birthDayLabel,
                    valueText: _month == null
                        ? l10n.dayNotSet
                        : (_day == null ? l10n.dayNotSet : '$_day'),
                    isSet: _month != null && _day != null,
                    enabled: _month != null,
                    onTap: _pickDay,
                    onClear: _day == null
                        ? null
                        : () => setState(() => _day = null),
                  ),
                  const SizedBox(height: 12),
                  _BirthFieldRow(
                    label: l10n.birthTimeLabel,
                    valueText: _time == null
                        ? l10n.timeNotSet
                        : _time!.format(context),
                    isSet: _time != null,
                    enabled: _month != null,
                    onTap: _pickTime,
                    onClear: _time == null
                        ? null
                        : () => setState(() => _time = null),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilledButton(
                onPressed:
                    _saving ||
                        !ApproximateBirth.isSupportedYear(
                          _selectedYear,
                          currentYear,
                        )
                    ? null
                    : _save,
                child: Text(l10n.saveBirthDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable row for an optional birth field (month/day/time):
/// label above, current value (or its "not set" placeholder) with a
/// chevron below, opening a picker on tap — replaces the old
/// `DropdownButtonFormField`, whose floating overlay menu read as broken
/// on narrow/web layouts.
class _BirthFieldRow extends StatelessWidget {
  const _BirthFieldRow({
    required this.label,
    required this.valueText,
    required this.isSet,
    required this.onTap,
    this.onClear,
    this.enabled = true,
  });

  final String label;
  final String valueText;
  final bool isSet;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CosmicTokens.muted,
            letterSpacing: 1.4,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? onTap : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: CosmicTokens.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CosmicTokens.cardStroke),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            valueText,
                            style: TextStyle(
                              color: !enabled || !isSet
                                  ? CosmicTokens.muted
                                  : CosmicTokens.onBackground,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: CosmicTokens.muted,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: AppLocalizations.of(context).clearOptional,
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
