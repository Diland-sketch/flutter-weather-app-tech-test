sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Error de conexión']);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException({this.statusCode, String message = 'Error del servidor'})
      : super(message);
}

class ParsingException extends AppException {
  const ParsingException([super.message = 'Error al procesar los datos']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'No hay datos guardados']);
}