// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_product.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalProductCollection on Isar {
  IsarCollection<LocalProduct> get localProducts => this.collection();
}

const LocalProductSchema = CollectionSchema(
  name: r'LocalProduct',
  id: -8308196661054099245,
  properties: {
    r'alertQuantity': PropertySchema(
      id: 0,
      name: r'alertQuantity',
      type: IsarType.long,
    ),
    r'allowBreakPack': PropertySchema(
      id: 1,
      name: r'allowBreakPack',
      type: IsarType.bool,
    ),
    r'cartonUnitId': PropertySchema(
      id: 2,
      name: r'cartonUnitId',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'pcsUnitId': PropertySchema(
      id: 5,
      name: r'pcsUnitId',
      type: IsarType.long,
    ),
    r'piecePrice': PropertySchema(
      id: 6,
      name: r'piecePrice',
      type: IsarType.double,
    ),
    r'piecesPerCarton': PropertySchema(
      id: 7,
      name: r'piecesPerCarton',
      type: IsarType.long,
    ),
    r'price': PropertySchema(
      id: 8,
      name: r'price',
      type: IsarType.double,
    ),
    r'serverId': PropertySchema(
      id: 9,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'sku': PropertySchema(
      id: 10,
      name: r'sku',
      type: IsarType.string,
    ),
    r'unitId': PropertySchema(
      id: 11,
      name: r'unitId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wholesalePrice': PropertySchema(
      id: 13,
      name: r'wholesalePrice',
      type: IsarType.double,
    )
  },
  estimateSize: _localProductEstimateSize,
  serialize: _localProductSerialize,
  deserialize: _localProductDeserialize,
  deserializeProp: _localProductDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'sku': IndexSchema(
      id: -3348042439688860591,
      name: r'sku',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sku',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localProductGetId,
  getLinks: _localProductGetLinks,
  attach: _localProductAttach,
  version: '3.3.2',
);

int _localProductEstimateSize(
  LocalProduct object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.sku.length * 3;
  return bytesCount;
}

void _localProductSerialize(
  LocalProduct object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.alertQuantity);
  writer.writeBool(offsets[1], object.allowBreakPack);
  writer.writeLong(offsets[2], object.cartonUnitId);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.pcsUnitId);
  writer.writeDouble(offsets[6], object.piecePrice);
  writer.writeLong(offsets[7], object.piecesPerCarton);
  writer.writeDouble(offsets[8], object.price);
  writer.writeLong(offsets[9], object.serverId);
  writer.writeString(offsets[10], object.sku);
  writer.writeLong(offsets[11], object.unitId);
  writer.writeDateTime(offsets[12], object.updatedAt);
  writer.writeDouble(offsets[13], object.wholesalePrice);
}

LocalProduct _localProductDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalProduct();
  object.alertQuantity = reader.readLong(offsets[0]);
  object.allowBreakPack = reader.readBool(offsets[1]);
  object.cartonUnitId = reader.readLongOrNull(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.isarId = id;
  object.name = reader.readString(offsets[4]);
  object.pcsUnitId = reader.readLongOrNull(offsets[5]);
  object.piecePrice = reader.readDouble(offsets[6]);
  object.piecesPerCarton = reader.readLong(offsets[7]);
  object.price = reader.readDouble(offsets[8]);
  object.serverId = reader.readLong(offsets[9]);
  object.sku = reader.readString(offsets[10]);
  object.unitId = reader.readLongOrNull(offsets[11]);
  object.updatedAt = reader.readDateTime(offsets[12]);
  object.wholesalePrice = reader.readDouble(offsets[13]);
  return object;
}

P _localProductDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localProductGetId(LocalProduct object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localProductGetLinks(LocalProduct object) {
  return [];
}

void _localProductAttach(
    IsarCollection<dynamic> col, Id id, LocalProduct object) {
  object.isarId = id;
}

extension LocalProductByIndex on IsarCollection<LocalProduct> {
  Future<LocalProduct?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalProduct? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalProduct?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalProduct?> getAllByServerIdSync(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverId', values);
  }

  Future<int> deleteAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverId', values);
  }

  int deleteAllByServerIdSync(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverId', values);
  }

  Future<Id> putByServerId(LocalProduct object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalProduct object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalProduct> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalProduct> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalProductQueryWhereSort
    on QueryBuilder<LocalProduct, LocalProduct, QWhere> {
  QueryBuilder<LocalProduct, LocalProduct, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhere> anySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sku'),
      );
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension LocalProductQueryWhere
    on QueryBuilder<LocalProduct, LocalProduct, QWhereClause> {
  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> serverIdEqualTo(
      int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause>
      serverIdNotEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause>
      serverIdGreaterThan(
    int serverId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverId',
        lower: [serverId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> serverIdLessThan(
    int serverId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverId',
        lower: [],
        upper: [serverId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> serverIdBetween(
    int lowerServerId,
    int upperServerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverId',
        lower: [lowerServerId],
        includeLower: includeLower,
        upper: [upperServerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [name],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [],
        upper: [name],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [lowerName],
        includeLower: includeLower,
        upper: [upperName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuEqualTo(
      String sku) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sku',
        value: [sku],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuNotEqualTo(
      String sku) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sku',
              lower: [],
              upper: [sku],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sku',
              lower: [sku],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sku',
              lower: [sku],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sku',
              lower: [],
              upper: [sku],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuGreaterThan(
    String sku, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sku',
        lower: [sku],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuLessThan(
    String sku, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sku',
        lower: [],
        upper: [sku],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuBetween(
    String lowerSku,
    String upperSku, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sku',
        lower: [lowerSku],
        includeLower: includeLower,
        upper: [upperSku],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuStartsWith(
      String SkuPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sku',
        lower: [SkuPrefix],
        upper: ['$SkuPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sku',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'sku',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'sku',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'sku',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'sku',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> updatedAtEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterWhereClause> updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalProductQueryFilter
    on QueryBuilder<LocalProduct, LocalProduct, QFilterCondition> {
  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      alertQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alertQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      alertQuantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alertQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      alertQuantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alertQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      alertQuantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alertQuantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      allowBreakPackEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowBreakPack',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cartonUnitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cartonUnitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cartonUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cartonUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cartonUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      cartonUnitIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cartonUnitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pcsUnitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pcsUnitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pcsUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pcsUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pcsUnitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      pcsUnitIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pcsUnitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'piecePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecesPerCartonEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'piecesPerCarton',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecesPerCartonGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'piecesPerCarton',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecesPerCartonLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'piecesPerCarton',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      piecesPerCartonBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'piecesPerCarton',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      serverIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      serverIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      serverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      skuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sku',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sku',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sku',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      unitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      unitIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unitId',
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> unitIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      unitIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      unitIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition> unitIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      wholesalePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      wholesalePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      wholesalePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterFilterCondition>
      wholesalePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wholesalePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension LocalProductQueryObject
    on QueryBuilder<LocalProduct, LocalProduct, QFilterCondition> {}

extension LocalProductQueryLinks
    on QueryBuilder<LocalProduct, LocalProduct, QFilterCondition> {}

extension LocalProductQuerySortBy
    on QueryBuilder<LocalProduct, LocalProduct, QSortBy> {
  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByAlertQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertQuantity', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByAlertQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertQuantity', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByAllowBreakPack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowBreakPack', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByAllowBreakPackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowBreakPack', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByCartonUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartonUnitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByCartonUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartonUnitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByPcsUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pcsUnitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByPcsUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pcsUnitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByPiecePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByPiecesPerCarton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerCarton', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByPiecesPerCartonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerCarton', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      sortByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.desc);
    });
  }
}

extension LocalProductQuerySortThenBy
    on QueryBuilder<LocalProduct, LocalProduct, QSortThenBy> {
  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByAlertQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertQuantity', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByAlertQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertQuantity', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByAllowBreakPack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowBreakPack', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByAllowBreakPackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowBreakPack', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByCartonUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartonUnitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByCartonUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartonUnitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByPcsUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pcsUnitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByPcsUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pcsUnitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByPiecePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByPiecesPerCarton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerCarton', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByPiecesPerCartonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerCarton', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.asc);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QAfterSortBy>
      thenByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.desc);
    });
  }
}

extension LocalProductQueryWhereDistinct
    on QueryBuilder<LocalProduct, LocalProduct, QDistinct> {
  QueryBuilder<LocalProduct, LocalProduct, QDistinct>
      distinctByAlertQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alertQuantity');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct>
      distinctByAllowBreakPack() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowBreakPack');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByCartonUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cartonUnitId');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByPcsUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pcsUnitId');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'piecePrice');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct>
      distinctByPiecesPerCarton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'piecesPerCarton');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitId');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalProduct, LocalProduct, QDistinct>
      distinctByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wholesalePrice');
    });
  }
}

extension LocalProductQueryProperty
    on QueryBuilder<LocalProduct, LocalProduct, QQueryProperty> {
  QueryBuilder<LocalProduct, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalProduct, int, QQueryOperations> alertQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alertQuantity');
    });
  }

  QueryBuilder<LocalProduct, bool, QQueryOperations> allowBreakPackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowBreakPack');
    });
  }

  QueryBuilder<LocalProduct, int?, QQueryOperations> cartonUnitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cartonUnitId');
    });
  }

  QueryBuilder<LocalProduct, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<LocalProduct, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalProduct, int?, QQueryOperations> pcsUnitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pcsUnitId');
    });
  }

  QueryBuilder<LocalProduct, double, QQueryOperations> piecePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'piecePrice');
    });
  }

  QueryBuilder<LocalProduct, int, QQueryOperations> piecesPerCartonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'piecesPerCarton');
    });
  }

  QueryBuilder<LocalProduct, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<LocalProduct, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<LocalProduct, String, QQueryOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sku');
    });
  }

  QueryBuilder<LocalProduct, int?, QQueryOperations> unitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitId');
    });
  }

  QueryBuilder<LocalProduct, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalProduct, double, QQueryOperations>
      wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wholesalePrice');
    });
  }
}
