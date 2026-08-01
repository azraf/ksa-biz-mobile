import 'package:equatable/equatable.dart';

class SyncQueueItem extends Equatable {
  const SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.operation,
    required this.payload,
    this.localId,
    this.serverId,
    this.status = 'pending',
    this.retryCount = 0,
    this.errorMessage,
    this.createdAt,
    this.clientRequestId,
    this.nextRetryAt,
  });

  final int id;
  final String entityType;
  final String operation;
  final int? localId;
  final int? serverId;
  final Map<String, dynamic> payload;
  final String status;
  final int retryCount;
  final String? errorMessage;
  final String? createdAt;
  final String? clientRequestId;
  final DateTime? nextRetryAt;

  bool get isPending => status == 'pending' || status == 'failed';

  bool get isActionable => status == 'pending' || status == 'failed' || status == 'dead';

  factory SyncQueueItem.fromMap(Map<String, dynamic> map) => SyncQueueItem(
        id: map['id'] as int,
        entityType: map['entity_type'] as String,
        operation: map['operation'] as String,
        localId: map['local_id'] as int?,
        serverId: map['server_id'] as int?,
        payload: Map<String, dynamic>.from(
          map['payload'] is String
              ? {}
              : (map['payload'] as Map<String, dynamic>? ?? {}),
        ),
        status: map['status'] as String? ?? 'pending',
        retryCount: map['retry_count'] as int? ?? 0,
        errorMessage: map['error_message'] as String?,
        createdAt: map['created_at'] as String?,
      );

  @override
  List<Object?> get props => [id, entityType, operation, status];
}
