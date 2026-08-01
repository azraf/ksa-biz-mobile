// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_diary.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalDiaryNoteCollection on Isar {
  IsarCollection<LocalDiaryNote> get localDiaryNotes => this.collection();
}

const LocalDiaryNoteSchema = CollectionSchema(
  name: r'LocalDiaryNote',
  id: -3017181211574086963,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'customerId': PropertySchema(
      id: 2,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'customerImporterId': PropertySchema(
      id: 3,
      name: r'customerImporterId',
      type: IsarType.long,
    ),
    r'customerKey': PropertySchema(
      id: 4,
      name: r'customerKey',
      type: IsarType.string,
    ),
    r'customerShopId': PropertySchema(
      id: 5,
      name: r'customerShopId',
      type: IsarType.long,
    ),
    r'customerType': PropertySchema(
      id: 6,
      name: r'customerType',
      type: IsarType.string,
    ),
    r'customerVanId': PropertySchema(
      id: 7,
      name: r'customerVanId',
      type: IsarType.long,
    ),
    r'noteType': PropertySchema(
      id: 8,
      name: r'noteType',
      type: IsarType.string,
    ),
    r'pendingSync': PropertySchema(
      id: 9,
      name: r'pendingSync',
      type: IsarType.bool,
    ),
    r'serverId': PropertySchema(
      id: 10,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _localDiaryNoteEstimateSize,
  serialize: _localDiaryNoteSerialize,
  deserialize: _localDiaryNoteDeserialize,
  deserializeProp: _localDiaryNoteDeserializeProp,
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
    r'customerType': IndexSchema(
      id: 5398852767662350181,
      name: r'customerType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'customerId': IndexSchema(
      id: 1498639901530368639,
      name: r'customerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'customerKey_customerType_customerId': IndexSchema(
      id: -1936648242049913184,
      name: r'customerKey_customerType_customerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'customerType',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'customerId',
          type: IndexType.value,
          caseSensitive: false,
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
  getId: _localDiaryNoteGetId,
  getLinks: _localDiaryNoteGetLinks,
  attach: _localDiaryNoteAttach,
  version: '3.3.2',
);

int _localDiaryNoteEstimateSize(
  LocalDiaryNote object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.body;
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
  bytesCount += 3 + object.customerKey.length * 3;
  bytesCount += 3 + object.customerType.length * 3;
  bytesCount += 3 + object.noteType.length * 3;
  return bytesCount;
}

void _localDiaryNoteSerialize(
  LocalDiaryNote object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeString(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.customerId);
  writer.writeLong(offsets[3], object.customerImporterId);
  writer.writeString(offsets[4], object.customerKey);
  writer.writeLong(offsets[5], object.customerShopId);
  writer.writeString(offsets[6], object.customerType);
  writer.writeLong(offsets[7], object.customerVanId);
  writer.writeString(offsets[8], object.noteType);
  writer.writeBool(offsets[9], object.pendingSync);
  writer.writeLong(offsets[10], object.serverId);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

LocalDiaryNote _localDiaryNoteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalDiaryNote();
  object.body = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readStringOrNull(offsets[1]);
  object.customerId = reader.readLong(offsets[2]);
  object.customerImporterId = reader.readLongOrNull(offsets[3]);
  object.customerKey = reader.readString(offsets[4]);
  object.customerShopId = reader.readLongOrNull(offsets[5]);
  object.customerType = reader.readString(offsets[6]);
  object.customerVanId = reader.readLongOrNull(offsets[7]);
  object.isarId = id;
  object.noteType = reader.readString(offsets[8]);
  object.pendingSync = reader.readBool(offsets[9]);
  object.serverId = reader.readLong(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  return object;
}

P _localDiaryNoteDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localDiaryNoteGetId(LocalDiaryNote object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localDiaryNoteGetLinks(LocalDiaryNote object) {
  return [];
}

void _localDiaryNoteAttach(
    IsarCollection<dynamic> col, Id id, LocalDiaryNote object) {
  object.isarId = id;
}

extension LocalDiaryNoteByIndex on IsarCollection<LocalDiaryNote> {
  Future<LocalDiaryNote?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalDiaryNote? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalDiaryNote?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalDiaryNote?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalDiaryNote object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalDiaryNote object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalDiaryNote> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalDiaryNote> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalDiaryNoteQueryWhereSort
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QWhere> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhere> anyCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'customerId'),
      );
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhere> anyPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pendingSync'),
      );
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension LocalDiaryNoteQueryWhere
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QWhereClause> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerTypeEqualTo(String customerType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerType',
        value: [customerType],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerTypeNotEqualTo(String customerType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerType',
              lower: [],
              upper: [customerType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerType',
              lower: [customerType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerType',
              lower: [customerType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerType',
              lower: [],
              upper: [customerType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerIdEqualTo(int customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerId',
        value: [customerId],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerIdNotEqualTo(int customerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [],
              upper: [customerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [customerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [customerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [],
              upper: [customerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerIdGreaterThan(
    int customerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerId',
        lower: [customerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerIdLessThan(
    int customerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerId',
        lower: [],
        upper: [customerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerIdBetween(
    int lowerCustomerId,
    int upperCustomerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerId',
        lower: [lowerCustomerId],
        includeLower: includeLower,
        upper: [upperCustomerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyEqualToAnyCustomerTypeCustomerId(String customerKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerKey_customerType_customerId',
        value: [customerKey],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyNotEqualToAnyCustomerTypeCustomerId(String customerKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [],
              upper: [customerKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [],
              upper: [customerKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeEqualToAnyCustomerId(
          String customerKey, String customerType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerKey_customerType_customerId',
        value: [customerKey, customerType],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyEqualToCustomerTypeNotEqualToAnyCustomerId(
          String customerKey, String customerType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey],
              upper: [customerKey, customerType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType],
              includeLower: false,
              upper: [customerKey],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType],
              includeLower: false,
              upper: [customerKey],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey],
              upper: [customerKey, customerType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeCustomerIdEqualTo(
          String customerKey, String customerType, int customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerKey_customerType_customerId',
        value: [customerKey, customerType, customerId],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeEqualToCustomerIdNotEqualTo(
          String customerKey, String customerType, int customerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType],
              upper: [customerKey, customerType, customerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType, customerId],
              includeLower: false,
              upper: [customerKey, customerType],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType, customerId],
              includeLower: false,
              upper: [customerKey, customerType],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerKey_customerType_customerId',
              lower: [customerKey, customerType],
              upper: [customerKey, customerType, customerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeEqualToCustomerIdGreaterThan(
    String customerKey,
    String customerType,
    int customerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerKey_customerType_customerId',
        lower: [customerKey, customerType, customerId],
        includeLower: include,
        upper: [customerKey, customerType],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeEqualToCustomerIdLessThan(
    String customerKey,
    String customerType,
    int customerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerKey_customerType_customerId',
        lower: [customerKey, customerType],
        upper: [customerKey, customerType, customerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      customerKeyCustomerTypeEqualToCustomerIdBetween(
    String customerKey,
    String customerType,
    int lowerCustomerId,
    int upperCustomerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerKey_customerType_customerId',
        lower: [customerKey, customerType, lowerCustomerId],
        includeLower: includeLower,
        upper: [customerKey, customerType, upperCustomerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      pendingSyncEqualTo(bool pendingSync) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pendingSync',
        value: [pendingSync],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterWhereClause>
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

extension LocalDiaryNoteQueryFilter
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QFilterCondition> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerImporterId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerImporterId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerImporterId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerImporterId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerImporterId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerImporterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerImporterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerShopIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerShopIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerShopIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerShopId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerVanId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerVanId',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerVanId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerVanId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerVanId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      customerVanIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerVanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      noteTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      pendingSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterFilterCondition>
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

extension LocalDiaryNoteQueryObject
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QFilterCondition> {}

extension LocalDiaryNoteQueryLinks
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QFilterCondition> {}

extension LocalDiaryNoteQuerySortBy
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QSortBy> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerImporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerKey', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerKey', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerType', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerType', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByCustomerVanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByNoteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteType', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByNoteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteType', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalDiaryNoteQuerySortThenBy
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QSortThenBy> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerImporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerKey', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerKey', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerType', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerType', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByCustomerVanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByNoteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteType', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByNoteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteType', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalDiaryNoteQueryWhereDistinct
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> {
  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> distinctByBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerImporterId');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> distinctByCustomerKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerShopId');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByCustomerType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerVanId');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> distinctByNoteType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingSync');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<LocalDiaryNote, LocalDiaryNote, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalDiaryNoteQueryProperty
    on QueryBuilder<LocalDiaryNote, LocalDiaryNote, QQueryProperty> {
  QueryBuilder<LocalDiaryNote, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalDiaryNote, String?, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<LocalDiaryNote, String?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalDiaryNote, int, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<LocalDiaryNote, int?, QQueryOperations>
      customerImporterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerImporterId');
    });
  }

  QueryBuilder<LocalDiaryNote, String, QQueryOperations> customerKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerKey');
    });
  }

  QueryBuilder<LocalDiaryNote, int?, QQueryOperations>
      customerShopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerShopId');
    });
  }

  QueryBuilder<LocalDiaryNote, String, QQueryOperations>
      customerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerType');
    });
  }

  QueryBuilder<LocalDiaryNote, int?, QQueryOperations> customerVanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerVanId');
    });
  }

  QueryBuilder<LocalDiaryNote, String, QQueryOperations> noteTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteType');
    });
  }

  QueryBuilder<LocalDiaryNote, bool, QQueryOperations> pendingSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingSync');
    });
  }

  QueryBuilder<LocalDiaryNote, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<LocalDiaryNote, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
