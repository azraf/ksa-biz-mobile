class OfflineWriteException implements Exception {
  OfflineWriteException([this.message = 'This action requires an internet connection.']);

  final String message;

  @override
  String toString() => message;
}
