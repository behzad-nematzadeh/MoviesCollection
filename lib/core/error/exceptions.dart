class ServerException implements Exception {
  final int code;
  final String? message;
  final String status;

  ServerException({
    required this.code,
    required this.message,
    this.status = 'ERR',
  }) : super();
}

class CacheException implements Exception {}
