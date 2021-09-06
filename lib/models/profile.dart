import 'package:flutter/cupertino.dart';
import 'package:liftcalculator/models/trainingMax.dart';
import 'package:liftcalculator/util/preferences.dart';

/// Class that handles the users individual settings stored in either the DB
/// or the env context (everything which we need to get async)
class UserProfile with ChangeNotifier {
  bool isLoaded = false;
  late int currentTrainingMaxPercentage;
  late String cycleTemplate;
  late String currentExcercise;
  List<TrainingMax> liftList = [];

  UserProfile() {
    _loadData();
  }

  _loadData() async {
    _loadSettings();
    // Load Training MAX config
    TrainingMax ohp = await TrainingMax.create("Overhead press", "OHP");
    TrainingMax dl = await TrainingMax.create("Deadlift", "DL");
    TrainingMax bp = await TrainingMax.create("Bench Press", "BP");
    TrainingMax sq = await TrainingMax.create("Squat", "SQ");

    this.liftList.insert(0, ohp);
    this.liftList.insert(1, dl);
    this.liftList.insert(2, bp);
    this.liftList.insert(3, sq);
    this.isLoaded = true;
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }

  // Loads everything that the user can influence via the settings screen
  _loadSettings() async {
    Preferences pref = await Preferences.create();
    this.currentTrainingMaxPercentage =
        await pref.getSharedPrefValueInt('Training_Max_Percentage');
    this.cycleTemplate =
      await pref.getSharedPrefValueString('Cycle_Template');
    this.currentExcercise = await pref.getSharedPrefValueString('Current_Excercise');
    notifyListeners();
  }


  // Stores any user defined setting via shared prefs and informs listeners
  storeUserSetting(String referenceVar, dynamic value) async {
    Preferences pref = await Preferences.create();
    if(value is String) pref.setSharedPrefValueString(referenceVar, value);
    if(value is int) pref.setSharedPrefValueInt(referenceVar, value);
    _loadSettings();
  }

}
