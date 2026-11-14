/// Application-wide constant values for FoodLence.
class AppConstants {
  AppConstants._();

  static const String appName = 'FoodLense';
  static const String backendBaseUrl = 'http://localhost:8000';
  static const String backendHealthUrl = '$backendBaseUrl/health';
  static const String databaseName = 'foodlence_db';
  static const int databasePort = 5432;
}
