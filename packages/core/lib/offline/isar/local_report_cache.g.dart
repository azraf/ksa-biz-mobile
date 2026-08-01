// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_report_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalReportCacheCollection on Isar {
  IsarCollection<LocalReportCache> get localReportCaches => this.collection();
}

const LocalReportCacheSchema = CollectionSchema(
  name: r'LocalReportCache',
  id: 6547032802385602261,
  properties: {
    r'cacheKey': PropertySchema(
      id: 0,
      name: r'cacheKey',
      type: IsarType.string,
    ),
    r'dataJson': PropertySchema(
      id: 1,
      name: r'dataJson',
      type: IsarType.string,
    ),
    r'fetchedAt': PropertySchema(
      id: 2,
      name: r'fetchedAt',
      type: IsarType.dateTime,
    ),
    r'reportType': PropertySchema(
      id: 3,
      name: r'reportType',
      type: IsarType.string,
    )
  },
  estimateSize: _localReportCacheEstimateSize,
  serialize: _localReportCacheSerialize,
  deserialize: _localReportCacheDeserialize,
  deserializeProp: _localReportCacheDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'cacheKey': IndexSchema(
      id: 5885332021012296610,
      name: r'cacheKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cacheKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'reportType': IndexSchema(
      id: 3559997651334899995,
      name: r'reportType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reportType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'fetchedAt': IndexSchema(
      id: -689920985439132966,
      name: r'fetchedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'fetchedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localReportCacheGetId,
  getLinks: _localReportCacheGetLinks,
  attach: _localReportCacheAttach,
  version: '3.3.2',
);

int _localReportCacheEstimateSize(
  LocalReportCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheKey.length * 3;
  bytesCount += 3 + object.dataJson.length * 3;
  bytesCount += 3 + object.reportType.length * 3;
  return bytesCount;
}

void _localReportCacheSerialize(
  LocalReportCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheKey);
  writer.writeString(offsets[1], object.dataJson);
  writer.writeDateTime(offsets[2], object.fetchedAt);
  writer.writeString(offsets[3], object.reportType);
}

LocalReportCache _localReportCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalReportCache();
  object.cacheKey = reader.readString(offsets[0]);
  object.dataJson = reader.readString(offsets[1]);
  object.fetchedAt = reader.readDateTime(offsets[2]);
  object.isarId = id;
  object.reportType = reader.readString(offsets[3]);
  return object;
}

P _localReportCacheDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localReportCacheGetId(LocalReportCache object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localReportCacheGetLinks(LocalReportCache object) {
  return [];
}

void _localReportCacheAttach(
    IsarCollection<dynamic> col, Id id, LocalReportCache object) {
  object.isarId = id;
}

extension LocalReportCacheByIndex on IsarCollection<LocalReportCache> {
  Future<LocalReportCache?> getByCacheKey(String cacheKey) {
    return getByIndex(r'cacheKey', [cacheKey]);
  }

  LocalReportCache? getByCacheKeySync(String cacheKey) {
    return getByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<bool> deleteByCacheKey(String cacheKey) {
    return deleteByIndex(r'cacheKey', [cacheKey]);
  }

  bool deleteByCacheKeySync(String cacheKey) {
    return deleteByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<List<LocalReportCache?>> getAllByCacheKey(
      List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheKey', values);
  }

  List<LocalReportCache?> getAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheKey', values);
  }

  Future<int> deleteAllByCacheKey(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheKey', values);
  }

  int deleteAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheKey', values);
  }

  Future<Id> putByCacheKey(LocalReportCache object) {
    return putByIndex(r'cacheKey', object);
  }

  Id putByCacheKeySync(LocalReportCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'cacheKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheKey(List<LocalReportCache> objects) {
    return putAllByIndex(r'cacheKey', objects);
  }

  List<Id> putAllByCacheKeySync(List<LocalReportCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheKey', objects, saveLinks: saveLinks);
  }
}

extension LocalReportCacheQueryWhereSort
    on QueryBuilder<LocalReportCache, LocalReportCache, QWhere> {
  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhere> anyFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'fetchedAt'),
      );
    });
  }
}

extension LocalReportCacheQueryWhere
    on QueryBuilder<LocalReportCache, LocalReportCache, QWhereClause> {
  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
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

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
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

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      cacheKeyEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheKey',
        value: [cacheKey],
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      cacheKeyNotEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      reportTypeEqualTo(String reportType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reportType',
        value: [reportType],
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      reportTypeNotEqualTo(String reportType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportType',
              lower: [],
              upper: [reportType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportType',
              lower: [reportType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportType',
              lower: [reportType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reportType',
              lower: [],
              upper: [reportType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      fetchedAtEqualTo(DateTime fetchedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fetchedAt',
        value: [fetchedAt],
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      fetchedAtNotEqualTo(DateTime fetchedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [],
              upper: [fetchedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [fetchedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [fetchedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [],
              upper: [fetchedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      fetchedAtGreaterThan(
    DateTime fetchedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [fetchedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      fetchedAtLessThan(
    DateTime fetchedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [],
        upper: [fetchedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterWhereClause>
      fetchedAtBetween(
    DateTime lowerFetchedAt,
    DateTime upperFetchedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [lowerFetchedAt],
        includeLower: includeLower,
        upper: [upperFetchedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalReportCacheQueryFilter
    on QueryBuilder<LocalReportCache, LocalReportCache, QFilterCondition> {
  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      cacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      dataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      fetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      fetchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      fetchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      fetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
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

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
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

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
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

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterFilterCondition>
      reportTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportType',
        value: '',
      ));
    });
  }
}

extension LocalReportCacheQueryObject
    on QueryBuilder<LocalReportCache, LocalReportCache, QFilterCondition> {}

extension LocalReportCacheQueryLinks
    on QueryBuilder<LocalReportCache, LocalReportCache, QFilterCondition> {}

extension LocalReportCacheQuerySortBy
    on QueryBuilder<LocalReportCache, LocalReportCache, QSortBy> {
  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByReportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      sortByReportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.desc);
    });
  }
}

extension LocalReportCacheQuerySortThenBy
    on QueryBuilder<LocalReportCache, LocalReportCache, QSortThenBy> {
  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByReportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.asc);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QAfterSortBy>
      thenByReportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.desc);
    });
  }
}

extension LocalReportCacheQueryWhereDistinct
    on QueryBuilder<LocalReportCache, LocalReportCache, QDistinct> {
  QueryBuilder<LocalReportCache, LocalReportCache, QDistinct>
      distinctByCacheKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QDistinct>
      distinctByDataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QDistinct>
      distinctByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt');
    });
  }

  QueryBuilder<LocalReportCache, LocalReportCache, QDistinct>
      distinctByReportType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportType', caseSensitive: caseSensitive);
    });
  }
}

extension LocalReportCacheQueryProperty
    on QueryBuilder<LocalReportCache, LocalReportCache, QQueryProperty> {
  QueryBuilder<LocalReportCache, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalReportCache, String, QQueryOperations> cacheKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheKey');
    });
  }

  QueryBuilder<LocalReportCache, String, QQueryOperations> dataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataJson');
    });
  }

  QueryBuilder<LocalReportCache, DateTime, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<LocalReportCache, String, QQueryOperations>
      reportTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportType');
    });
  }
}
