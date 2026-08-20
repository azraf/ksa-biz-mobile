import 'package:flutter_test/flutter_test.dart';
import 'package:core/models/watchlist_item.dart';

void main() {
  test('phone round-trips through fromJson, toCreateJson and copyWith', () {
    final item = WatchlistItemModel.fromJson(const {
      'id': 7,
      'sales_person_id': 3,
      'gps': '1,1',
      'place_name': 'Corner',
      'phone': '0501234567',
    });
    expect(item.phone, '0501234567');
    expect(item.toCreateJson()['phone'], '0501234567');
    expect(item.copyWith(status: 'archived').phone, '0501234567');
  });

  test('missing phone stays null and is omitted from the create payload', () {
    final item = WatchlistItemModel.fromJson(const {'id': 1, 'sales_person_id': 1, 'gps': '1,1'});
    expect(item.phone, isNull);
    expect(item.toCreateJson().containsKey('phone'), isFalse);
  });
}
