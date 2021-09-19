import 'package:shared_preferences/shared_preferences.dart';

/// Simple class to interact with the shared preferences
class Preferences {
  late SharedPreferences prefs;

  Preferences._create();

  static Future<Preferences> create() async {
    var component = Preferences._create();
    component.prefs = await SharedPreferences.getInstance();
    return component;
  }

  // Writes a int value to store
  setSharedPrefValueDouble(String referenceVar, double value) async {
    await this.prefs.setDouble(referenceVar, value);
    print('[SHARED_PREFS]: Set new value for $referenceVar, $value');
    return value;
  }

  // Writes a int value to store
  setSharedPrefValueInt(String referenceVar, int value) async {
    await this.prefs.setInt(referenceVar, value);
    print('[SHARED_PREFS]: Set new value for $referenceVar, $value');
    return value;
  }

  // Writes a string value to store
  setSharedPrefValueString(String referenceVar, String value) async {
    await this.prefs.setString(referenceVar, value);
    print('[SHARED_PREFS]: Set new value for $referenceVar, $value');
    return value;
  }

  // Get a stored value
  Future<int> getSharedPrefValueInt(String referenceVar) async {
    int value = this.prefs.getInt(referenceVar) ?? 0;
    print('[SHARED_PREFS]: Got value: $value for $referenceVar');
    return value;
  }

  // Get a stored value
  Future<double> getSharedPrefValueDouble(String referenceVar) async {
    double value = this.prefs.getDouble(referenceVar) ?? 0;
    print('[SHARED_PREFS]: Got value: $value for $referenceVar');
    return value;
  }

  // Get a stored value
  Future<String> getSharedPrefValueString(String referenceVar) async {
    String value = this.prefs.getString(referenceVar) ?? '';
    print('[SHARED_PREFS]: Got value: $value for $referenceVar');
    return value;
  }
}
