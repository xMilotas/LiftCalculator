import 'package:flutter/cupertino.dart';
import 'package:liftcalculator/models/trainingMax.dart';
import 'package:liftcalculator/util/preferences.dart';

/// Class that handles the users individual settings stored in either the DB
/// or the env context (everything which we need to get async)
class UserProfile with ChangeNotifier {
  bool isLoaded = false;
  late int currentTrainingMaxPercentage;
  List<TrainingMax> liftList = [];

  UserProfile() {
    _loadData();
  }

  _loadData() async {
    Preferences pref = await Preferences.create();
    this.currentTrainingMaxPercentage =
        await pref.getSharedPrefValueInt('Training_Max_Percentage');
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
}
