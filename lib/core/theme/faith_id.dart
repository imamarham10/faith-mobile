/// The two faiths Siraat currently supports. Adding a third faith later is
/// "add a value here + a FaithPalette entry", not a nav/route rework.
enum FaithId {
  islam,
  hindu;

  static FaithId? fromName(String? name) {
    for (final f in FaithId.values) {
      if (f.name == name) return f;
    }
    return null;
  }
}

/// Human-readable display label for each faith — the single source of truth
/// shared by the faith picker, settings, and app-shell nav.
extension FaithIdLabel on FaithId {
  String get label => switch (this) {
    FaithId.islam => 'Islam',
    FaithId.hindu => 'Hindu',
  };
}
