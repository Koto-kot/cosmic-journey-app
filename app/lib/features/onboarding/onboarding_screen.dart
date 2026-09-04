import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';

import '../../app/app_dependencies.dart';
import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/time/approximate_birth.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../journey/journey_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const int _itemExtent = 48;

  late final int _currentYear;
  late final List<int> _years;
  late final FixedExtentScrollController _controller;
  late int _selectedYear;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.dependencies.clock.now().year;
    final first = ScienceConstants.earliestSupportedBirthYear;
    _years = [for (var year = first; year <= _currentYear; year++) year];
    final defaultYear = (_currentYear - 30).clamp(first, _currentYear);
    _selectedYear = defaultYear;
    _controller = FixedExtentScrollController(
      initialItem: _years.indexOf(defaultYear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _begin() async {
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
    Navigator.of(context).pushReplacement(
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
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              CosmicTokens.pagePadding,
              32,
              CosmicTokens.pagePadding,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  l10n.whenDidJourneyBegin,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: CosmicTokens.onBackground,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.birthYearLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: CosmicTokens.muted,
                    letterSpacing: 1.4,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: _itemExtent.toDouble(),
                        decoration: BoxDecoration(
                          color: CosmicTokens.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CosmicTokens.hairline),
                        ),
                      ),
                      ListWheelScrollView.useDelegate(
                        controller: _controller,
                        itemExtent: _itemExtent.toDouble(),
                        physics: const FixedExtentScrollPhysics(),
                        perspective: 0.003,
                        diameterRatio: 1.6,
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
                                  fontSize: selected ? 28 : 20,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
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
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.privacyNote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: CosmicTokens.muted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed:
                      _saving ||
                          !ApproximateBirth.isSupportedYear(
                            _selectedYear,
                            _currentYear,
                          )
                      ? null
                      : _begin,
                  child: Text(l10n.beginJourney),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
