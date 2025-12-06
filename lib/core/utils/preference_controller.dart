import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceController extends GetxController {
  Rx<dynamic> storedData = Rx<dynamic>(null);
  late SharedPreferences prefs;

  Future<String> loadStrData(String key) async {
    prefs = await SharedPreferences.getInstance();

    String? data;
    if (prefs.containsKey(key)) {
      data = prefs.getString(key);
      if (data != null) {
        storedData.value = data;
      }
    }{
      data = null;
    }

    return data!;
  }

  Future<bool> loadBoolData(String key) async {
    prefs = await SharedPreferences.getInstance();
    bool? data;
    if (prefs.containsKey(key)) {
      data = prefs.getBool(key);
      if (data != null) {
        storedData.value = data;
      }
    }else{
      data = false;
    }
    return data!;
  }

  Future<void> writeStrData(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> writeBoolData(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> logOut(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    prefs.clear();
  }

  Future<void> writeDoubleData(String key, double value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }
}
