import 'dart:developer';

import 'package:assets_challenge/core/exceptions/http_exceptions.dart';
import 'package:assets_challenge/core/exceptions/request_failure.dart';

Future<T> repositoryExceptionHandlerScope<T>(Function function) async {
  try {
    return await function();
  } on ClientErrorException catch (e) {
    throw RequestFailure(
      message: e.message.toString(),
      exception: e,
      code: e.code,
    );
  } on ServerErrorException catch (e) {
    throw RequestFailure(
      message: e.message.toString(),
      exception: e,
      code: e.code,
    );
  } on ConnectionException catch (e) {
    throw RequestFailure(exception: e);
  } on Exception catch (e) {
    throw RequestFailure(exception: e);
  } catch (e) {
    log(e.toString(), name: 'ERROR');
    throw RequestFailure();
  }
}
