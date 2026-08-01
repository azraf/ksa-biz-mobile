import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String newClientRequestId() => _uuid.v4();

Map<String, dynamic> withClientRequestId(Map<String, dynamic> body) {
  if (body['client_request_id'] != null) return body;
  return {...body, 'client_request_id': newClientRequestId()};
}
