// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_outbox_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncOutboxEntryCollection on Isar {
  IsarCollection<SyncOutboxEntry> get syncOutboxEntrys => this.collection();
}

const SyncOutboxEntrySchema = CollectionSchema(
  name: r'SyncOutboxEntry',
  id: -2825382338902189300,
  properties: {
    r'clientRequestId': PropertySchema(
      id: 0,
      name: r'clientRequestId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'entityType': PropertySchema(
      id: 2,
      name: r'entityType',
      type: IsarType.string,
      enumMap: _SyncOutboxEntryentityTypeEnumValueMap,
    ),
    r'errorMessage': PropertySchema(
      id: 3,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'localEntityId': PropertySchema(
      id: 4,
      name: r'localEntityId',
      type: IsarType.long,
    ),
    r'nextRetryAt': PropertySchema(
      id: 5,
      name: r'nextRetryAt',
      type: IsarType.dateTime,
    ),
    r'operation': PropertySchema(
      id: 6,
      name: r'operation',
      type: IsarType.string,
      enumMap: _SyncOutboxEntryoperationEnumValueMap,
    ),
    r'payloadJson': PropertySchema(
      id: 7,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'retryCount': PropertySchema(
      id: 8,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'serverEntityId': PropertySchema(
      id: 9,
      name: r'serverEntityId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
      enumMap: _SyncOutboxEntrystatusEnumValueMap,
    )
  },
  estimateSize: _syncOutboxEntryEstimateSize,
  serialize: _syncOutboxEntrySerialize,
  deserialize: _syncOutboxEntryDeserialize,
  deserializeProp: _syncOutboxEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'localEntityId': IndexSchema(
      id: 4235605058528510973,
      name: r'localEntityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'localEntityId',
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
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncOutboxEntryGetId,
  getLinks: _syncOutboxEntryGetLinks,
  attach: _syncOutboxEntryAttach,
  version: '3.3.2',
);

int _syncOutboxEntryEstimateSize(
  SyncOutboxEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.clientRequestId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.entityType.name.length * 3;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.operation.name.length * 3;
  bytesCount += 3 + object.payloadJson.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  return bytesCount;
}

void _syncOutboxEntrySerialize(
  SyncOutboxEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientRequestId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.entityType.name);
  writer.writeString(offsets[3], object.errorMessage);
  writer.writeLong(offsets[4], object.localEntityId);
  writer.writeDateTime(offsets[5], object.nextRetryAt);
  writer.writeString(offsets[6], object.operation.name);
  writer.writeString(offsets[7], object.payloadJson);
  writer.writeLong(offsets[8], object.retryCount);
  writer.writeLong(offsets[9], object.serverEntityId);
  writer.writeString(offsets[10], object.status.name);
}

SyncOutboxEntry _syncOutboxEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncOutboxEntry();
  object.clientRequestId = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.entityType = _SyncOutboxEntryentityTypeValueEnumMap[
          reader.readStringOrNull(offsets[2])] ??
      SyncEntityType.order;
  object.errorMessage = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.localEntityId = reader.readLongOrNull(offsets[4]);
  object.nextRetryAt = reader.readDateTimeOrNull(offsets[5]);
  object.operation = _SyncOutboxEntryoperationValueEnumMap[
          reader.readStringOrNull(offsets[6])] ??
      SyncOperation.create;
  object.payloadJson = reader.readString(offsets[7]);
  object.retryCount = reader.readLong(offsets[8]);
  object.serverEntityId = reader.readLongOrNull(offsets[9]);
  object.status = _SyncOutboxEntrystatusValueEnumMap[
          reader.readStringOrNull(offsets[10])] ??
      SyncStatus.pending;
  return object;
}

P _syncOutboxEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_SyncOutboxEntryentityTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncEntityType.order) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (_SyncOutboxEntryoperationValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncOperation.create) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (_SyncOutboxEntrystatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.pending) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SyncOutboxEntryentityTypeEnumValueMap = {
  r'order': r'order',
  r'expense': r'expense',
  r'watchlist': r'watchlist',
  r'diary': r'diary',
};
const _SyncOutboxEntryentityTypeValueEnumMap = {
  r'order': SyncEntityType.order,
  r'expense': SyncEntityType.expense,
  r'watchlist': SyncEntityType.watchlist,
  r'diary': SyncEntityType.diary,
};
const _SyncOutboxEntryoperationEnumValueMap = {
  r'create': r'create',
  r'update': r'update',
  r'delete': r'delete',
  r'payment': r'payment',
  r'cancel': r'cancel',
};
const _SyncOutboxEntryoperationValueEnumMap = {
  r'create': SyncOperation.create,
  r'update': SyncOperation.update,
  r'delete': SyncOperation.delete,
  r'payment': SyncOperation.payment,
  r'cancel': SyncOperation.cancel,
};
const _SyncOutboxEntrystatusEnumValueMap = {
  r'pending': r'pending',
  r'syncing': r'syncing',
  r'done': r'done',
  r'failed': r'failed',
  r'dead': r'dead',
};
const _SyncOutboxEntrystatusValueEnumMap = {
  r'pending': SyncStatus.pending,
  r'syncing': SyncStatus.syncing,
  r'done': SyncStatus.done,
  r'failed': SyncStatus.failed,
  r'dead': SyncStatus.dead,
};

Id _syncOutboxEntryGetId(SyncOutboxEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncOutboxEntryGetLinks(SyncOutboxEntry object) {
  return [];
}

void _syncOutboxEntryAttach(
    IsarCollection<dynamic> col, Id id, SyncOutboxEntry object) {
  object.id = id;
}

extension SyncOutboxEntryQueryWhereSort
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QWhere> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhere>
      anyLocalEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'localEntityId'),
      );
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension SyncOutboxEntryQueryWhere
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QWhereClause> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localEntityId',
        value: [null],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localEntityId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdEqualTo(int? localEntityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localEntityId',
        value: [localEntityId],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdNotEqualTo(int? localEntityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localEntityId',
              lower: [],
              upper: [localEntityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localEntityId',
              lower: [localEntityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localEntityId',
              lower: [localEntityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localEntityId',
              lower: [],
              upper: [localEntityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdGreaterThan(
    int? localEntityId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localEntityId',
        lower: [localEntityId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdLessThan(
    int? localEntityId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localEntityId',
        lower: [],
        upper: [localEntityId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      localEntityIdBetween(
    int? lowerLocalEntityId,
    int? upperLocalEntityId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localEntityId',
        lower: [lowerLocalEntityId],
        includeLower: includeLower,
        upper: [upperLocalEntityId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      statusEqualTo(SyncStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      statusNotEqualTo(SyncStatus status) {
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SyncOutboxEntryQueryFilter
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QFilterCondition> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientRequestId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientRequestId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientRequestId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientRequestId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      clientRequestIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeEqualTo(
    SyncEntityType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeGreaterThan(
    SyncEntityType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeLessThan(
    SyncEntityType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeBetween(
    SyncEntityType lower,
    SyncEntityType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localEntityId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localEntityId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      localEntityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localEntityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextRetryAt',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextRetryAt',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextRetryAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextRetryAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextRetryAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      nextRetryAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextRetryAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationEqualTo(
    SyncOperation value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationGreaterThan(
    SyncOperation value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationLessThan(
    SyncOperation value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationBetween(
    SyncOperation lower,
    SyncOperation upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operation',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      operationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operation',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverEntityId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverEntityId',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      serverEntityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverEntityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusEqualTo(
    SyncStatus value, {
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusGreaterThan(
    SyncStatus value, {
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusLessThan(
    SyncStatus value, {
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusBetween(
    SyncStatus lower,
    SyncStatus upper, {
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
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

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension SyncOutboxEntryQueryObject
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QFilterCondition> {}

extension SyncOutboxEntryQueryLinks
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QFilterCondition> {}

extension SyncOutboxEntryQuerySortBy
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QSortBy> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByClientRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRequestId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByClientRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRequestId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByLocalEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEntityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByLocalEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEntityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByNextRetryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRetryAt', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByNextRetryAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRetryAt', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByServerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverEntityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByServerEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverEntityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncOutboxEntryQuerySortThenBy
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QSortThenBy> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByClientRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRequestId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByClientRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRequestId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByLocalEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEntityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByLocalEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEntityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByNextRetryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRetryAt', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByNextRetryAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRetryAt', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByServerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverEntityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByServerEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverEntityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncOutboxEntryQueryWhereDistinct
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct> {
  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByClientRequestId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientRequestId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByLocalEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localEntityId');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByNextRetryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextRetryAt');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct> distinctByOperation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct>
      distinctByServerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverEntityId');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension SyncOutboxEntryQueryProperty
    on QueryBuilder<SyncOutboxEntry, SyncOutboxEntry, QQueryProperty> {
  QueryBuilder<SyncOutboxEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncOutboxEntry, String?, QQueryOperations>
      clientRequestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientRequestId');
    });
  }

  QueryBuilder<SyncOutboxEntry, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncEntityType, QQueryOperations>
      entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<SyncOutboxEntry, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<SyncOutboxEntry, int?, QQueryOperations>
      localEntityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localEntityId');
    });
  }

  QueryBuilder<SyncOutboxEntry, DateTime?, QQueryOperations>
      nextRetryAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextRetryAt');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncOperation, QQueryOperations>
      operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operation');
    });
  }

  QueryBuilder<SyncOutboxEntry, String, QQueryOperations>
      payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<SyncOutboxEntry, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<SyncOutboxEntry, int?, QQueryOperations>
      serverEntityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverEntityId');
    });
  }

  QueryBuilder<SyncOutboxEntry, SyncStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
