import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class InternetConnectionHelper {
  Future<bool> get isConnected;
}

class InternetConnectionHelperImpl extends InternetConnectionHelper {
  final InternetConnectionChecker internetConnectionChecker;

  InternetConnectionHelperImpl(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
