class RequestFailure implements Exception {
  final String? message;
  final int? code;
  final Exception? exception;
  RequestFailure({this.message, this.exception, this.code});
}
