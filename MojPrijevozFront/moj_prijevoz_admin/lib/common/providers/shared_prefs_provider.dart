import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsProvider {
  SharedPreferences? _sharedPreferences;

  Future _init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future setString(String key, String value) async {
    await _init();
    await _sharedPreferences!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await _init();
    return _sharedPreferences!.getString(key);
  }

  Future deleteString(String key) async {
    await _init();
    await _sharedPreferences!.remove(key);
  }
}
