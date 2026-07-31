enum MediaKind {
  image,
  audio,
  video;

  String get value => name;

  static MediaKind? fromString(String? value) {
    if (value == null) return null;
    for (final kind in MediaKind.values) {
      if (kind.name == value) return kind;
    }
    return null;
  }
}
