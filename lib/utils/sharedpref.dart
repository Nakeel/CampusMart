import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  addIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  addDoubleToSF(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key) ?? "";
    return stringValue;
  }

  Future<bool> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue =  prefs.getBool(key)?? false;
    return boolValue;
  }

  getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key) ?? 0;
    return intValue;
  }

  getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(key) ?? 0.0;
    return doubleValue;
  }

  removeValues(String keyToRemove) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove(keyToRemove);
  }
}
