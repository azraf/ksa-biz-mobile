// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_customer.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalCustomerTypeCollection on Isar {
  IsarCollection<LocalCustomerType> get localCustomerTypes => this.collection();
}

const LocalCustomerTypeSchema = CollectionSchema(
  name: r'LocalCustomerType',
  id: -5547744422165187355,
  properties: {
    r'serverId': PropertySchema(
      id: 0,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'typeName': PropertySchema(
      id: 1,
      name: r'typeName',
      type: IsarType.string,
    )
  },
  estimateSize: _localCustomerTypeEstimateSize,
  serialize: _localCustomerTypeSerialize,
  deserialize: _localCustomerTypeDeserialize,
  deserializeProp: _localCustomerTypeDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localCustomerTypeGetId,
  getLinks: _localCustomerTypeGetLinks,
  attach: _localCustomerTypeAttach,
  version: '3.3.2',
);

int _localCustomerTypeEstimateSize(
  LocalCustomerType object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.typeName.length * 3;
  return bytesCount;
}

void _localCustomerTypeSerialize(
  LocalCustomerType object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.serverId);
  writer.writeString(offsets[1], object.typeName);
}

LocalCustomerType _localCustomerTypeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalCustomerType();
  object.isarId = id;
  object.serverId = reader.readLong(offsets[0]);
  object.typeName = reader.readString(offsets[1]);
  return object;
}

P _localCustomerTypeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localCustomerTypeGetId(LocalCustomerType object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localCustomerTypeGetLinks(
    LocalCustomerType object) {
  return [];
}

void _localCustomerTypeAttach(
    IsarCollection<dynamic> col, Id id, LocalCustomerType object) {
  object.isarId = id;
}

extension LocalCustomerTypeByIndex on IsarCollection<LocalCustomerType> {
  Future<LocalCustomerType?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalCustomerType? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalCustomerType?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalCustomerType?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalCustomerType object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalCustomerType object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalCustomerType> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalCustomerType> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalCustomerTypeQueryWhereSort
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QWhere> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhere>
      anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }
}

extension LocalCustomerTypeQueryWhere
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QWhereClause> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      serverIdLessThan(
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterWhereClause>
      serverIdBetween(
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
}

extension LocalCustomerTypeQueryFilter
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QFilterCondition> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterFilterCondition>
      typeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeName',
        value: '',
      ));
    });
  }
}

extension LocalCustomerTypeQueryObject
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QFilterCondition> {}

extension LocalCustomerTypeQueryLinks
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QFilterCondition> {}

extension LocalCustomerTypeQuerySortBy
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QSortBy> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      sortByTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      sortByTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.desc);
    });
  }
}

extension LocalCustomerTypeQuerySortThenBy
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QSortThenBy> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QAfterSortBy>
      thenByTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.desc);
    });
  }
}

extension LocalCustomerTypeQueryWhereDistinct
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QDistinct> {
  QueryBuilder<LocalCustomerType, LocalCustomerType, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<LocalCustomerType, LocalCustomerType, QDistinct>
      distinctByTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeName', caseSensitive: caseSensitive);
    });
  }
}

extension LocalCustomerTypeQueryProperty
    on QueryBuilder<LocalCustomerType, LocalCustomerType, QQueryProperty> {
  QueryBuilder<LocalCustomerType, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalCustomerType, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<LocalCustomerType, String, QQueryOperations> typeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalCustomerShopCollection on Isar {
  IsarCollection<LocalCustomerShop> get localCustomerShops => this.collection();
}

const LocalCustomerShopSchema = CollectionSchema(
  name: r'LocalCustomerShop',
  id: -79495955842152989,
  properties: {
    r'areaId': PropertySchema(
      id: 0,
      name: r'areaId',
      type: IsarType.long,
    ),
    r'areaName': PropertySchema(
      id: 1,
      name: r'areaName',
      type: IsarType.string,
    ),
    r'contactName': PropertySchema(
      id: 2,
      name: r'contactName',
      type: IsarType.string,
    ),
    r'gps': PropertySchema(
      id: 3,
      name: r'gps',
      type: IsarType.string,
    ),
    r'isInactive': PropertySchema(
      id: 4,
      name: r'isInactive',
      type: IsarType.bool,
    ),
    r'isSystem': PropertySchema(
      id: 5,
      name: r'isSystem',
      type: IsarType.bool,
    ),
    r'lastOrderAt': PropertySchema(
      id: 6,
      name: r'lastOrderAt',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 8,
      name: r'phone',
      type: IsarType.string,
    ),
    r'salesPersonId': PropertySchema(
      id: 9,
      name: r'salesPersonId',
      type: IsarType.long,
    ),
    r'salesPersonNameKey': PropertySchema(
      id: 10,
      name: r'salesPersonNameKey',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 11,
      name: r'serverId',
      type: IsarType.long,
    )
  },
  estimateSize: _localCustomerShopEstimateSize,
  serialize: _localCustomerShopSerialize,
  deserialize: _localCustomerShopDeserialize,
  deserializeProp: _localCustomerShopDeserializeProp,
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
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phone',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'salesPersonId': IndexSchema(
      id: 1755910781342964489,
      name: r'salesPersonId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'salesPersonId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'areaId': IndexSchema(
      id: 7446077024685749099,
      name: r'areaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'areaId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'salesPersonNameKey_salesPersonId_name': IndexSchema(
      id: 4470765493909882872,
      name: r'salesPersonNameKey_salesPersonId_name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'salesPersonNameKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'salesPersonId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localCustomerShopGetId,
  getLinks: _localCustomerShopGetLinks,
  attach: _localCustomerShopAttach,
  version: '3.3.2',
);

int _localCustomerShopEstimateSize(
  LocalCustomerShop object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.areaName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contactName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.gps;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastOrderAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.salesPersonNameKey.length * 3;
  return bytesCount;
}

void _localCustomerShopSerialize(
  LocalCustomerShop object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.areaId);
  writer.writeString(offsets[1], object.areaName);
  writer.writeString(offsets[2], object.contactName);
  writer.writeString(offsets[3], object.gps);
  writer.writeBool(offsets[4], object.isInactive);
  writer.writeBool(offsets[5], object.isSystem);
  writer.writeString(offsets[6], object.lastOrderAt);
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.phone);
  writer.writeLong(offsets[9], object.salesPersonId);
  writer.writeString(offsets[10], object.salesPersonNameKey);
  writer.writeLong(offsets[11], object.serverId);
}

LocalCustomerShop _localCustomerShopDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalCustomerShop();
  object.areaId = reader.readLongOrNull(offsets[0]);
  object.areaName = reader.readStringOrNull(offsets[1]);
  object.contactName = reader.readStringOrNull(offsets[2]);
  object.gps = reader.readStringOrNull(offsets[3]);
  object.isInactive = reader.readBool(offsets[4]);
  object.isSystem = reader.readBool(offsets[5]);
  object.isarId = id;
  object.lastOrderAt = reader.readStringOrNull(offsets[6]);
  object.name = reader.readString(offsets[7]);
  object.phone = reader.readString(offsets[8]);
  object.salesPersonId = reader.readLongOrNull(offsets[9]);
  object.salesPersonNameKey = reader.readString(offsets[10]);
  object.serverId = reader.readLong(offsets[11]);
  return object;
}

P _localCustomerShopDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localCustomerShopGetId(LocalCustomerShop object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localCustomerShopGetLinks(
    LocalCustomerShop object) {
  return [];
}

void _localCustomerShopAttach(
    IsarCollection<dynamic> col, Id id, LocalCustomerShop object) {
  object.isarId = id;
}

extension LocalCustomerShopByIndex on IsarCollection<LocalCustomerShop> {
  Future<LocalCustomerShop?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalCustomerShop? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalCustomerShop?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalCustomerShop?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalCustomerShop object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalCustomerShop object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalCustomerShop> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalCustomerShop> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalCustomerShopQueryWhereSort
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QWhere> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere>
      anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere> anyPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'phone'),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere>
      anySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'salesPersonId'),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhere> anyAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'areaId'),
      );
    });
  }
}

extension LocalCustomerShopQueryWhere
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QWhereClause> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      serverIdLessThan(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      serverIdBetween(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameNotEqualTo(String name) {
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameGreaterThan(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameLessThan(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameBetween(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameStartsWith(String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      nameIsNotEmpty() {
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phone',
        value: [phone],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneNotEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [],
              upper: [phone],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [phone],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [phone],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [],
              upper: [phone],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneGreaterThan(
    String phone, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phone',
        lower: [phone],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneLessThan(
    String phone, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phone',
        lower: [],
        upper: [phone],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneBetween(
    String lowerPhone,
    String upperPhone, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phone',
        lower: [lowerPhone],
        includeLower: includeLower,
        upper: [upperPhone],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneStartsWith(String PhonePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phone',
        lower: [PhonePrefix],
        upper: ['$PhonePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phone',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'phone',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'phone',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'phone',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'phone',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [salesPersonId],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdNotEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdGreaterThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [salesPersonId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdLessThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [],
        upper: [salesPersonId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonIdBetween(
    int? lowerSalesPersonId,
    int? upperSalesPersonId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [lowerSalesPersonId],
        includeLower: includeLower,
        upper: [upperSalesPersonId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'areaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'areaId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdEqualTo(int? areaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'areaId',
        value: [areaId],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdNotEqualTo(int? areaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'areaId',
              lower: [],
              upper: [areaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'areaId',
              lower: [areaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'areaId',
              lower: [areaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'areaId',
              lower: [],
              upper: [areaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdGreaterThan(
    int? areaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'areaId',
        lower: [areaId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdLessThan(
    int? areaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'areaId',
        lower: [],
        upper: [areaId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      areaIdBetween(
    int? lowerAreaId,
    int? upperAreaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'areaId',
        lower: [lowerAreaId],
        includeLower: includeLower,
        upper: [upperAreaId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToAnySalesPersonIdName(String salesPersonNameKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        value: [salesPersonNameKey],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyNotEqualToAnySalesPersonIdName(
          String salesPersonNameKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [],
              upper: [salesPersonNameKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [],
              upper: [salesPersonNameKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdIsNullAnyName(
          String salesPersonNameKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        value: [salesPersonNameKey, null],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdIsNotNullAnyName(
          String salesPersonNameKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        lower: [salesPersonNameKey, null],
        includeLower: false,
        upper: [
          salesPersonNameKey,
        ],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeySalesPersonIdEqualToAnyName(
          String salesPersonNameKey, int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        value: [salesPersonNameKey, salesPersonId],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdNotEqualToAnyName(
          String salesPersonNameKey, int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey],
              upper: [salesPersonNameKey, salesPersonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId],
              includeLower: false,
              upper: [salesPersonNameKey],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId],
              includeLower: false,
              upper: [salesPersonNameKey],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey],
              upper: [salesPersonNameKey, salesPersonId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdGreaterThanAnyName(
    String salesPersonNameKey,
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        lower: [salesPersonNameKey, salesPersonId],
        includeLower: include,
        upper: [salesPersonNameKey],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdLessThanAnyName(
    String salesPersonNameKey,
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        lower: [salesPersonNameKey],
        upper: [salesPersonNameKey, salesPersonId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeyEqualToSalesPersonIdBetweenAnyName(
    String salesPersonNameKey,
    int? lowerSalesPersonId,
    int? upperSalesPersonId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        lower: [salesPersonNameKey, lowerSalesPersonId],
        includeLower: includeLower,
        upper: [salesPersonNameKey, upperSalesPersonId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeySalesPersonIdNameEqualTo(
          String salesPersonNameKey, int? salesPersonId, String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonNameKey_salesPersonId_name',
        value: [salesPersonNameKey, salesPersonId, name],
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterWhereClause>
      salesPersonNameKeySalesPersonIdEqualToNameNotEqualTo(
          String salesPersonNameKey, int? salesPersonId, String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId],
              upper: [salesPersonNameKey, salesPersonId, name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId, name],
              includeLower: false,
              upper: [salesPersonNameKey, salesPersonId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId, name],
              includeLower: false,
              upper: [salesPersonNameKey, salesPersonId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonNameKey_salesPersonId_name',
              lower: [salesPersonNameKey, salesPersonId],
              upper: [salesPersonNameKey, salesPersonId, name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalCustomerShopQueryFilter
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QFilterCondition> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaId',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaId',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaName',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaName',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'areaName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'areaName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      areaNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'areaName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contactName',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contactName',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      contactNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gps',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gps',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gps',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      gpsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gps',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      isInactiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isInactive',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      isSystemEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSystem',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastOrderAt',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastOrderAt',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOrderAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastOrderAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastOrderAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOrderAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      lastOrderAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastOrderAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesPersonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesPersonNameKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'salesPersonNameKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'salesPersonNameKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonNameKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      salesPersonNameKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'salesPersonNameKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterFilterCondition>
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
}

extension LocalCustomerShopQueryObject
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QFilterCondition> {}

extension LocalCustomerShopQueryLinks
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QFilterCondition> {}

extension LocalCustomerShopQuerySortBy
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QSortBy> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByAreaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByAreaName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByAreaNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaName', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByContactName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByContactNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy> sortByGps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByGpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByIsInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByIsSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByLastOrderAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOrderAt', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByLastOrderAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOrderAt', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortBySalesPersonNameKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonNameKey', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortBySalesPersonNameKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonNameKey', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerShopQuerySortThenBy
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QSortThenBy> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByAreaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByAreaName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByAreaNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaName', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByContactName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByContactNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy> thenByGps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByGpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByLastOrderAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOrderAt', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByLastOrderAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOrderAt', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenBySalesPersonNameKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonNameKey', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenBySalesPersonNameKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonNameKey', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerShopQueryWhereDistinct
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct> {
  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaId');
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByAreaName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByContactName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct> distinctByGps(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gps', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInactive');
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSystem');
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByLastOrderAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOrderAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctBySalesPersonNameKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonNameKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerShop, LocalCustomerShop, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }
}

extension LocalCustomerShopQueryProperty
    on QueryBuilder<LocalCustomerShop, LocalCustomerShop, QQueryProperty> {
  QueryBuilder<LocalCustomerShop, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalCustomerShop, int?, QQueryOperations> areaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaId');
    });
  }

  QueryBuilder<LocalCustomerShop, String?, QQueryOperations>
      areaNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaName');
    });
  }

  QueryBuilder<LocalCustomerShop, String?, QQueryOperations>
      contactNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactName');
    });
  }

  QueryBuilder<LocalCustomerShop, String?, QQueryOperations> gpsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gps');
    });
  }

  QueryBuilder<LocalCustomerShop, bool, QQueryOperations> isInactiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInactive');
    });
  }

  QueryBuilder<LocalCustomerShop, bool, QQueryOperations> isSystemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSystem');
    });
  }

  QueryBuilder<LocalCustomerShop, String?, QQueryOperations>
      lastOrderAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOrderAt');
    });
  }

  QueryBuilder<LocalCustomerShop, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalCustomerShop, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<LocalCustomerShop, int?, QQueryOperations>
      salesPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerShop, String, QQueryOperations>
      salesPersonNameKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonNameKey');
    });
  }

  QueryBuilder<LocalCustomerShop, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalCustomerVanCollection on Isar {
  IsarCollection<LocalCustomerVan> get localCustomerVans => this.collection();
}

const LocalCustomerVanSchema = CollectionSchema(
  name: r'LocalCustomerVan',
  id: 3983967076562985406,
  properties: {
    r'areaId': PropertySchema(
      id: 0,
      name: r'areaId',
      type: IsarType.long,
    ),
    r'isInactive': PropertySchema(
      id: 1,
      name: r'isInactive',
      type: IsarType.bool,
    ),
    r'mobile': PropertySchema(
      id: 2,
      name: r'mobile',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'salesPersonId': PropertySchema(
      id: 4,
      name: r'salesPersonId',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 5,
      name: r'serverId',
      type: IsarType.long,
    )
  },
  estimateSize: _localCustomerVanEstimateSize,
  serialize: _localCustomerVanSerialize,
  deserialize: _localCustomerVanDeserialize,
  deserializeProp: _localCustomerVanDeserializeProp,
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
    r'mobile': IndexSchema(
      id: -2496727240025828292,
      name: r'mobile',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mobile',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'salesPersonId': IndexSchema(
      id: 1755910781342964489,
      name: r'salesPersonId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'salesPersonId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localCustomerVanGetId,
  getLinks: _localCustomerVanGetLinks,
  attach: _localCustomerVanAttach,
  version: '3.3.2',
);

int _localCustomerVanEstimateSize(
  LocalCustomerVan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mobile.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _localCustomerVanSerialize(
  LocalCustomerVan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.areaId);
  writer.writeBool(offsets[1], object.isInactive);
  writer.writeString(offsets[2], object.mobile);
  writer.writeString(offsets[3], object.name);
  writer.writeLong(offsets[4], object.salesPersonId);
  writer.writeLong(offsets[5], object.serverId);
}

LocalCustomerVan _localCustomerVanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalCustomerVan();
  object.areaId = reader.readLongOrNull(offsets[0]);
  object.isInactive = reader.readBool(offsets[1]);
  object.isarId = id;
  object.mobile = reader.readString(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.salesPersonId = reader.readLongOrNull(offsets[4]);
  object.serverId = reader.readLong(offsets[5]);
  return object;
}

P _localCustomerVanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localCustomerVanGetId(LocalCustomerVan object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localCustomerVanGetLinks(LocalCustomerVan object) {
  return [];
}

void _localCustomerVanAttach(
    IsarCollection<dynamic> col, Id id, LocalCustomerVan object) {
  object.isarId = id;
}

extension LocalCustomerVanByIndex on IsarCollection<LocalCustomerVan> {
  Future<LocalCustomerVan?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalCustomerVan? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalCustomerVan?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalCustomerVan?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalCustomerVan object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalCustomerVan object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalCustomerVan> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalCustomerVan> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalCustomerVanQueryWhereSort
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QWhere> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhere> anyMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mobile'),
      );
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhere>
      anySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'salesPersonId'),
      );
    });
  }
}

extension LocalCustomerVanQueryWhere
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QWhereClause> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      serverIdLessThan(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      serverIdBetween(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameNotEqualTo(String name) {
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameGreaterThan(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameLessThan(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameBetween(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameStartsWith(String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      nameIsNotEmpty() {
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileEqualTo(String mobile) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mobile',
        value: [mobile],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileNotEqualTo(String mobile) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [],
              upper: [mobile],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [mobile],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [mobile],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [],
              upper: [mobile],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileGreaterThan(
    String mobile, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [mobile],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileLessThan(
    String mobile, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [],
        upper: [mobile],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileBetween(
    String lowerMobile,
    String upperMobile, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [lowerMobile],
        includeLower: includeLower,
        upper: [upperMobile],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileStartsWith(String MobilePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [MobilePrefix],
        upper: ['$MobilePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mobile',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      mobileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'mobile',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'mobile',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'mobile',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'mobile',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [salesPersonId],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdNotEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdGreaterThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [salesPersonId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdLessThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [],
        upper: [salesPersonId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterWhereClause>
      salesPersonIdBetween(
    int? lowerSalesPersonId,
    int? upperSalesPersonId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [lowerSalesPersonId],
        includeLower: includeLower,
        upper: [upperSalesPersonId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalCustomerVanQueryFilter
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QFilterCondition> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaId',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaId',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      areaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      isInactiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isInactive',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mobile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mobile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      mobileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      salesPersonIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesPersonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterFilterCondition>
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
}

extension LocalCustomerVanQueryObject
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QFilterCondition> {}

extension LocalCustomerVanQueryLinks
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QFilterCondition> {}

extension LocalCustomerVanQuerySortBy
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QSortBy> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByAreaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByIsInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerVanQuerySortThenBy
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QSortThenBy> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByAreaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByIsInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInactive', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerVanQueryWhereDistinct
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct> {
  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct>
      distinctByAreaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaId');
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct>
      distinctByIsInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInactive');
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct> distinctByMobile(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mobile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct>
      distinctBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerVan, LocalCustomerVan, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }
}

extension LocalCustomerVanQueryProperty
    on QueryBuilder<LocalCustomerVan, LocalCustomerVan, QQueryProperty> {
  QueryBuilder<LocalCustomerVan, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalCustomerVan, int?, QQueryOperations> areaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaId');
    });
  }

  QueryBuilder<LocalCustomerVan, bool, QQueryOperations> isInactiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInactive');
    });
  }

  QueryBuilder<LocalCustomerVan, String, QQueryOperations> mobileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mobile');
    });
  }

  QueryBuilder<LocalCustomerVan, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalCustomerVan, int?, QQueryOperations>
      salesPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerVan, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalCustomerImporterCollection on Isar {
  IsarCollection<LocalCustomerImporter> get localCustomerImporters =>
      this.collection();
}

const LocalCustomerImporterSchema = CollectionSchema(
  name: r'LocalCustomerImporter',
  id: -5446645506240464567,
  properties: {
    r'mobile': PropertySchema(
      id: 0,
      name: r'mobile',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'salesPersonId': PropertySchema(
      id: 2,
      name: r'salesPersonId',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 3,
      name: r'serverId',
      type: IsarType.long,
    )
  },
  estimateSize: _localCustomerImporterEstimateSize,
  serialize: _localCustomerImporterSerialize,
  deserialize: _localCustomerImporterDeserialize,
  deserializeProp: _localCustomerImporterDeserializeProp,
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
    r'mobile': IndexSchema(
      id: -2496727240025828292,
      name: r'mobile',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mobile',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'salesPersonId': IndexSchema(
      id: 1755910781342964489,
      name: r'salesPersonId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'salesPersonId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localCustomerImporterGetId,
  getLinks: _localCustomerImporterGetLinks,
  attach: _localCustomerImporterAttach,
  version: '3.3.2',
);

int _localCustomerImporterEstimateSize(
  LocalCustomerImporter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mobile.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _localCustomerImporterSerialize(
  LocalCustomerImporter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.mobile);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.salesPersonId);
  writer.writeLong(offsets[3], object.serverId);
}

LocalCustomerImporter _localCustomerImporterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalCustomerImporter();
  object.isarId = id;
  object.mobile = reader.readString(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.salesPersonId = reader.readLongOrNull(offsets[2]);
  object.serverId = reader.readLong(offsets[3]);
  return object;
}

P _localCustomerImporterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localCustomerImporterGetId(LocalCustomerImporter object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localCustomerImporterGetLinks(
    LocalCustomerImporter object) {
  return [];
}

void _localCustomerImporterAttach(
    IsarCollection<dynamic> col, Id id, LocalCustomerImporter object) {
  object.isarId = id;
}

extension LocalCustomerImporterByIndex
    on IsarCollection<LocalCustomerImporter> {
  Future<LocalCustomerImporter?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalCustomerImporter? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalCustomerImporter?>> getAllByServerId(
      List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalCustomerImporter?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalCustomerImporter object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalCustomerImporter object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalCustomerImporter> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalCustomerImporter> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalCustomerImporterQueryWhereSort
    on QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QWhere> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhere>
      anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhere>
      anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhere>
      anyMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mobile'),
      );
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhere>
      anySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'salesPersonId'),
      );
    });
  }
}

extension LocalCustomerImporterQueryWhere on QueryBuilder<LocalCustomerImporter,
    LocalCustomerImporter, QWhereClause> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      serverIdLessThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      serverIdBetween(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameNotEqualTo(String name) {
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameGreaterThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameLessThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameBetween(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameStartsWith(String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      nameIsNotEmpty() {
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileEqualTo(String mobile) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mobile',
        value: [mobile],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileNotEqualTo(String mobile) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [],
              upper: [mobile],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [mobile],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [mobile],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mobile',
              lower: [],
              upper: [mobile],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileGreaterThan(
    String mobile, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [mobile],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileLessThan(
    String mobile, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [],
        upper: [mobile],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileBetween(
    String lowerMobile,
    String upperMobile, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [lowerMobile],
        includeLower: includeLower,
        upper: [upperMobile],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileStartsWith(String MobilePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mobile',
        lower: [MobilePrefix],
        upper: ['$MobilePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mobile',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      mobileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'mobile',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'mobile',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'mobile',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'mobile',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [salesPersonId],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdNotEqualTo(int? salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [salesPersonId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'salesPersonId',
              lower: [],
              upper: [salesPersonId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdGreaterThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [salesPersonId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdLessThan(
    int? salesPersonId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [],
        upper: [salesPersonId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterWhereClause>
      salesPersonIdBetween(
    int? lowerSalesPersonId,
    int? upperSalesPersonId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'salesPersonId',
        lower: [lowerSalesPersonId],
        includeLower: includeLower,
        upper: [upperSalesPersonId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalCustomerImporterQueryFilter on QueryBuilder<
    LocalCustomerImporter, LocalCustomerImporter, QFilterCondition> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mobile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
          QAfterFilterCondition>
      mobileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
          QAfterFilterCondition>
      mobileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mobile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> mobileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameBetween(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> salesPersonIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesPersonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> serverIdGreaterThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> serverIdLessThan(
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

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter,
      QAfterFilterCondition> serverIdBetween(
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
}

extension LocalCustomerImporterQueryObject on QueryBuilder<
    LocalCustomerImporter, LocalCustomerImporter, QFilterCondition> {}

extension LocalCustomerImporterQueryLinks on QueryBuilder<LocalCustomerImporter,
    LocalCustomerImporter, QFilterCondition> {}

extension LocalCustomerImporterQuerySortBy
    on QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QSortBy> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerImporterQuerySortThenBy
    on QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QSortThenBy> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension LocalCustomerImporterQueryWhereDistinct
    on QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QDistinct> {
  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QDistinct>
      distinctByMobile({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mobile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QDistinct>
      distinctBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerImporter, LocalCustomerImporter, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }
}

extension LocalCustomerImporterQueryProperty on QueryBuilder<
    LocalCustomerImporter, LocalCustomerImporter, QQueryProperty> {
  QueryBuilder<LocalCustomerImporter, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalCustomerImporter, String, QQueryOperations>
      mobileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mobile');
    });
  }

  QueryBuilder<LocalCustomerImporter, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalCustomerImporter, int?, QQueryOperations>
      salesPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonId');
    });
  }

  QueryBuilder<LocalCustomerImporter, int, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}
