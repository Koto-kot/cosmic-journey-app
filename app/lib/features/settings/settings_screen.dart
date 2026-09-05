import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../app/app_dependencies.dart';
import '../../app/readout_mode_controller.dart';
import '../../core/readout/readout_mode.dart';
import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/time/approximate_birth.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../core/widgets/language_switcher.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../journey/journey_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.dependencies,
    required this.profile,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentYear = widget.dependencies.clock.now().year;
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                    const Spacer(),
                    LanguageSwitcher(
                      controller: widget.dependencies.localeController,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: Text(
                    l10n.settingsTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
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
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 16),
                    children: [
                      _ReadoutModePicker(
                        controller: widget.dependencies.readoutModeController,
                      ),
                      const SizedBox(height: 20),
                      _OptionalDropdown<int>(
                        label: l10n.birthMonthLabel,
                        value: _month,
                        unsetLabel: l10n.monthNotSet,
                        items: [
                          for (var month = 1; month <= 12; month++)
                            (month, _monthLabel(context, month)),
                        ],
                        onChanged: (month) {
                          setState(() {
                            _month = month;
                            if (month == null) {
                              _day = null;
                              _time = null;
                            } else if (_day != null &&
                                _day! > _daysInSelectedMonth) {
                              _day = _daysInSelectedMonth;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _OptionalDropdown<int>(
                        label: l10n.birthDayLabel,
                        value: _month == null ? null : _day,
                        unsetLabel: l10n.dayNotSet,
                        enabled: _month != null,
                        items: [
                          for (var day = 1; day <= _daysInSelectedMonth; day++)
                            (day, '$day'),
                        ],
                        onChanged: (day) => setState(() => _day = day),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.birthTimeLabel,
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
                            child: OutlinedButton(
                              onPressed: _month == null
                                  ? null
                                  : () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            _time ??
                                            const TimeOfDay(
                                              hour: 12,
                                              minute: 0,
                                            ),
                                      );
                                      if (picked != null) {
                                        setState(() => _time = picked);
                                      }
                                    },
                              child: Text(
                                _time == null
                                    ? l10n.timeNotSet
                                    : _time!.format(context),
                              ),
                            ),
                          ),
                          if (_time != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: l10n.clearOptional,
                              onPressed: () => setState(() => _time = null),
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
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
        ),
      ),
    );
  }
}

class _ReadoutModePicker extends StatelessWidget {
  const _ReadoutModePicker({required this.controller});

  final ReadoutModeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.readoutModeLabel,
              style: TextStyle(
                color: CosmicTokens.muted,
                letterSpacing: 1.4,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            _ReadoutModeTile(
              title: l10n.readoutPulse,
              subtitle: l10n.readoutPulseHint,
              selected: controller.mode == ReadoutMode.pulse,
              icon: Icons.radio_button_checked,
              onTap: () => controller.setMode(ReadoutMode.pulse),
            ),
            const SizedBox(height: 8),
            _ReadoutModeTile(
              title: l10n.readoutFlow,
              subtitle: l10n.readoutFlowHint,
              selected: controller.mode == ReadoutMode.flow,
              icon: Icons.waves,
              onTap: () => controller.setMode(ReadoutMode.flow),
            ),
          ],
        );
      },
    );
  }
}

class _ReadoutModeTile extends StatelessWidget {
  const _ReadoutModeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? CosmicTokens.accent : CosmicTokens.cardStroke,
            ),
            color: CosmicTokens.card,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? CosmicTokens.accent : CosmicTokens.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: CosmicTokens.muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check, color: CosmicTokens.accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionalDropdown<T> extends StatelessWidget {
  const _OptionalDropdown({
    required this.label,
    required this.value,
    required this.unsetLabel,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final String unsetLabel;
  final List<(T, String)> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;

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
        DropdownButtonFormField<T>(
          // ignore: deprecated_member_use
          value: enabled ? value : null,
          isExpanded: true,
          dropdownColor: CosmicTokens.surface,
          decoration: InputDecoration(
            enabled: enabled,
            filled: true,
            fillColor: CosmicTokens.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: CosmicTokens.cardStroke),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: CosmicTokens.cardStroke),
            ),
          ),
          items: [
            DropdownMenuItem<T>(value: null, child: Text(unsetLabel)),
            for (final item in items)
              DropdownMenuItem<T>(value: item.$1, child: Text(item.$2)),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
