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
    this.orderId,
    this.salesPerson,
    this.createdBy,
    this.recording,
    this.attachments = const [],
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

  /// Set when the note belongs to an order; the server derives the customer
  /// columns from the order in that case.
  final int? orderId;
  final SalesPersonModel? salesPerson;
  final UserModel? createdBy;
  final MediaModel? recording;

  /// Photo/video media rows; the voice recording stays on [recording].
  final List<MediaModel> attachments;
  final String? createdAt;
  final bool isLocalOnly;

  bool get isVoice => noteType == 'voice';
  bool get isPhoto => noteType == 'photo';
  bool get isVideo => noteType == 'video';

  String get authorName => salesPerson?.name ?? createdBy?.name ?? 'Unknown';

  factory CustomerDiaryNoteModel.fromJson(Map<String, dynamic> json) {
    MediaModel? recording;
    if (json['recording'] is Map) {
      recording = MediaModel.fromJson(json['recording'] as Map<String, dynamic>);
    }

    final attachments = <MediaModel>[];
    if (json['media'] is List) {
      for (final row in json['media'] as List) {
        if (row is Map<String, dynamic>) {
          final media = MediaModel.fromJson(row);
          // The voice recording renders through [recording]; everything else
          // (gallery photos, video) is an attachment.
          if (media.type != 'recording_audio') {
            attachments.add(media);
          }
        }
      }
    }

    return CustomerDiaryNoteModel(
      id: json['id'] as int,
      customerType: json['customer_type'] as String? ?? '',
      noteType: json['note_type'] as String? ?? 'text',
      body: json['body'] as String?,
      customerShopId: json['customer_shop_id'] as int?,
      customerVanId: json['customer_van_id'] as int?,
      customerImporterId: json['customer_importer_id'] as int?,
      orderId: json['order_id'] as int?,
      salesPerson: json['sales_person'] is Map
          ? SalesPersonModel.fromJson(json['sales_person'] as Map<String, dynamic>)
          : null,
      createdBy: json['created_by'] is Map
          ? UserModel.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      recording: recording,
      attachments: attachments,
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
    if (orderId != null) map['order_id'] = orderId;
    return map;
  }

  @override
  List<Object?> get props => [id, noteType, orderId, createdAt];
}
