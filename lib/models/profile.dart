import 'package:flutter/cupertino.dart';
import 'package:liftcalculator/models/trainingMax.dart';
import 'package:liftcalculator/util/preferences.dart';
import 'package:liftcalculator/util/programs.dart';

/// Class that handles the users individual settings stored in either the DB
/// or the env context (everything which we need to get async)
class UserProfile with ChangeNotifier {
  bool isLoaded = false;
  int currentTrainingMaxPercentage = 90;
  String cycleTemplate = "FirstSetLast";
  int cycleWeek = 1;
  int cycleNumber = 1;
  late TrainingMax currentExercise;
  List<TrainingMax> liftList = [];
  late LiftProgram program;

  UserProfile() {
    _loadData();
  }

  _loadData() async {
    // Load Training MAX config
    TrainingMax ohp = await TrainingMax.create(0, "Overhead Press", "OHP");
    TrainingMax dl = await TrainingMax.create(1, "Deadlift", "DL");
    TrainingMax bp = await TrainingMax.create(2, "Bench Press", "BP");
    TrainingMax sq = await TrainingMax.create(3, "Squat", "SQ");

    this.liftList.insert(0, ohp);
    this.liftList.insert(1, dl);
    this.liftList.insert(2, bp);
    this.liftList.insert(3, sq);

    _loadSettings();
    await Future.delayed(Duration(seconds: 1));
    this.isLoaded = true;
    print(this.toString());
    notifyListeners();
  }

  // Loads everything that the user can influence via the settings screen
  _loadSettings() async {
    Preferences pref = await Preferences.create();
    int tmMaxPercent = await pref.getSharedPrefValueInt('Training_Max_Percentage');
    this.currentTrainingMaxPercentage = (tmMaxPercent == 0) ? 85 : tmMaxPercent;
    String template = await pref.getSharedPrefValueString('Cycle_Template');
    this.cycleTemplate = (template == "") ? "BoringButBig" : template;

    if (this.cycleTemplate == 'FirstSetLast')
      this.program = firstSetLast;
    else
      this.program = boringButBig;

    this.currentExercise =
        this.liftList[await pref.getSharedPrefValueInt('Current_Exercise')];

    int week = await pref.getSharedPrefValueInt('Current_Week');
    this.cycleWeek = (week == 0) ? 1 : week;

    int cycle = await pref.getSharedPrefValueInt('Current_Cycle');
    this.cycleNumber = (cycle == 0) ? 1 : cycle;

    notifyListeners();
  }

  // Stores any user defined setting via shared prefs and informs listeners
  storeUserSetting(String referenceVar, dynamic value) async {
    Preferences pref = await Preferences.create();
    if (value is String) pref.setSharedPrefValueString(referenceVar, value);
    if (value is int) pref.setSharedPrefValueInt(referenceVar, value);
    _loadSettings();
  }

  @override
  String toString() {
    return "[USER_PROFILE]: loaded: ${this.isLoaded}, currentTrainingMaxPercentage: ${this.currentTrainingMaxPercentage}, cycleTemplate: ${this.cycleTemplate}, cycleWeek: ${this.cycleWeek}, currentExercise: ${this.currentExercise}";
  }
}
