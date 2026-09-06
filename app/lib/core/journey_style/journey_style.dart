/// Interface style: the composition of the main journey screen, distinct
/// from [CosmicPalette] which only carries color tokens. See ADR 0010 — the
/// two axes are independent (Shuttle Cockpit is not "another palette").
enum JourneyStyle {
  /// Current main screen: Earth visual, three counters, minimalist.
  cosmicMinimal,

  /// Captain's-seat cockpit view: panoramic window, DISTANCE + FLIGHT TIME
  /// panels.
  shuttleCockpit,
}

extension JourneyStyleCodec on JourneyStyle {
  static const cosmicMinimalId = 'cosmic_minimal';
  static const shuttleCockpitId = 'shuttle_cockpit';

  String get id => switch (this) {
    JourneyStyle.cosmicMinimal => cosmicMinimalId,
    JourneyStyle.shuttleCockpit => shuttleCockpitId,
  };

  static JourneyStyle resolve(String? id) {
    if (id == shuttleCockpitId) {
      return JourneyStyle.shuttleCockpit;
    }
    return JourneyStyle.cosmicMinimal;
  }
}
