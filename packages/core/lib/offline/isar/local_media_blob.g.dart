// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_media_blob.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalMediaBlobCollection on Isar {
  IsarCollection<LocalMediaBlob> get localMediaBlobs => this.collection();
}

const LocalMediaBlobSchema = CollectionSchema(
  name: r'LocalMediaBlob',
  id: -8472504870777709991,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'errorMessage': PropertySchema(
      id: 1,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'extraFieldsJson': PropertySchema(
      id: 2,
      name: r'extraFieldsJson',
      type: IsarType.string,
    ),
    r'localPath': PropertySchema(
      id: 3,
      name: r'localPath',
      type: IsarType.string,
    ),
    r'mediaKind': PropertySchema(
      id: 4,
      name: r'mediaKind',
      type: IsarType.string,
    ),
    r'mimeType': PropertySchema(
      id: 5,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'nativeTaskId': PropertySchema(
      id: 6,
      name: r'nativeTaskId',
      type: IsarType.string,
    ),
    r'originalName': PropertySchema(
      id: 7,
      name: r'originalName',
      type: IsarType.string,
    ),
    r'parentEntityType': PropertySchema(
      id: 8,
      name: r'parentEntityType',
      type: IsarType.string,
    ),
    r'parentLocalId': PropertySchema(
      id: 9,
      name: r'parentLocalId',
      type: IsarType.long,
    ),
    r'parentServerId': PropertySchema(
      id: 10,
      name: r'parentServerId',
      type: IsarType.long,
    ),
    r'retryCount': PropertySchema(
      id: 11,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'sizeBytes': PropertySchema(
      id: 12,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 13,
      name: r'status',
      type: IsarType.string,
      enumMap: _LocalMediaBlobstatusEnumValueMap,
    ),
    r'uploadEndpoint': PropertySchema(
      id: 14,
      name: r'uploadEndpoint',
      type: IsarType.string,
    ),
    r'uploadField': PropertySchema(
      id: 15,
      name: r'uploadField',
      type: IsarType.string,
    )
  },
  estimateSize: _localMediaBlobEstimateSize,
  serialize: _localMediaBlobSerialize,
  deserialize: _localMediaBlobDeserialize,
  deserializeProp: _localMediaBlobDeserializeProp,
  idName: r'id',
  indexes: {
    r'parentEntityType': IndexSchema(
      id: 2604997059487160181,
      name: r'parentEntityType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentEntityType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'parentLocalId': IndexSchema(
      id: -3069539000178470228,
      name: r'parentLocalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentLocalId',
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
  getId: _localMediaBlobGetId,
  getLinks: _localMediaBlobGetLinks,
  attach: _localMediaBlobAttach,
  version: '3.3.2',
);

int _localMediaBlobEstimateSize(
  LocalMediaBlob object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.extraFieldsJson.length * 3;
  bytesCount += 3 + object.localPath.length * 3;
  bytesCount += 3 + object.mediaKind.length * 3;
  bytesCount += 3 + object.mimeType.length * 3;
  {
    final value = object.nativeTaskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.originalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.parentEntityType.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.uploadEndpoint.length * 3;
  bytesCount += 3 + object.uploadField.length * 3;
  return bytesCount;
}

void _localMediaBlobSerialize(
  LocalMediaBlob object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.errorMessage);
  writer.writeString(offsets[2], object.extraFieldsJson);
  writer.writeString(offsets[3], object.localPath);
  writer.writeString(offsets[4], object.mediaKind);
  writer.writeString(offsets[5], object.mimeType);
  writer.writeString(offsets[6], object.nativeTaskId);
  writer.writeString(offsets[7], object.originalName);
  writer.writeString(offsets[8], object.parentEntityType);
  writer.writeLong(offsets[9], object.parentLocalId);
  writer.writeLong(offsets[10], object.parentServerId);
  writer.writeLong(offsets[11], object.retryCount);
  writer.writeLong(offsets[12], object.sizeBytes);
  writer.writeString(offsets[13], object.status.name);
  writer.writeString(offsets[14], object.uploadEndpoint);
  writer.writeString(offsets[15], object.uploadField);
}

LocalMediaBlob _localMediaBlobDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalMediaBlob();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.errorMessage = reader.readStringOrNull(offsets[1]);
  object.extraFieldsJson = reader.readString(offsets[2]);
  object.id = id;
  object.localPath = reader.readString(offsets[3]);
  object.mediaKind = reader.readString(offsets[4]);
  object.mimeType = reader.readString(offsets[5]);
  object.nativeTaskId = reader.readStringOrNull(offsets[6]);
  object.originalName = reader.readStringOrNull(offsets[7]);
  object.parentEntityType = reader.readString(offsets[8]);
  object.parentLocalId = reader.readLongOrNull(offsets[9]);
  object.parentServerId = reader.readLongOrNull(offsets[10]);
  object.retryCount = reader.readLong(offsets[11]);
  object.sizeBytes = reader.readLong(offsets[12]);
  object.status =
      _LocalMediaBlobstatusValueEnumMap[reader.readStringOrNull(offsets[13])] ??
          MediaUploadStatus.pending;
  object.uploadEndpoint = reader.readString(offsets[14]);
  object.uploadField = reader.readString(offsets[15]);
  return object;
}

P _localMediaBlobDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (_LocalMediaBlobstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          MediaUploadStatus.pending) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalMediaBlobstatusEnumValueMap = {
  r'pending': r'pending',
  r'uploading': r'uploading',
  r'done': r'done',
  r'failed': r'failed',
};
const _LocalMediaBlobstatusValueEnumMap = {
  r'pending': MediaUploadStatus.pending,
  r'uploading': MediaUploadStatus.uploading,
  r'done': MediaUploadStatus.done,
  r'failed': MediaUploadStatus.failed,
};

Id _localMediaBlobGetId(LocalMediaBlob object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localMediaBlobGetLinks(LocalMediaBlob object) {
  return [];
}

void _localMediaBlobAttach(
    IsarCollection<dynamic> col, Id id, LocalMediaBlob object) {
  object.id = id;
}

extension LocalMediaBlobQueryWhereSort
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QWhere> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhere> anyParentLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'parentLocalId'),
      );
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension LocalMediaBlobQueryWhere
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QWhereClause> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> idBetween(
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentEntityTypeEqualTo(String parentEntityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentEntityType',
        value: [parentEntityType],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentEntityTypeNotEqualTo(String parentEntityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEntityType',
              lower: [],
              upper: [parentEntityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEntityType',
              lower: [parentEntityType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEntityType',
              lower: [parentEntityType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEntityType',
              lower: [],
              upper: [parentEntityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentLocalId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentLocalId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdEqualTo(int? parentLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentLocalId',
        value: [parentLocalId],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdNotEqualTo(int? parentLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentLocalId',
              lower: [],
              upper: [parentLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentLocalId',
              lower: [parentLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentLocalId',
              lower: [parentLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentLocalId',
              lower: [],
              upper: [parentLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdGreaterThan(
    int? parentLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentLocalId',
        lower: [parentLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdLessThan(
    int? parentLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentLocalId',
        lower: [],
        upper: [parentLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      parentLocalIdBetween(
    int? lowerParentLocalId,
    int? upperParentLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentLocalId',
        lower: [lowerParentLocalId],
        includeLower: includeLower,
        upper: [upperParentLocalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause> statusEqualTo(
      MediaUploadStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      statusNotEqualTo(MediaUploadStatus status) {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterWhereClause>
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

extension LocalMediaBlobQueryFilter
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QFilterCondition> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extraFieldsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraFieldsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraFieldsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraFieldsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      extraFieldsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraFieldsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaKind',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaKind',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mediaKindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaKind',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nativeTaskId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nativeTaskId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nativeTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nativeTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nativeTaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nativeTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      nativeTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nativeTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalName',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalName',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      originalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentEntityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentEntityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentEntityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentEntityType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentEntityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentEntityType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentLocalId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentLocalId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentLocalIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentServerId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentServerId',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      parentServerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentServerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      sizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      sizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      sizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusEqualTo(
    MediaUploadStatus value, {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusGreaterThan(
    MediaUploadStatus value, {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusLessThan(
    MediaUploadStatus value, {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusBetween(
    MediaUploadStatus lower,
    MediaUploadStatus upper, {
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
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

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uploadEndpoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uploadEndpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uploadEndpoint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadEndpoint',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadEndpointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uploadEndpoint',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uploadField',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uploadField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uploadField',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadField',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterFilterCondition>
      uploadFieldIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uploadField',
        value: '',
      ));
    });
  }
}

extension LocalMediaBlobQueryObject
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QFilterCondition> {}

extension LocalMediaBlobQueryLinks
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QFilterCondition> {}

extension LocalMediaBlobQuerySortBy
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QSortBy> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByExtraFieldsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraFieldsJson', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByExtraFieldsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraFieldsJson', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortByMediaKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaKind', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByMediaKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaKind', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByNativeTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nativeTaskId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByNativeTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nativeTaskId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEntityType', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEntityType', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentLocalId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentLocalId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentServerId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByParentServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentServerId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByUploadEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadEndpoint', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByUploadEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadEndpoint', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByUploadField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadField', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      sortByUploadFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadField', Sort.desc);
    });
  }
}

extension LocalMediaBlobQuerySortThenBy
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QSortThenBy> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByExtraFieldsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraFieldsJson', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByExtraFieldsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraFieldsJson', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByMediaKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaKind', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByMediaKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaKind', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByNativeTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nativeTaskId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByNativeTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nativeTaskId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEntityType', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEntityType', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentLocalId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentLocalId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentServerId', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByParentServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentServerId', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByUploadEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadEndpoint', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByUploadEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadEndpoint', Sort.desc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByUploadField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadField', Sort.asc);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QAfterSortBy>
      thenByUploadFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadField', Sort.desc);
    });
  }
}

extension LocalMediaBlobQueryWhereDistinct
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> {
  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByExtraFieldsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraFieldsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> distinctByLocalPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> distinctByMediaKind(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaKind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> distinctByMimeType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByNativeTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nativeTaskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByOriginalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByParentEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentEntityType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByParentLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentLocalId');
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByParentServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentServerId');
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct>
      distinctByUploadEndpoint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadEndpoint',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalMediaBlob, LocalMediaBlob, QDistinct> distinctByUploadField(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadField', caseSensitive: caseSensitive);
    });
  }
}

extension LocalMediaBlobQueryProperty
    on QueryBuilder<LocalMediaBlob, LocalMediaBlob, QQueryProperty> {
  QueryBuilder<LocalMediaBlob, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalMediaBlob, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalMediaBlob, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations>
      extraFieldsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraFieldsJson');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations> localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localPath');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations> mediaKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaKind');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations> mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<LocalMediaBlob, String?, QQueryOperations>
      nativeTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nativeTaskId');
    });
  }

  QueryBuilder<LocalMediaBlob, String?, QQueryOperations>
      originalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalName');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations>
      parentEntityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentEntityType');
    });
  }

  QueryBuilder<LocalMediaBlob, int?, QQueryOperations> parentLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentLocalId');
    });
  }

  QueryBuilder<LocalMediaBlob, int?, QQueryOperations>
      parentServerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentServerId');
    });
  }

  QueryBuilder<LocalMediaBlob, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<LocalMediaBlob, int, QQueryOperations> sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }

  QueryBuilder<LocalMediaBlob, MediaUploadStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations>
      uploadEndpointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadEndpoint');
    });
  }

  QueryBuilder<LocalMediaBlob, String, QQueryOperations> uploadFieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadField');
    });
  }
}
