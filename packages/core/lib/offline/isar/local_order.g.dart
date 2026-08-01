// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_order.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalOrderCollection on Isar {
  IsarCollection<LocalOrder> get localOrders => this.collection();
}

const LocalOrderSchema = CollectionSchema(
  name: r'LocalOrder',
  id: 7033480302299574499,
  properties: {
    r'amountDue': PropertySchema(
      id: 0,
      name: r'amountDue',
      type: IsarType.double,
    ),
    r'amountPaid': PropertySchema(
      id: 1,
      name: r'amountPaid',
      type: IsarType.double,
    ),
    r'cancellationReason': PropertySchema(
      id: 2,
      name: r'cancellationReason',
      type: IsarType.string,
    ),
    r'cancelledAt': PropertySchema(
      id: 3,
      name: r'cancelledAt',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'customerImporterId': PropertySchema(
      id: 5,
      name: r'customerImporterId',
      type: IsarType.long,
    ),
    r'customerShopId': PropertySchema(
      id: 6,
      name: r'customerShopId',
      type: IsarType.long,
    ),
    r'customerShopName': PropertySchema(
      id: 7,
      name: r'customerShopName',
      type: IsarType.string,
    ),
    r'customerTypeId': PropertySchema(
      id: 8,
      name: r'customerTypeId',
      type: IsarType.long,
    ),
    r'customerVanId': PropertySchema(
      id: 9,
      name: r'customerVanId',
      type: IsarType.long,
    ),
    r'daysOverdue': PropertySchema(
      id: 10,
      name: r'daysOverdue',
      type: IsarType.long,
    ),
    r'dueDate': PropertySchema(
      id: 11,
      name: r'dueDate',
      type: IsarType.string,
    ),
    r'grandDiscount': PropertySchema(
      id: 12,
      name: r'grandDiscount',
      type: IsarType.double,
    ),
    r'isOverdue': PropertySchema(
      id: 13,
      name: r'isOverdue',
      type: IsarType.bool,
    ),
    r'isWalkInCustomer': PropertySchema(
      id: 14,
      name: r'isWalkInCustomer',
      type: IsarType.bool,
    ),
    r'items': PropertySchema(
      id: 15,
      name: r'items',
      type: IsarType.objectList,
      target: r'LocalOrderLine',
    ),
    r'manualOrderRequestId': PropertySchema(
      id: 16,
      name: r'manualOrderRequestId',
      type: IsarType.long,
    ),
    r'paymentStatus': PropertySchema(
      id: 17,
      name: r'paymentStatus',
      type: IsarType.string,
    ),
    r'payments': PropertySchema(
      id: 18,
      name: r'payments',
      type: IsarType.objectList,
      target: r'LocalPayment',
    ),
    r'pendingSync': PropertySchema(
      id: 19,
      name: r'pendingSync',
      type: IsarType.bool,
    ),
    r'promotionDiscount': PropertySchema(
      id: 20,
      name: r'promotionDiscount',
      type: IsarType.double,
    ),
    r'salesPersonId': PropertySchema(
      id: 21,
      name: r'salesPersonId',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 22,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 23,
      name: r'status',
      type: IsarType.string,
    ),
    r'subtotal': PropertySchema(
      id: 24,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'totalBill': PropertySchema(
      id: 25,
      name: r'totalBill',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 26,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vatTotal': PropertySchema(
      id: 27,
      name: r'vatTotal',
      type: IsarType.double,
    )
  },
  estimateSize: _localOrderEstimateSize,
  serialize: _localOrderSerialize,
  deserialize: _localOrderDeserialize,
  deserializeProp: _localOrderDeserializeProp,
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
    r'paymentStatus': IndexSchema(
      id: 7011973130100993011,
      name: r'paymentStatus',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'paymentStatus',
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
  embeddedSchemas: {
    r'LocalOrderLine': LocalOrderLineSchema,
    r'LocalPayment': LocalPaymentSchema
  },
  getId: _localOrderGetId,
  getLinks: _localOrderGetLinks,
  attach: _localOrderAttach,
  version: '3.3.2',
);

int _localOrderEstimateSize(
  LocalOrder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cancellationReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cancelledAt;
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
  {
    final value = object.customerShopName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dueDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[LocalOrderLine]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount +=
          LocalOrderLineSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.paymentStatus.length * 3;
  bytesCount += 3 + object.payments.length * 3;
  {
    final offsets = allOffsets[LocalPayment]!;
    for (var i = 0; i < object.payments.length; i++) {
      final value = object.payments[i];
      bytesCount += LocalPaymentSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _localOrderSerialize(
  LocalOrder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountDue);
  writer.writeDouble(offsets[1], object.amountPaid);
  writer.writeString(offsets[2], object.cancellationReason);
  writer.writeString(offsets[3], object.cancelledAt);
  writer.writeString(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.customerImporterId);
  writer.writeLong(offsets[6], object.customerShopId);
  writer.writeString(offsets[7], object.customerShopName);
  writer.writeLong(offsets[8], object.customerTypeId);
  writer.writeLong(offsets[9], object.customerVanId);
  writer.writeLong(offsets[10], object.daysOverdue);
  writer.writeString(offsets[11], object.dueDate);
  writer.writeDouble(offsets[12], object.grandDiscount);
  writer.writeBool(offsets[13], object.isOverdue);
  writer.writeBool(offsets[14], object.isWalkInCustomer);
  writer.writeObjectList<LocalOrderLine>(
    offsets[15],
    allOffsets,
    LocalOrderLineSchema.serialize,
    object.items,
  );
  writer.writeLong(offsets[16], object.manualOrderRequestId);
  writer.writeString(offsets[17], object.paymentStatus);
  writer.writeObjectList<LocalPayment>(
    offsets[18],
    allOffsets,
    LocalPaymentSchema.serialize,
    object.payments,
  );
  writer.writeBool(offsets[19], object.pendingSync);
  writer.writeDouble(offsets[20], object.promotionDiscount);
  writer.writeLong(offsets[21], object.salesPersonId);
  writer.writeLong(offsets[22], object.serverId);
  writer.writeString(offsets[23], object.status);
  writer.writeDouble(offsets[24], object.subtotal);
  writer.writeDouble(offsets[25], object.totalBill);
  writer.writeDateTime(offsets[26], object.updatedAt);
  writer.writeDouble(offsets[27], object.vatTotal);
}

LocalOrder _localOrderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalOrder();
  object.amountDue = reader.readDouble(offsets[0]);
  object.amountPaid = reader.readDouble(offsets[1]);
  object.cancellationReason = reader.readStringOrNull(offsets[2]);
  object.cancelledAt = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readStringOrNull(offsets[4]);
  object.customerImporterId = reader.readLongOrNull(offsets[5]);
  object.customerShopId = reader.readLongOrNull(offsets[6]);
  object.customerShopName = reader.readStringOrNull(offsets[7]);
  object.customerTypeId = reader.readLong(offsets[8]);
  object.customerVanId = reader.readLongOrNull(offsets[9]);
  object.daysOverdue = reader.readLong(offsets[10]);
  object.dueDate = reader.readStringOrNull(offsets[11]);
  object.grandDiscount = reader.readDouble(offsets[12]);
  object.isOverdue = reader.readBool(offsets[13]);
  object.isWalkInCustomer = reader.readBool(offsets[14]);
  object.isarId = id;
  object.items = reader.readObjectList<LocalOrderLine>(
        offsets[15],
        LocalOrderLineSchema.deserialize,
        allOffsets,
        LocalOrderLine(),
      ) ??
      [];
  object.manualOrderRequestId = reader.readLongOrNull(offsets[16]);
  object.paymentStatus = reader.readString(offsets[17]);
  object.payments = reader.readObjectList<LocalPayment>(
        offsets[18],
        LocalPaymentSchema.deserialize,
        allOffsets,
        LocalPayment(),
      ) ??
      [];
  object.pendingSync = reader.readBool(offsets[19]);
  object.promotionDiscount = reader.readDouble(offsets[20]);
  object.salesPersonId = reader.readLongOrNull(offsets[21]);
  object.serverId = reader.readLong(offsets[22]);
  object.status = reader.readString(offsets[23]);
  object.subtotal = reader.readDouble(offsets[24]);
  object.totalBill = reader.readDouble(offsets[25]);
  object.updatedAt = reader.readDateTime(offsets[26]);
  object.vatTotal = reader.readDouble(offsets[27]);
  return object;
}

P _localOrderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readObjectList<LocalOrderLine>(
            offset,
            LocalOrderLineSchema.deserialize,
            allOffsets,
            LocalOrderLine(),
          ) ??
          []) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readObjectList<LocalPayment>(
            offset,
            LocalPaymentSchema.deserialize,
            allOffsets,
            LocalPayment(),
          ) ??
          []) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    case 26:
      return (reader.readDateTime(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localOrderGetId(LocalOrder object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localOrderGetLinks(LocalOrder object) {
  return [];
}

void _localOrderAttach(IsarCollection<dynamic> col, Id id, LocalOrder object) {
  object.isarId = id;
}

extension LocalOrderByIndex on IsarCollection<LocalOrder> {
  Future<LocalOrder?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  LocalOrder? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<LocalOrder?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<LocalOrder?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(LocalOrder object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(LocalOrder object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<LocalOrder> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<LocalOrder> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension LocalOrderQueryWhereSort
    on QueryBuilder<LocalOrder, LocalOrder, QWhere> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhere> anyPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pendingSync'),
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension LocalOrderQueryWhere
    on QueryBuilder<LocalOrder, LocalOrder, QWhereClause> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> serverIdEqualTo(
      int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> serverIdNotEqualTo(
      int serverId) {
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> serverIdGreaterThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> serverIdLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> serverIdBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> statusEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> statusNotEqualTo(
      String status) {
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> paymentStatusEqualTo(
      String paymentStatus) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'paymentStatus',
        value: [paymentStatus],
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause>
      paymentStatusNotEqualTo(String paymentStatus) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentStatus',
              lower: [],
              upper: [paymentStatus],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentStatus',
              lower: [paymentStatus],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentStatus',
              lower: [paymentStatus],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentStatus',
              lower: [],
              upper: [paymentStatus],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> pendingSyncEqualTo(
      bool pendingSync) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pendingSync',
        value: [pendingSync],
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> pendingSyncNotEqualTo(
      bool pendingSync) {
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> updatedAtEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> updatedAtNotEqualTo(
      DateTime updatedAt) {
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> updatedAtGreaterThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> updatedAtLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterWhereClause> updatedAtBetween(
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

extension LocalOrderQueryFilter
    on QueryBuilder<LocalOrder, LocalOrder, QFilterCondition> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> amountDueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      amountDueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> amountDueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> amountDueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountDue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> amountPaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      amountPaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      amountPaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> amountPaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountPaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cancellationReason',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cancellationReason',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancellationReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cancellationReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cancellationReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancellationReason',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancellationReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cancellationReason',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancelledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cancelledAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cancelledAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelledAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      cancelledAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cancelledAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtEqualTo(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtEndsWith(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerImporterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerImporterId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerImporterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerImporterId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerImporterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerImporterId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerShopId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerShopId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerShopName',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerShopName',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerShopName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerShopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerShopName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerShopName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerShopNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerShopName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerTypeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerTypeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerTypeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerTypeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerTypeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerVanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerVanId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerVanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerVanId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      customerVanIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerVanId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      daysOverdueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      daysOverdueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      daysOverdueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      daysOverdueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysOverdue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      dueDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dueDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dueDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> dueDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      dueDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dueDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      grandDiscountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grandDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      grandDiscountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grandDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      grandDiscountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grandDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      grandDiscountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grandDiscount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> isOverdueEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      isWalkInCustomerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWalkInCustomer',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'manualOrderRequestId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'manualOrderRequestId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manualOrderRequestId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'manualOrderRequestId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'manualOrderRequestId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      manualOrderRequestIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'manualOrderRequestId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      paymentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'payments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      pendingSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      promotionDiscountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promotionDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      promotionDiscountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promotionDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      promotionDiscountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promotionDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      promotionDiscountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promotionDiscount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      salesPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      salesPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'salesPersonId',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      salesPersonIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> serverIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> serverIdLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> serverIdBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusGreaterThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> subtotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> totalBillEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      totalBillGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> totalBillLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> totalBillBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> vatTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vatTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition>
      vatTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vatTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> vatTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vatTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> vatTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vatTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension LocalOrderQueryObject
    on QueryBuilder<LocalOrder, LocalOrder, QFilterCondition> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> itemsElement(
      FilterQuery<LocalOrderLine> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterFilterCondition> paymentsElement(
      FilterQuery<LocalPayment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'payments');
    });
  }
}

extension LocalOrderQueryLinks
    on QueryBuilder<LocalOrder, LocalOrder, QFilterCondition> {}

extension LocalOrderQuerySortBy
    on QueryBuilder<LocalOrder, LocalOrder, QSortBy> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByAmountDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountDue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByAmountDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountDue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCancellationReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationReason', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCancellationReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationReason', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCustomerImporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCustomerShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCustomerShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCustomerTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerTypeId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByCustomerTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerTypeId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByCustomerVanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByDaysOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOverdue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByDaysOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOverdue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByGrandDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandDiscount', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByGrandDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandDiscount', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByIsWalkInCustomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWalkInCustomer', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByIsWalkInCustomerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWalkInCustomer', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByManualOrderRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualOrderRequestId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByManualOrderRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualOrderRequestId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByPromotionDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionDiscount', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      sortByPromotionDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionDiscount', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByTotalBill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBill', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByTotalBillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBill', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByVatTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatTotal', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> sortByVatTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatTotal', Sort.desc);
    });
  }
}

extension LocalOrderQuerySortThenBy
    on QueryBuilder<LocalOrder, LocalOrder, QSortThenBy> {
  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByAmountDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountDue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByAmountDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountDue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCancellationReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationReason', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCancellationReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationReason', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCustomerImporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerImporterId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCustomerShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCustomerShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCustomerShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerShopName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCustomerTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerTypeId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByCustomerTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerTypeId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByCustomerVanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerVanId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByDaysOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOverdue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByDaysOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOverdue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByGrandDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandDiscount', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByGrandDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandDiscount', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByIsWalkInCustomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWalkInCustomer', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByIsWalkInCustomerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWalkInCustomer', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByManualOrderRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualOrderRequestId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByManualOrderRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualOrderRequestId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByPromotionDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionDiscount', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy>
      thenByPromotionDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionDiscount', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenBySalesPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesPersonId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByTotalBill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBill', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByTotalBillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBill', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByVatTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatTotal', Sort.asc);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QAfterSortBy> thenByVatTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatTotal', Sort.desc);
    });
  }
}

extension LocalOrderQueryWhereDistinct
    on QueryBuilder<LocalOrder, LocalOrder, QDistinct> {
  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByAmountDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountDue');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountPaid');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCancellationReason(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancellationReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCancelledAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelledAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct>
      distinctByCustomerImporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerImporterId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCustomerShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerShopId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCustomerShopName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerShopName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCustomerTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerTypeId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByCustomerVanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerVanId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByDaysOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysOverdue');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByDueDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByGrandDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grandDiscount');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOverdue');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByIsWalkInCustomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWalkInCustomer');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct>
      distinctByManualOrderRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manualOrderRequestId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByPaymentStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingSync');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct>
      distinctByPromotionDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promotionDiscount');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctBySalesPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesPersonId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByTotalBill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBill');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalOrder, LocalOrder, QDistinct> distinctByVatTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vatTotal');
    });
  }
}

extension LocalOrderQueryProperty
    on QueryBuilder<LocalOrder, LocalOrder, QQueryProperty> {
  QueryBuilder<LocalOrder, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> amountDueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountDue');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> amountPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountPaid');
    });
  }

  QueryBuilder<LocalOrder, String?, QQueryOperations>
      cancellationReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancellationReason');
    });
  }

  QueryBuilder<LocalOrder, String?, QQueryOperations> cancelledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelledAt');
    });
  }

  QueryBuilder<LocalOrder, String?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalOrder, int?, QQueryOperations>
      customerImporterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerImporterId');
    });
  }

  QueryBuilder<LocalOrder, int?, QQueryOperations> customerShopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerShopId');
    });
  }

  QueryBuilder<LocalOrder, String?, QQueryOperations>
      customerShopNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerShopName');
    });
  }

  QueryBuilder<LocalOrder, int, QQueryOperations> customerTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerTypeId');
    });
  }

  QueryBuilder<LocalOrder, int?, QQueryOperations> customerVanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerVanId');
    });
  }

  QueryBuilder<LocalOrder, int, QQueryOperations> daysOverdueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysOverdue');
    });
  }

  QueryBuilder<LocalOrder, String?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> grandDiscountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grandDiscount');
    });
  }

  QueryBuilder<LocalOrder, bool, QQueryOperations> isOverdueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOverdue');
    });
  }

  QueryBuilder<LocalOrder, bool, QQueryOperations> isWalkInCustomerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWalkInCustomer');
    });
  }

  QueryBuilder<LocalOrder, List<LocalOrderLine>, QQueryOperations>
      itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<LocalOrder, int?, QQueryOperations>
      manualOrderRequestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manualOrderRequestId');
    });
  }

  QueryBuilder<LocalOrder, String, QQueryOperations> paymentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStatus');
    });
  }

  QueryBuilder<LocalOrder, List<LocalPayment>, QQueryOperations>
      paymentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payments');
    });
  }

  QueryBuilder<LocalOrder, bool, QQueryOperations> pendingSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingSync');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations>
      promotionDiscountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promotionDiscount');
    });
  }

  QueryBuilder<LocalOrder, int?, QQueryOperations> salesPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesPersonId');
    });
  }

  QueryBuilder<LocalOrder, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<LocalOrder, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> totalBillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBill');
    });
  }

  QueryBuilder<LocalOrder, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalOrder, double, QQueryOperations> vatTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vatTotal');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalOrderLineSchema = Schema(
  name: r'LocalOrderLine',
  id: -1022481530537817644,
  properties: {
    r'bill': PropertySchema(
      id: 0,
      name: r'bill',
      type: IsarType.double,
    ),
    r'isPreorder': PropertySchema(
      id: 1,
      name: r'isPreorder',
      type: IsarType.bool,
    ),
    r'productDiscount': PropertySchema(
      id: 2,
      name: r'productDiscount',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 3,
      name: r'productId',
      type: IsarType.long,
    ),
    r'productPrice': PropertySchema(
      id: 4,
      name: r'productPrice',
      type: IsarType.double,
    ),
    r'productVat': PropertySchema(
      id: 5,
      name: r'productVat',
      type: IsarType.double,
    ),
    r'quantity': PropertySchema(
      id: 6,
      name: r'quantity',
      type: IsarType.long,
    )
  },
  estimateSize: _localOrderLineEstimateSize,
  serialize: _localOrderLineSerialize,
  deserialize: _localOrderLineDeserialize,
  deserializeProp: _localOrderLineDeserializeProp,
);

int _localOrderLineEstimateSize(
  LocalOrderLine object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _localOrderLineSerialize(
  LocalOrderLine object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.bill);
  writer.writeBool(offsets[1], object.isPreorder);
  writer.writeDouble(offsets[2], object.productDiscount);
  writer.writeLong(offsets[3], object.productId);
  writer.writeDouble(offsets[4], object.productPrice);
  writer.writeDouble(offsets[5], object.productVat);
  writer.writeLong(offsets[6], object.quantity);
}

LocalOrderLine _localOrderLineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalOrderLine();
  object.bill = reader.readDouble(offsets[0]);
  object.isPreorder = reader.readBool(offsets[1]);
  object.productDiscount = reader.readDouble(offsets[2]);
  object.productId = reader.readLong(offsets[3]);
  object.productPrice = reader.readDouble(offsets[4]);
  object.productVat = reader.readDouble(offsets[5]);
  object.quantity = reader.readLong(offsets[6]);
  return object;
}

P _localOrderLineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalOrderLineQueryFilter
    on QueryBuilder<LocalOrderLine, LocalOrderLine, QFilterCondition> {
  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      billEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      billGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      billLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bill',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      billBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      isPreorderEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPreorder',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productDiscountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productDiscountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productDiscountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productDiscount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productDiscountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productDiscount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productVatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productVatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productVatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      productVatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productVat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrderLine, LocalOrderLine, QAfterFilterCondition>
      quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalOrderLineQueryObject
    on QueryBuilder<LocalOrderLine, LocalOrderLine, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalPaymentSchema = Schema(
  name: r'LocalPayment',
  id: 338859264281517535,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 1,
      name: r'notes',
      type: IsarType.string,
    ),
    r'paidAt': PropertySchema(
      id: 2,
      name: r'paidAt',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 3,
      name: r'paymentMethod',
      type: IsarType.string,
    )
  },
  estimateSize: _localPaymentEstimateSize,
  serialize: _localPaymentSerialize,
  deserialize: _localPaymentDeserialize,
  deserializeProp: _localPaymentDeserializeProp,
);

int _localPaymentEstimateSize(
  LocalPayment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paidAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paymentMethod;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localPaymentSerialize(
  LocalPayment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.notes);
  writer.writeString(offsets[2], object.paidAt);
  writer.writeString(offsets[3], object.paymentMethod);
}

LocalPayment _localPaymentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalPayment();
  object.amount = reader.readDouble(offsets[0]);
  object.notes = reader.readStringOrNull(offsets[1]);
  object.paidAt = reader.readStringOrNull(offsets[2]);
  object.paymentMethod = reader.readStringOrNull(offsets[3]);
  return object;
}

P _localPaymentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalPaymentQueryFilter
    on QueryBuilder<LocalPayment, LocalPayment, QFilterCondition> {
  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paidAt',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paidAt',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> paidAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> paidAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paidAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition> paidAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paidAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paidAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paidAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentMethod',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentMethod',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPayment, LocalPayment, QAfterFilterCondition>
      paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }
}

extension LocalPaymentQueryObject
    on QueryBuilder<LocalPayment, LocalPayment, QFilterCondition> {}
