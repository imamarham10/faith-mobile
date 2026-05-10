/// Distinguishes the two name collections wired to `/api/v1/islam/names/*`.
enum NamesKind {
  /// 99 Names of Allah — `/api/v1/islam/names/allah`.
  allah,

  /// 99 Names of Muhammad ﷺ — `/api/v1/islam/names/muhammad`.
  muhammad;

  /// Used in route paths and storage keys.
  String get slug => switch (this) {
    NamesKind.allah => 'allah',
    NamesKind.muhammad => 'muhammad',
  };

  String get title => switch (this) {
    NamesKind.allah => 'Allah',
    NamesKind.muhammad => 'Muhammad ﷺ',
  };

  static NamesKind fromSlug(String slug) => switch (slug) {
    'muhammad' => NamesKind.muhammad,
    _ => NamesKind.allah,
  };
}
