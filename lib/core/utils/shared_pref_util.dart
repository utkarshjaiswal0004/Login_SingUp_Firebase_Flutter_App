import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  late SharedPreferences prefs;

  Future initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> storeString(String key, String value) async {
    await initSharedPref();
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await initSharedPref();
    return prefs.getString(key);
  }

  Future<bool?> deleteString(String key) async {
    await initSharedPref();
    return prefs.remove(key);
  }

  Future<bool?> clearAll() async {
    await initSharedPref();
    return prefs.clear();
  }
}
