sealed class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({this.statusCode, String message = 'Error del servidor'})
      : super(message);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Error al procesar los datos']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No hay datos guardados']);
}