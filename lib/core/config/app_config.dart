class AppConfig {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPrefix = '/api/v1';
  static String get apiBaseUrl => '$baseUrl$apiPrefix';
}