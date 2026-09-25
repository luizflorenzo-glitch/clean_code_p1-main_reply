class MockApiLatency {
  MockApiLatency._();

  static const Duration auth = Duration(milliseconds: 2500);
  static const Duration products = Duration(milliseconds: 1800);
}

class ApiStatusCode {
  ApiStatusCode._();

  static const String authOk = 'AUTH_OK_200';
  static const String authFailed = 'ERR_AUTH_99';
  static const String dbFetchError = 'ERR_DB_FETCH_500';
}
