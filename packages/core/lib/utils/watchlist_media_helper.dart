import '../models/local_media_attachment.dart';
import '../models/watchlist_item.dart';
import '../offline/stores/media_outbox_store.dart';

/// Loads pending local media blobs for a watchlist item (not yet uploaded).
Future<List<LocalMediaAttachment>> loadWatchlistPendingMedia(
  MediaOutboxStore mediaStore,
  WatchlistItemModel item,
) {
  return mediaStore.attachmentsForParent(
    parentEntityType: 'watchlist',
    parentServerId: item.id > 0 ? item.id : null,
    parentLocalId: item.localId ?? (item.id < 0 ? item.id : null),
  );
}
