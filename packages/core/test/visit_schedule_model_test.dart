import 'package:flutter_test/flutter_test.dart';

import 'package:core/models/customer_diary_note.dart';
import 'package:core/models/visit_schedule.dart';

void main() {
  test('fromJson/toCreateJson round-trips a customer-targeted visit', () {
    final visit = VisitScheduleModel.fromJson(const {
      'id': 5,
      'sales_person_id': 2,
      'customer_type': 'customer_shop',
      'customer_shop_id': 11,
      'customer_name': 'Corner Store',
      'scheduled_at': '2026-08-12 09:00:00',
      'duration_minutes': '30',
      'purpose': 'due_collection',
      'status': 'planned',
      'notes': 'Bring the statement',
    });

    expect(visit.isPlanned, isTrue);
    expect(visit.customerId, 11);
    expect(visit.scheduledDate, isNotNull);

    final payload = visit.toCreateJson();
    expect(payload['customer_shop_id'], 11);
    expect(payload['customer_type'], 'customer_shop');
    expect(payload['duration_minutes'], 30);
    expect(payload.containsKey('watchlist_item_id'), isFalse);
  });

  test('a watchlist-targeted visit emits only the watchlist key', () {
    const visit = VisitScheduleModel(
      id: 0,
      watchlistItemId: 42,
      scheduledAt: '2026-08-12T09:00:00',
      purpose: 'new_client_search',
    );

    final payload = visit.toCreateJson();
    expect(payload['watchlist_item_id'], 42);
    expect(payload.containsKey('customer_type'), isFalse);
    expect(payload.containsKey('customer_shop_id'), isFalse);
  });

  test('negative ids and cached _pending_sync rows are local-only', () {
    final local = VisitScheduleModel.fromJson(const {
      'id': -170000,
      'scheduled_at': '2026-08-12T09:00:00',
      'purpose': 'regular_visit',
      '_pending_sync': true,
    });
    expect(local.isLocalOnly, isTrue);
  });

  test('CollectionCandidate parses embedded shop context', () {
    final candidate = CollectionCandidate.fromJson(const {
      'shop_id': 3,
      'name': 'High Due',
      'area': 'North',
      'phone': '0501234567',
      'gps': '24.7,46.6',
      'due': '500.00',
      'overdue': 100,
      'oldest_due_date': '2026-07-01',
    });

    expect(candidate.due, 500.0);
    expect(candidate.overdue, 100.0);
    expect(candidate.area, 'North');
    expect(candidate.gps, '24.7,46.6');
  });

  test('diary notes parse order_id and photo/video attachments', () {
    final note = CustomerDiaryNoteModel.fromJson(const {
      'id': 1,
      'customer_type': 'customer_shop',
      'customer_shop_id': 11,
      'order_id': 99,
      'note_type': 'photo',
      'media': [
        {'id': 1, 'type': 'gallery', 'url': 'https://x/img.webp'},
        {'id': 2, 'type': 'recording_audio', 'url': 'https://x/a.m4a'},
        {'id': 3, 'type': 'recording_video', 'url': 'https://x/v.mp4'},
      ],
    });

    expect(note.orderId, 99);
    expect(note.isPhoto, isTrue);
    // The voice recording renders separately; attachments carry the rest.
    expect(note.attachments.length, 2);
    expect(note.toCreateJson()['order_id'], 99);
  });
}
