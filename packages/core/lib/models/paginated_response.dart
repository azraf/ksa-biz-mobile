import '../support/json_parse.dart';

class PaginatedResponse<T> {
  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.searchMode = 'exact',
  });

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  /// 'exact' | 'fuzzy' — the server fell back to "most likely" matches.
  final String searchMode;

  bool get hasMore => currentPage < lastPage;
  bool get isFuzzy => searchMode == 'fuzzy';

  static PaginatedResponse<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] as List<dynamic>? ?? [];
    return PaginatedResponse<T>(
      items: data.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      currentPage: parseJsonInt(json['current_page'], fallback: 1),
      lastPage: parseJsonInt(json['last_page'], fallback: 1),
      total: parseJsonInt(json['total'], fallback: data.length),
      searchMode: json['search_mode'] as String? ?? 'exact',
    );
  }
}
