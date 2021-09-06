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
  setSharedPrefValueInt(String referenceVar, int value) async {
    await this.prefs.setInt(referenceVar, value);
    print('Set new value for $referenceVar, $value');
    return value;
  }

   // Writes a string value to store
  setSharedPrefValueString(String referenceVar, String value) async {
    await this.prefs.setString(referenceVar, value);
    print('Set new value for $referenceVar, $value');
    return value;
  }

  // Get a stored value
  Future<int> getSharedPrefValueInt(String referenceVar) async {
    int value = this.prefs.getInt(referenceVar) ?? 0;
    print('Got value: $value for $referenceVar');
    return value;
  }

  // Get a stored value
  Future<String> getSharedPrefValueString(String referenceVar) async {
    String value = this.prefs.getString(referenceVar) ?? '';
    print('Got value: $value for $referenceVar');
    return value;
  }
}
