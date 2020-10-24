import 'package:shared_preferences/shared_preferences.dart';

class StoreBooksData {
  addStringToSF(String key, String downloads) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, downloads);
  }

  Future<String> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove(key);
  }

  Future<bool> isKeyExists(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(key);
    return checkValue;
  }
}
