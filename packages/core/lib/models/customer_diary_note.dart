import 'package:equatable/equatable.dart';

import 'media.dart';
import 'sales_person.dart';
import 'user.dart';

class CustomerDiaryNoteModel extends Equatable {
  const CustomerDiaryNoteModel({
    required this.id,
    required this.customerType,
    required this.noteType,
    this.body,
    this.customerShopId,
    this.customerVanId,
    this.customerImporterId,
    this.salesPerson,
    this.createdBy,
    this.recording,
    this.createdAt,
    this.isLocalOnly = false,
  });

  final int id;
  final String customerType;
  final String noteType;
  final String? body;
  final int? customerShopId;
  final int? customerVanId;
  final int? customerImporterId;
  final SalesPersonModel? salesPerson;
  final UserModel? createdBy;
  final MediaModel? recording;
  final String? createdAt;
  final bool isLocalOnly;

  bool get isVoice => noteType == 'voice';

  String get authorName => salesPerson?.name ?? createdBy?.name ?? 'Unknown';

  factory CustomerDiaryNoteModel.fromJson(Map<String, dynamic> json) {
    MediaModel? recording;
    if (json['recording'] is Map) {
      recording = MediaModel.fromJson(json['recording'] as Map<String, dynamic>);
    }

    return CustomerDiaryNoteModel(
      id: json['id'] as int,
      customerType: json['customer_type'] as String? ?? '',
      noteType: json['note_type'] as String? ?? 'text',
      body: json['body'] as String?,
      customerShopId: json['customer_shop_id'] as int?,
      customerVanId: json['customer_van_id'] as int?,
      customerImporterId: json['customer_importer_id'] as int?,
      salesPerson: json['sales_person'] is Map
          ? SalesPersonModel.fromJson(json['sales_person'] as Map<String, dynamic>)
          : null,
      createdBy: json['created_by'] is Map
          ? UserModel.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      recording: recording,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{
      'customer_type': customerType,
      'note_type': noteType,
      if (body != null) 'body': body,
    };
    if (customerShopId != null) map['customer_shop_id'] = customerShopId;
    if (customerVanId != null) map['customer_van_id'] = customerVanId;
    if (customerImporterId != null) map['customer_importer_id'] = customerImporterId;
    return map;
  }

  @override
  List<Object?> get props => [id, noteType, createdAt];
}
