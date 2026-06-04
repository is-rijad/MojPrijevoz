abstract class Environment {
  static const apiUrl = String.fromEnvironment('API_URL');
  static const openRouteKey = String.fromEnvironment('OPENROUTE_KEY');
  static const openReverseApiUrl = String.fromEnvironment(
    'OPENROUTE_REVERSE_API_URL',
  );
  static const openRouteApiUrl = String.fromEnvironment('OPENROUTE_API_URL');
  static const nominatimApiUrl = String.fromEnvironment('NOMINATIM_API_URL');
  static const stripeKey = String.fromEnvironment('STRIPE_KEY');
  static const firebaseAndroidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
  );
  static const firebaseAndroidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
  );
  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
  static const firebaseIosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
  );
  static const firebaseIosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const firebaseIosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
  );
}
