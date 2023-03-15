
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  Future<String> getThemeMode() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("themeMode") ?? "dark";
  }

  Future<void> setThemeMode(String themeMode) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("themeMode", themeMode);
  }
}
