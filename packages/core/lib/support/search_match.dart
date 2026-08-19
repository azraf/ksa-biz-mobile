/// Client-side twin of the backend `SearchTerms` helper: whitespace tokens,
/// AND across tokens, OR across fields, case-insensitive substring, Arabic
/// folding, and a "most likely" fuzzy fallback for offline lists.
class SearchMatch {
  SearchMatch._();

  static final _harakat = RegExp('[ً-ْـ]');
  static const _fold = {'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ة': 'ه', 'ى': 'ي'};

  static String normalize(String s) {
    var out = s.toLowerCase().replaceAll(_harakat, '');
    _fold.forEach((k, v) => out = out.replaceAll(k, v));
    return out;
  }

  static List<String> tokens(String raw) =>
      raw.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

  /// Every token must appear (substring) in at least one field.
  static bool matches(String query, Iterable<String?> fields) {
    final toks = tokens(query).map(normalize).toList();
    if (toks.isEmpty) return true;
    final texts = fields.whereType<String>().map(normalize).toList();
    return toks.every((t) => texts.any((f) => f.contains(t)));
  }

  /// Sum of per-token best distances, or null when some token is nowhere near.
  static int? fuzzyScore(String query, Iterable<String?> fields) {
    final toks = tokens(query).map(normalize).toList();
    if (toks.isEmpty) return 0;
    final words = fields
        .whereType<String>()
        .expand((f) => normalize(f).split(RegExp(r'[\s,;:.()/\-]+')))
        .where((w) => w.isNotEmpty)
        .toList();
    var total = 0;
    for (final t in toks) {
      int? best;
      for (final w in words) {
        final d = _score(t, w);
        if (d != null && (best == null || d < best)) best = d;
      }
      if (best == null) return null;
      total += best;
    }
    return total;
  }

  /// Exact filter, falling back to fuzzy (best first, capped) when exact is
  /// empty. `isFuzzy` is false when fuzzy also found nothing.
  static ({List<T> items, bool isFuzzy}) filterOrFuzzy<T>(
    List<T> items,
    String query,
    Iterable<String?> Function(T) fields, {
    int limit = 50,
  }) {
    if (tokens(query).isEmpty) return (items: items, isFuzzy: false);
    final exact = items.where((i) => matches(query, fields(i))).toList();
    if (exact.isNotEmpty) return (items: exact, isFuzzy: false);
    final scored = <(T, int)>[];
    for (final i in items) {
      final s = fuzzyScore(query, fields(i));
      if (s != null) scored.add((i, s));
    }
    if (scored.isEmpty) return (items: const [], isFuzzy: false);
    scored.sort((a, b) => a.$2.compareTo(b.$2));
    return (items: scored.take(limit).map((e) => e.$1).toList(), isFuzzy: true);
  }

  static int? _score(String t, String w) {
    if (w.contains(t)) return 0;
    if (t.length >= 3 && w.startsWith(t)) return 0;
    final cut = w.length > t.length ? w.substring(0, t.length) : w;
    final d = _min(_levenshtein(t, w), _levenshtein(t, cut));
    final threshold = t.length ~/ 4 < 1 ? 1 : t.length ~/ 4;
    return d <= threshold ? d : null;
  }

  static int _min(int a, int b) => a < b ? a : b;

  static int _levenshtein(String a, String b) {
    final ac = a.codeUnits, bc = b.codeUnits;
    var prev = List<int>.generate(bc.length + 1, (j) => j);
    for (var i = 0; i < ac.length; i++) {
      final cur = List<int>.filled(bc.length + 1, 0)..[0] = i + 1;
      for (var j = 0; j < bc.length; j++) {
        final cost = ac[i] == bc[j] ? 0 : 1;
        cur[j + 1] = _min(_min(prev[j + 1] + 1, cur[j] + 1), prev[j] + cost);
      }
      prev = cur;
    }
    return prev[bc.length];
  }
}
