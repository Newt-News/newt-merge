/// App-wide configuration constants.
/// Toggle features here during development.
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// Whether to show the ad banner slot.
  /// Set to true when AdMob is configured and ready.
  static const bool showAds = false;

  /// Whether to enable debug mode features.
  static const bool debugMode = true;

  /// App version for display purposes.
  static const String version = '1.0.0';
}
