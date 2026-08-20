import 'package:equatable/equatable.dart';

import 'media.dart';
import 'sales_person.dart';

class WatchlistItemModel extends Equatable {
  const WatchlistItemModel({
    required this.id,
    required this.salesPersonId,
    required this.gps,
    this.placeName,
    this.noteText,
    this.phone,
    this.status = 'active',
    this.archivedReason,
    this.customerShopId,
    this.salesPerson,
    this.recordings = const [],
    this.images = const [],
    this.createdAt,
    this.isLocalOnly = false,
    this.localId,
  });

  final int id;
  final int salesPersonId;
  final String gps;
  final String? placeName;
  final String? noteText;
  final String? phone;
  final String status;
  final String? archivedReason;
  final int? customerShopId;
  final SalesPersonModel? salesPerson;
  final List<MediaModel> recordings;
  final List<MediaModel> images;
  final String? createdAt;
  final bool isLocalOnly;
  final int? localId;

  String get displayTitle => placeName?.isNotEmpty == true ? placeName! : gps;

  bool get isActive => status == 'active';

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    final recordings = <MediaModel>[];
    final images = <MediaModel>[];
    for (final m in json['recordings'] as List<dynamic>? ?? []) {
      recordings.add(MediaModel.fromJson(m as Map<String, dynamic>));
    }
    for (final m in json['images'] as List<dynamic>? ?? []) {
      images.add(MediaModel.fromJson(m as Map<String, dynamic>));
    }

    return WatchlistItemModel(
      id: json['id'] as int,
      salesPersonId: json['sales_person_id'] as int,
      gps: json['gps'] as String? ?? '',
      placeName: json['place_name'] as String?,
      noteText: json['note_text'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'active',
      archivedReason: json['archived_reason'] as String?,
      customerShopId: json['customer_shop_id'] as int?,
      salesPerson: json['sales_person'] is Map
          ? SalesPersonModel.fromJson(json['sales_person'] as Map<String, dynamic>)
          : null,
      recordings: recordings,
      images: images,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'gps': gps,
        if (placeName != null) 'place_name': placeName,
        if (noteText != null) 'note_text': noteText,
        if (phone != null) 'phone': phone,
        'sales_person_id': salesPersonId,
      };

  WatchlistItemModel copyWith({
    int? id,
    String? status,
    String? archivedReason,
    int? customerShopId,
    bool? isLocalOnly,
  }) {
    return WatchlistItemModel(
      id: id ?? this.id,
      salesPersonId: salesPersonId,
      gps: gps,
      placeName: placeName,
      noteText: noteText,
      phone: phone,
      status: status ?? this.status,
      archivedReason: archivedReason ?? this.archivedReason,
      customerShopId: customerShopId ?? this.customerShopId,
      salesPerson: salesPerson,
      recordings: recordings,
      images: images,
      createdAt: createdAt,
      isLocalOnly: isLocalOnly ?? this.isLocalOnly,
      localId: localId,
    );
  }

  @override
  List<Object?> get props => [id, gps, status, isLocalOnly];
}
