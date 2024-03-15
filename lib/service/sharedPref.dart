import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<String> getLoggedUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("logged userID") ?? "";
  }

  static Future<void> setLoggedUserID(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("logged userID");
    prefs.setString("logged userID", userID);
  }

  static Future<void> removeLoggedUserID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("logged userID");
  }
}
