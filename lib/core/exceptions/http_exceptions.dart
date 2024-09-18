abstract class ApiException implements Exception {
  const ApiException();
}

class ConnectionException extends ApiException {
  const ConnectionException();
}

class ServerErrorException extends ApiException {
  final int? code;
  final dynamic message;

  const ServerErrorException({this.code, this.message});
}

class ClientErrorException extends ApiException {
  final int? code;
  final dynamic message;

  const ClientErrorException({this.code, this.message});
}

class UnknownException extends ApiException {
  const UnknownException();
}
