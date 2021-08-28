import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  late SharedPreferences prefs;

  Preferences._create();

  static Future<Preferences> create() async {
    var component = Preferences._create();
    component.prefs = await SharedPreferences.getInstance();
    return component;
  }
  
  // Writes a value to store
  setSharedPrefValue(String referenceVar, int value) async {
    await this.prefs.setInt(referenceVar, value);
    print('Set new value for $referenceVar, $value');
    return value;
  }

  // Get a stored value
 Future<int> getSharedPrefValueInt(String referenceVar) async {
    int value = this.prefs.getInt(referenceVar) ?? 0;
    print('Got value: $value for $referenceVar');
    return value;
  }

}