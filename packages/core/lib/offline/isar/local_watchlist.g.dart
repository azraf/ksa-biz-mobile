// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_watchlist.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalWatchlistItemCollection on Isar {
  IsarCollection<LocalWatchlistItem> get localWatchlistItems =>
      this.collection();
}

const LocalWatchlistItemSchema = CollectionSchema(
  name: r'LocalWatchlistItem',
  id: 2951183933019175776,
  properties: {
    r'archivedReason': PropertySchema(
      id: 0,
      name: r'archivedReason',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'customerShopId': PropertySchema(
      id: 2,
      name: r'customerShopId',
      type: IsarType.long,
    ),
    r'gps': PropertySchema(
      id: 3,
      name: r'gps',
      type: IsarType.string,
    ),
    r'noteText': PropertySchema(
      id: 4,
      name: r'noteText',
      type: IsarType.string,
    ),
    r'pendingSync': PropertySchema(
      id: 5,
      name: r'pendingSync',
      type: IsarType.bool,
    ),
    r'placeName': PropertySchema(
      id: 6,
      name: r'placeName',
      type: IsarType.string,
    ),
    r'salesPersonId': PropertySchema(
      id: 7,
      name: r'salesPersonId',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 8,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _localWatchlistItemEstimateSize,
  serialize: _localWatchlistItemSerialize,
  deserialize: _localWatchlistItemDeserialize,
  deserializeProp: _localWatchlistItemDeserializeProp,
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
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'pendingSync': IndexSchema(
      id: 6092646898846083691,
      name: r'pendingSync',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pendingSync',
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
  getId: _localWatchlistItemGetId,
  getLinks: _localWatchlistItemGetLinks,
  attach: _localWatchlistItemAttach,
  version: '3.3.2',
);

int _localWatchlistItemEstimateSize(
  LocalWatchlistItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.archivedReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.createdAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.gps.length * 3;
  {
    final value = object.noteText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.placeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _localWatchlistItemSerialize(
  LocalWatchlistItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.archivedReason);
  writer.writeString(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.customerShopId);
  writer.writeString(offsets[3], object.gps);
  writer.writeString(offsets[4], object.noteText);
  writer.writeBool(offsets[5], object.pendingSync);
  writer.writeString(offsets[6], object.placeName);
  writer.writeLong(offsets[7], object.salesPersonId);
  writer.writeLong(offsets[8], object.serverId);
  writer.writeString(offsets[9], object.status);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

LocalWatchlistItem _localWatchlistItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalWatchlistItem();
  object.archivedReason = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readStringOrNull(offsets[1]);
  object.customerShopId = reader.readLongOrNull(offsets[2]);
  object.gps = reader.readString(offsets[3]);
  object.isarId = id;
  object.noteText = reader.readStringOrNull(offsets[4]);
  object.pendingSync = reader.readBool(offsets[5]);
  object.placeName = reader.readStringOrNull(offsets[6]);
  object.salesPersonId = reader.readLong(offsets[7]);
  object.serverId = reader.readLong(offsets[8]);
  object.status = reader.readString(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _localWatchlistItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localWatchlistItemGetId(LocalWatchlistItem object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localWatchlistItemGetLinks(
    LocalWatchlistItem object) {
  return [];
}

void _localWatchlistItemAttach(
    IsarCollection<dynamic> col, Id id, LocalWatchlistItem object) {
  object.isarId = id;
}

extension LocalWatchlistItemByIndex on IsarCollection<LocalWatchlistItem> {
  Future<LocalWatchlistItem?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalWatchlistItem? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalWatchlistItem?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalWatchlistItem?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalWatchlistItem object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalWatchlistItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalWatchlistItem> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalWatchlistItem> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalWatchlistItemQueryWhereSort
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QWhere> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhere>
      anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhere>
      anySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'salesPersonId'),
      );
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhere>
      anyPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pendingSync'),
      );
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension LocalWatchlistItemQueryWhere
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QWhereClause> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      salesPersonIdEqualTo(int salesPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'salesPersonId',
        value: [salesPersonId],
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      salesPersonIdNotEqualTo(int salesPersonId) {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      salesPersonIdGreaterThan(
    int salesPersonId, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      salesPersonIdLessThan(
    int salesPersonId, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      salesPersonIdBetween(
    int lowerSalesPersonId,
    int upperSalesPersonId, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      pendingSyncEqualTo(bool pendingSync) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pendingSync',
        value: [pendingSync],
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      pendingSyncNotEqualTo(bool pendingSync) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pendingSync',
              lower: [],
              upper: [pendingSync],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pendingSync',
              lower: [pendingSync],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pendingSync',
              lower: [pendingSync],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pendingSync',
              lower: [],
              upper: [pendingSync],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      updatedAtLessThan(
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterWhereClause>
      updatedAtBetween(
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

extension LocalWatchlistItemQueryFilter
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QFilterCondition> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'archivedReason',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'archivedReason',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'archivedReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'archivedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'archivedReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archivedReason',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      archivedReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'archivedReason',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerShopId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerShopId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerShopId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      customerShopIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerShopId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsEqualTo(
    String value, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsGreaterThan(
    String value, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsLessThan(
    String value, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsBetween(
    String lower,
    String upper, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gps',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      gpsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gps',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      noteTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      pendingSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'placeName',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'placeName',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      placeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placeName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      salesPersonIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      salesPersonIdGreaterThan(
    int value, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      salesPersonIdLessThan(
    int value, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      salesPersonIdBetween(
    int lower,
    int upper, {
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterFilterCondition>
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
}

extension LocalWatchlistItemQueryObject
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QFilterCondition> {}

extension LocalWatchlistItemQueryLinks
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QFilterCondition> {}

extension LocalWatchlistItemQuerySortBy
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QSortBy> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByArchivedReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedReason', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByArchivedReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedReason', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByGps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByGpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByPlaceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByPlaceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalWatchlistItemQuerySortThenBy
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QSortThenBy> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByArchivedReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedReason', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByArchivedReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedReason', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByGps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByGpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gps', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByPlaceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByPlaceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalWatchlistItemQueryWhereDistinct
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct> {
  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByArchivedReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archivedReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByCreatedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerShopId');
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct> distinctByGps(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gps', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByNoteText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingSync');
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByPlaceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonId');
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalWatchlistItemQueryProperty
    on QueryBuilder<LocalWatchlistItem, LocalWatchlistItem, QQueryProperty> {
  QueryBuilder<LocalWatchlistItem, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalWatchlistItem, String?, QQueryOperations>
      archivedReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archivedReason');
    });
  }

  QueryBuilder<LocalWatchlistItem, String?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalWatchlistItem, int?, QQueryOperations>
      customerShopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerShopId');
    });
  }

  QueryBuilder<LocalWatchlistItem, String, QQueryOperations> gpsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gps');
    });
  }

  QueryBuilder<LocalWatchlistItem, String?, QQueryOperations>
      noteTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteText');
    });
  }

  QueryBuilder<LocalWatchlistItem, bool, QQueryOperations>
      pendingSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingSync');
    });
  }

  QueryBuilder<LocalWatchlistItem, String?, QQueryOperations>
      placeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placeName');
    });
  }

  QueryBuilder<LocalWatchlistItem, int, QQueryOperations>
      salesPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonId');
    });
  }

  QueryBuilder<LocalWatchlistItem, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<LocalWatchlistItem, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LocalWatchlistItem, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
