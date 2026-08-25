import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

import 'package:sales_app/features/products/product_screens.dart';
import 'package:sales_app/features/van_stock/load_van_screen.dart';
import 'package:sales_app/features/van_stock/van_stock_screen.dart';
import 'package:sales_app/providers/auth_provider.dart';
import 'package:sales_app/providers/repositories.dart';

class _FakeInventoryRepository extends InventoryRepository {
  _FakeInventoryRepository({this.preview = const []}) : super(ApiClient());

  final List<BulkLoadPreviewLine> preview;
  int bulkLoadCalls = 0;

  @override
  Future<List<BulkLoadPreviewLine>> bulkLoadVanPreview() async => preview;

  @override
  Future<BulkLoadResult> bulkLoadVan({
    required int salesPersonId,
    List<BulkLoadLineDraft>? lines,
    bool loadAll = false,
  }) async {
    bulkLoadCalls++;
    return const BulkLoadResult(loaded: []);
  }
}

/// An authenticated salesperson without touching repositories/preferences.
class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthState(
        isAuthenticated: true,
        salesPerson: SalesPersonModel(id: 5, name: 'Tester'),
      );
}

Widget _wrap(Widget child, {required _FakeInventoryRepository repo}) {
  return ProviderScope(
    overrides: [
      inventoryRepositoryProvider.overrideWithValue(repo),
      authProvider.overrideWith(_FakeAuthNotifier.new),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  group('totalCartons', () {
    test('converts pieces to whole cartons like the server', () {
      expect(totalCartons(240, 24), 10);
      expect(totalCartons(239, 24), 9); // partial cartons round down
      expect(totalCartons(23, 24), 0); // pieces-only stock is 0 cartons
    });

    test('guards a zero pieces-per-carton', () {
      expect(totalCartons(15, 0), 15);
    });

    test('agrees with the carton alert threshold', () {
      // 100 loose pieces of a 24-per-carton product with alert at 10 cartons:
      // 4 cartons -> low. The old pieces comparison said 100 > 10 -> not low.
      const alert = 10;
      expect(totalCartons(100, 24) <= alert, isTrue);
    });
  });

  group('vanStockItemToJson', () {
    test('round-trips through InventoryStockModel.fromJson', () {
      const item = InventoryStockModel(
        productId: 7,
        balance: 3,
        balancePieces: 76,
        balanceDisplay: '3 CTN + 4 pcs',
        piecesPerCarton: 24,
        product: ProductModel(
          id: 7,
          name: 'Cola',
          alertQuantity: 5,
          allowBreakPack: true,
          piecesPerCarton: 24,
        ),
      );

      final restored = InventoryStockModel.fromJson(vanStockItemToJson(item));

      expect(restored.productId, 7);
      expect(restored.balance, 3);
      expect(restored.balancePieces, 76);
      expect(restored.balanceDisplay, '3 CTN + 4 pcs');
      expect(restored.piecesPerCarton, 24);
      expect(restored.product?.name, 'Cola');
      expect(restored.product?.alertQuantity, 5);
      expect(restored.product?.allowBreakPack, isTrue);
    });
  });

  group('LoadVanScreen', () {
    final preview = [
      const BulkLoadPreviewLine(
        productId: 1,
        quantity: 3,
        productName: 'Cola',
        balanceDisplay: '3 CTN + 4 pcs',
        quantityDisplay: '3 CTN',
      ),
      const BulkLoadPreviewLine(
        productId: 2,
        quantity: 7,
        productName: 'Chips',
        balanceDisplay: '7 pcs',
        quantityDisplay: '7 PCS',
        unitId: 42,
      ),
    ];

    testWidgets('defaults each line from the server preview, pieces-only included',
        (tester) async {
      final repo = _FakeInventoryRepository(preview: preview);
      await tester.pumpWidget(_wrap(const LoadVanScreen(), repo: repo));
      await tester.pumpAndSettle();

      // Carton line defaults to its carton balance, labelled CTN.
      expect(find.widgetWithText(TextField, '3'), findsOneWidget);
      expect(find.text('CTN'), findsOneWidget);
      // Pieces-only line defaults to its pieces balance, labelled PCS —
      // not the old blanket "1" that meant 1 carton and 422'd.
      expect(find.widgetWithText(TextField, '7'), findsOneWidget);
      expect(find.text('PCS'), findsOneWidget);
    });

    testWidgets('Load all asks for confirmation first', (tester) async {
      final repo = _FakeInventoryRepository(preview: preview);
      await tester.pumpWidget(_wrap(const LoadVanScreen(), repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Load all available'));
      await tester.pumpAndSettle();

      // Dialog summarises the lines; nothing submitted yet.
      expect(find.textContaining('This loads all available warehouse stock'),
          findsOneWidget);
      expect(find.text('3 CTN'), findsOneWidget);
      expect(find.text('7 PCS'), findsOneWidget);
      expect(repo.bulkLoadCalls, 0);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.bulkLoadCalls, 0);
    });

    testWidgets('rejects an invalid selected quantity with an inline error',
        (tester) async {
      final repo = _FakeInventoryRepository(preview: preview);
      await tester.pumpWidget(_wrap(const LoadVanScreen(), repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chips')); // tick the line
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, '7'), '0');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Load selected'));
      await tester.pumpAndSettle();

      expect(find.text('Enter 1 or more'), findsOneWidget);
      expect(repo.bulkLoadCalls, 0);
    });
  });
}
