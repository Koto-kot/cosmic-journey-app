enum ReadoutMode {
  /// Integer km and seconds, once per second.
  pulse,

  /// Fractional km and seconds, updated every frame.
  flow,
}

extension ReadoutModeCodec on ReadoutMode {
  static const pulseId = 'pulse';
  static const flowId = 'flow';

  String get id => switch (this) {
    ReadoutMode.pulse => pulseId,
    ReadoutMode.flow => flowId,
  };

  static ReadoutMode resolve(String? id) {
    if (id == flowId) {
      return ReadoutMode.flow;
    }
    return ReadoutMode.pulse;
  }
}
