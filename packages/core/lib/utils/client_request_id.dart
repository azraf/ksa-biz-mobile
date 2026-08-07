import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String generateClientRequestId() => _uuid.v4();
