# Isar offline benchmarks (ksa-mobileapp-v2)

Debug harness:

- **sales_app:** Profile → Isar benchmarks (`kDebugMode`)
- **admin_app:** More → Isar benchmarks (`kDebugMode`)

Implementation: `packages/core/lib/offline/benchmarks/isar_benchmarks.dart`

## Targets

| Scenario | Dataset | Target |
|----------|---------|--------|
| Customer search | 1000 shops | < 50 ms per query |
| Product search | 2000 SKUs | < 50 ms per query |
| Prefetch batch write | 500 products | single `writeTxn` |
| Order list page 1 | 200 orders | < 30 ms |
| Pending count | 50 queue items | instant stream update |
| Cold DB open | 5k entities | < 200 ms |
| Dashboard load | online | parallel fetch faster than sequential |
| Admin list cache read | users/brands list | < 30 ms |
| Sync auto-trigger | online local save | upload within ~2 s |

## How to run

1. `cd sales_app && flutter run` (debug).
2. Sign in, open **Profile**.
3. Tap **Isar benchmarks** — results print to the console and show in a snackbar.

Regenerate schemas after model changes:

```bash
./scripts/codegen.sh
```

## Sample results (dev machine)

Recorded on a local debug build with a warm database (typical dev dataset, not full 5k seed):

| Benchmark | Typical |
|-----------|---------|
| `customer_search` | 5–25 ms |
| `product_search` | 3–15 ms |
| `order_list_page_1` | 2–20 ms |
| `pending_count` | < 2 ms |
| `db_open` | < 50 ms (warm) |

Re-run on target hardware with production-sized prefetch data before release decisions.

## Notes

- Isar Community 3.3.x with native `@collection` models (no SQLite shim).
- Indexed fields: customer name/phone, product name/SKU, order `serverId`, outbox status.
- Order list and dashboard use `AsyncNotifier` providers to avoid refetch on tab switch.
