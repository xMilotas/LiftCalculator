import 'package:flutter/material.dart';
import 'package:liftcalculator/models/dbTrainingMax.dart';

import 'dbLift.dart';

class StatsSelectedLift with ChangeNotifier {
  late DbLift selectedLift;
  late DbTrainingMax selectedTM;
  String selectedStatsType = '1RM';
  StatsSelectedLift(this.selectedLift, {this.selectedStatsType = '1RM'});

  changeLift(DbLift newLift) {
    this.selectedLift = newLift;
    notifyListeners();
  }

  changeTrainingMax(DbTrainingMax newTrainingMax) {
    this.selectedTM = newTrainingMax;
    notifyListeners();
  }

  changeStatsType(String newStat) {
    this.selectedStatsType = newStat;
    notifyListeners();
  }
}
