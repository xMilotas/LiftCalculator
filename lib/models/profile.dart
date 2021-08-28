import 'package:flutter/cupertino.dart';
import 'package:liftcalculator/models/trainingMax.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class that handles the users individual settings stored in either the DB
/// or the env context (everything which we need to get async)
class UserProfileAsync with ChangeNotifier{
  late int currentTrainingMaxPercentage;
  List<TrainingMax> liftList = [];
  UserProfileAsync._();
  static final instance = UserProfileAsync._();

  Future initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Other stuff that needs to be loaded
    this.currentTrainingMaxPercentage = prefs.getInt('Training_Max_Percentage') ?? 85;
    // Load Training MAX config
    TrainingMax ohp = await TrainingMax.create("Overhead press", "OHP");
    TrainingMax dl = await TrainingMax.create("Deadlift", "DL");
    TrainingMax bp = await TrainingMax.create("Bench Press", "BP");
    TrainingMax sq = await TrainingMax.create("Squat", "SQ");

    this.liftList.insert(0, ohp);
    this.liftList.insert(1, dl);
    this.liftList.insert(2, bp);
    this.liftList.insert(3, sq);

    await Future.delayed(Duration(seconds: 1));
  }
}


