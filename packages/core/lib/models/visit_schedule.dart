import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';

/// Mirrors the server's VisitSchedule. Purposes/statuses are plain strings,
/// matching the codebase style; `visit_purposes` from GET /config/mobile
/// carries the localizable labels and colours.
class VisitScheduleModel extends Equatable {
  const VisitScheduleModel({
    required this.id,
    this.salesPersonId,
    this.salesPersonName,
    this.customerType,
    this.customerShopId,
    this.customerVanId,
    this.customerImporterId,
    this.watchlistItemId,
    this.customerName,
    this.gps,
    required this.scheduledAt,
    this.durationMinutes,
    required this.purpose,
    this.status = 'planned',
    this.notes,
    this.outcomeNote,
    this.completedAt,
    this.editable = true,
    this.createdAt,
    this.isLocalOnly = false,
  });

  static const purposes = [
    'due_collection',
    'regular_visit',
    'delivery',
    'promotional_visit',
    'new_client_search',
    'other',
  ];

  static const statuses = ['planned', 'done', 'missed', 'cancelled'];

  /// Negative = created offline, not yet synced.
  final int id;
  final int? salesPersonId;
  final String? salesPersonName;
  final String? customerType;
  final int? customerShopId;
  final int? customerVanId;
  final int? customerImporterId;
  final int? watchlistItemId;
  final String? customerName;
  final String? gps;
  final String scheduledAt;
  final int? durationMinutes;
  final String purpose;
  final String status;
  final String? notes;
  final String? outcomeNote;
  final String? completedAt;
  final bool editable;
  final String? createdAt;
  final bool isLocalOnly;

  bool get isPlanned => status == 'planned';

  DateTime? get scheduledDate => DateTime.tryParse(scheduledAt);

  int? get customerId => customerShopId ?? customerVanId ?? customerImporterId;

  factory VisitScheduleModel.fromJson(Map<String, dynamic> json) {
    return VisitScheduleModel(
      id: json['id'] as int,
      salesPersonId: json['sales_person_id'] as int?,
      salesPersonName: json['sales_person'] as String?,
      customerType: json['customer_type'] as String?,
      customerShopId: json['customer_shop_id'] as int?,
      customerVanId: json['customer_van_id'] as int?,
      customerImporterId: json['customer_importer_id'] as int?,
      watchlistItemId: json['watchlist_item_id'] as int?,
      customerName: json['customer_name'] as String?,
      gps: json['gps'] as String?,
      scheduledAt: json['scheduled_at']?.toString() ?? '',
      durationMinutes: parseJsonIntOrNull(json['duration_minutes']),
      purpose: json['purpose'] as String? ?? 'other',
      status: json['status'] as String? ?? 'planned',
      notes: json['notes'] as String?,
      outcomeNote: json['outcome_note'] as String?,
      completedAt: json['completed_at']?.toString(),
      editable: json['editable'] as bool? ?? true,
      createdAt: json['created_at']?.toString(),
      isLocalOnly: json['_pending_sync'] == true || (json['id'] as int) < 0,
    );
  }

  /// Emits exactly one target: the customer FK trio or a watchlist item —
  /// or none for a targetless new-client-search round.
  Map<String, dynamic> toCreateJson() {
    return {
      if (customerType != null) 'customer_type': customerType,
      if (customerShopId != null) 'customer_shop_id': customerShopId,
      if (customerVanId != null) 'customer_van_id': customerVanId,
      if (customerImporterId != null) 'customer_importer_id': customerImporterId,
      if (watchlistItemId != null) 'watchlist_item_id': watchlistItemId,
      'scheduled_at': scheduledAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      'purpose': purpose,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (salesPersonId != null) 'sales_person_id': salesPersonId,
    };
  }

  Map<String, dynamic> toCacheJson({bool pending = false}) => {
        'id': id,
        'sales_person_id': salesPersonId,
        'sales_person': salesPersonName,
        'customer_type': customerType,
        'customer_shop_id': customerShopId,
        'customer_van_id': customerVanId,
        'customer_importer_id': customerImporterId,
        'watchlist_item_id': watchlistItemId,
        'customer_name': customerName,
        'gps': gps,
        'scheduled_at': scheduledAt,
        'duration_minutes': durationMinutes,
        'purpose': purpose,
        'status': status,
        'notes': notes,
        'outcome_note': outcomeNote,
        'completed_at': completedAt,
        'editable': editable,
        'created_at': createdAt,
        if (pending || isLocalOnly) '_pending_sync': true,
      };

  VisitScheduleModel copyWith({String? status, String? outcomeNote}) {
    return VisitScheduleModel(
      id: id,
      salesPersonId: salesPersonId,
      salesPersonName: salesPersonName,
      customerType: customerType,
      customerShopId: customerShopId,
      customerVanId: customerVanId,
      customerImporterId: customerImporterId,
      watchlistItemId: watchlistItemId,
      customerName: customerName,
      gps: gps,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      purpose: purpose,
      status: status ?? this.status,
      notes: notes,
      outcomeNote: outcomeNote ?? this.outcomeNote,
      completedAt: completedAt,
      editable: editable,
      createdAt: createdAt,
      isLocalOnly: isLocalOnly,
    );
  }

  @override
  List<Object?> get props => [id, scheduledAt, purpose, status];
}

/// A shop worth a collection visit — served with its context embedded so the
/// list never has to fetch shops one by one.
class CollectionCandidate {
  const CollectionCandidate({
    required this.shopId,
    required this.name,
    this.area,
    this.phone,
    this.gps,
    required this.due,
    required this.overdue,
    this.oldestDueDate,
    this.lastPaymentAt,
  });

  final int shopId;
  final String name;
  final String? area;
  final String? phone;
  final String? gps;
  final double due;
  final double overdue;
  final String? oldestDueDate;
  final String? lastPaymentAt;

  factory CollectionCandidate.fromJson(Map<String, dynamic> json) {
    return CollectionCandidate(
      shopId: json['shop_id'] as int,
      name: json['name'] as String? ?? 'Shop #${json['shop_id']}',
      area: json['area'] as String?,
      phone: json['phone'] as String?,
      gps: json['gps'] as String?,
      due: parseJsonDouble(json['due']),
      overdue: parseJsonDouble(json['overdue']),
      oldestDueDate: json['oldest_due_date']?.toString(),
      lastPaymentAt: json['last_payment_at']?.toString(),
    );
  }
}
