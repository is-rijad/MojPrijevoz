abstract class Environment {
  static const apiUrl = String.fromEnvironment('API_URL');
  static const openRouteKey = String.fromEnvironment('OPENROUTE_KEY');
  static const openReverseApiUrl = String.fromEnvironment(
    'OPENROUTE_REVERSE_API_URL',
  );
  static const openRouteApiUrl = String.fromEnvironment('OPENROUTE_API_URL');
  static const nominatimApiUrl = String.fromEnvironment('NOMINATIM_API_URL');
}
