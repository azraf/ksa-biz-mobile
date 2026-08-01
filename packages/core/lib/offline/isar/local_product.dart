import 'package:isar_community/isar.dart';

part 'local_product.g.dart';

@collection
class LocalProduct {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index(type: IndexType.value, caseSensitive: false)
  String sku = '';

  late double price;
  late double wholesalePrice;
  int alertQuantity = 0;
  String? description;
  bool allowBreakPack = false;
  int piecesPerCarton = 1;
  double piecePrice = 0;
  int? pcsUnitId;
  int? cartonUnitId;
  int? unitId;

  @Index()
  late DateTime updatedAt;
}
