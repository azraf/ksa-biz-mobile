import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a van-customer instruction with media and linked orders', () {
    final model = ManualOrderRequestModel.fromJson({
      'id': 7,
      'customer_shop_id': null,
      'customer_van_id': 3,
      'source': 'customer',
      'status': 'converted',
      'notes': 'Two cartons',
      'customer_van': {'id': 3, 'name': 'Van Alpha'},
      'media': [
        {'id': 1, 'type': 'gallery', 'url': 'https://x/img.webp', 'mime_type': 'image/webp'},
        {'id': 2, 'type': 'recording_audio', 'url': 'https://x/a.m4a', 'mime_type': 'audio/mp4'},
      ],
      'orders': [
        {'id': 11, 'customer_type_id': 2, 'status': 'confirmed', 'total_bill': 50},
        {'id': 12, 'customer_type_id': 2, 'status': 'draft', 'total_bill': 20},
      ],
    });

    expect(model.customerShopId, isNull);
    expect(model.customerVanId, 3);
    expect(model.customerName, 'Van Alpha');
    expect(model.allMedia, hasLength(2));
    expect(model.linkedOrders.map((o) => o.id), [11, 12]);
    expect(model.isEditable, isFalse);
  });

  test('falls back to recordings when media list is absent (old payloads)', () {
    final model = ManualOrderRequestModel.fromJson({
      'id': 1,
      'customer_shop_id': 5,
      'source': 'whatsapp',
      'status': 'pending',
      'recordings': [
        {'id': 9, 'type': 'recording_audio', 'url': 'https://x/a.m4a', 'mime_type': 'audio/mp4'},
      ],
    });

    expect(model.customerShopId, 5);
    expect(model.allMedia.single.id, 9);
    expect(model.linkedOrders, isEmpty);
  });
}
