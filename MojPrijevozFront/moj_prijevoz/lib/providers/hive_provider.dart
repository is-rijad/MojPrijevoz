import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveProvider {
  static Box<dynamic>? _instance;
  static const _key = String.fromEnvironment("HIVE_KEY");

  static Future<Box<dynamic>> getInstance() async {
    if (_instance == null) {
      await Hive.initFlutter();
      _instance = await Hive.openBox('secureBox', encryptionCipher: _getKey());
    }
    return _instance!;
  }

  static HiveAesCipher _getKey() {
    assert(_key.length == 64);
    var keyList = [
      for (int i = 0; i < _key.length; i += 2)
        int.parse(_key.substring(i, i + 2), radix: 16),
    ];
    return HiveAesCipher(keyList);
  }
}
