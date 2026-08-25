import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

ProductModel _product(
  int id,
  String name, {
  int warehouse = 0,
  int mine = 0,
  int alertQuantity = 0,
}) {
  final total = warehouse + mine;
  return ProductModel(
    id: id,
    name: name,
    price: 100,
    alertQuantity: alertQuantity,
    stock: ProductStock(
      totalPieces: total,
      totalDisplay: '$total PCS',
      sources: [
        ProductStockSource(
          key: 'warehouse',
          label: 'Warehouse',
          balancePieces: warehouse,
          balanceDisplay: '$warehouse PCS',
        ),
        ProductStockSource(
          key: 'mine',
          label: 'My van',
          salesPersonId: 1,
          balancePieces: mine,
          balanceDisplay: '$mine PCS',
        ),
      ],
    ),
  );
}

/// Pumps a browser over [catalog], recording the queries it issues.
Future<List<ProductQuery>> _pump(
  WidgetTester tester,
  List<ProductModel> catalog, {
  void Function(ProductModel)? onTap,
}) async {
  final queries = <ProductQuery>[];

  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ProductBrowser(
      title: 'Products',
      sourceOptions: const [
        ProductSourceOption(key: 'warehouse', label: 'Warehouse'),
        ProductSourceOption(key: 'mine', label: 'My van'),
      ],
      imageBuilder: (url, height) => SizedBox(height: height),
      onTapProduct: onTap ?? (_) {},
      load: (query) async {
        queries.add(query);
        final items = query.inStock
            ? catalog.where((p) => (p.stock?.totalPieces ?? 0) > 0).toList()
            : catalog;
        return PaginatedResponse(
          items: items,
          currentPage: 1,
          lastPage: 1,
          total: items.length,
        );
      },
    ),
  ));
  await tester.pumpAndSettle();
  return queries;
}

void main() {
  testWidgets('out-of-stock products are listed and badged', (tester) async {
    await _pump(tester, [
      _product(1, 'Alpha', warehouse: 24),
      _product(2, 'Zero Stock Item'),
    ]);

    expect(find.text('Zero Stock Item'), findsOneWidget);
    expect(find.text('Out of stock'), findsOneWidget);
  });

  testWidgets('a product at or below its alert quantity reads as low stock',
      (tester) async {
    await _pump(tester, [_product(1, 'Nearly Gone', warehouse: 3, alertQuantity: 5)]);

    expect(find.text('Low stock'), findsOneWidget);
    expect(find.text('Out of stock'), findsNothing);
  });

  testWidgets('the in-stock filter lives in the drawer and reloads the list',
      (tester) async {
    final queries = await _pump(tester, [
      _product(1, 'Alpha', warehouse: 24),
      _product(2, 'Zero Stock Item'),
    ]);

    expect(queries.single.inStock, isFalse);
    expect(find.text('Zero Stock Item'), findsOneWidget);

    // Nothing filter-shaped on the body — it is all behind the tune button.
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    await tester.tap(find.text('In stock only'));
    await tester.pumpAndSettle();

    expect(queries.last.inStock, isTrue);

    // Close the drawer and check the list actually narrowed.
    await tester.tapAt(const Offset(20, 300));
    await tester.pumpAndSettle();
    expect(find.text('Zero Stock Item'), findsNothing);
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('selecting sources passes their keys to the query',
      (tester) async {
    final queries = await _pump(tester, [_product(1, 'Alpha', warehouse: 24)]);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Warehouse'));
    await tester.pumpAndSettle();

    expect(queries.last.sources, {'warehouse'});
  });

  testWidgets('the grid/list toggle survives a reload', (tester) async {
    await _pump(tester, [_product(1, 'Alpha', warehouse: 24)]);

    // Starts in grid, so the action offers the list.
    expect(find.byIcon(Icons.view_list_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.view_list_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.grid_view_outlined), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    // A filter change reloads the data but must not reset the view.
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.tap(find.text('In stock only'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.grid_view_outlined), findsOneWidget);
  });

  testWidgets('tapping a product hands it back to the host', (tester) async {
    ProductModel? tapped;
    await _pump(
      tester,
      [_product(7, 'Alpha', warehouse: 24)],
      onTap: (p) => tapped = p,
    );

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(tapped?.id, 7);
  });
}
