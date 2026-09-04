import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_dependencies.dart';
import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/time/approximate_birth.dart';
import '../../core/widgets/cosmic_backdrop.dart';
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
    _controller = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final now = widget.dependencies.clock.now();
    final profile = JourneyProfile.approximateYear(
      year: _selectedYear,
      nowUtc: now,
      localOffset: DateTime.now().timeZoneOffset,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
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
                    l10n.birthYearLabel,
                    style: const TextStyle(
                      color: CosmicTokens.muted,
                      letterSpacing: 1.4,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 44,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedYear = _years[index]);
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: FilledButton(
                    onPressed:
                        _saving ||
                            !ApproximateBirth.isSupportedYear(
                              _selectedYear,
                              currentYear,
                            )
                        ? null
                        : _save,
                    child: Text(l10n.saveBirthYear),
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
