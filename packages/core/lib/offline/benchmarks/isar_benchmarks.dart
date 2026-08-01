import '../isar_service.dart';
import '../offline_stores.dart';

class BenchmarkResult {
  const BenchmarkResult({required this.name, required this.durationMs, this.note});

  final String name;
  final int durationMs;
  final String? note;

  @override
  String toString() => '$name: ${durationMs}ms${note != null ? ' ($note)' : ''}';
}

class IsarBenchmarks {
  IsarBenchmarks(this._stores);

  final OfflineStores _stores;

  static Future<List<BenchmarkResult>> runAll(OfflineStores stores) async {
    final bench = IsarBenchmarks(stores);
    return [
      await bench.customerSearch(),
      await bench.productSearch(),
      await bench.orderListPage(),
      await bench.pendingCount(),
      await bench.coldOpen(),
    ];
  }

  Future<BenchmarkResult> customerSearch({String query = 'shop'}) async {
    final sw = Stopwatch()..start();
    await _stores.customers.searchShops(query: query, limit: 50);
    sw.stop();
    return BenchmarkResult(name: 'customer_search', durationMs: sw.elapsedMilliseconds);
  }

  Future<BenchmarkResult> productSearch({String query = 'a'}) async {
    final sw = Stopwatch()..start();
    await _stores.catalog.search(query: query, limit: 50);
    sw.stop();
    return BenchmarkResult(name: 'product_search', durationMs: sw.elapsedMilliseconds);
  }

  Future<BenchmarkResult> orderListPage() async {
    final sw = Stopwatch()..start();
    await _stores.orders.list(offset: 0, limit: 25);
    sw.stop();
    return BenchmarkResult(name: 'order_list_page_1', durationMs: sw.elapsedMilliseconds);
  }

  Future<BenchmarkResult> pendingCount() async {
    final sw = Stopwatch()..start();
    await _stores.outbox.pendingCount();
    sw.stop();
    return BenchmarkResult(name: 'pending_count', durationMs: sw.elapsedMilliseconds);
  }

  Future<BenchmarkResult> coldOpen() async {
    final sw = Stopwatch()..start();
    await IsarService.instance.open();
    sw.stop();
    return BenchmarkResult(name: 'db_open', durationMs: sw.elapsedMilliseconds, note: 'warm if already open');
  }
}
