import 'package:flutter/material.dart';

import 'dbLift.dart';

class StatsSelectedLift with ChangeNotifier {
  late DbLift selectedLift;
  String selectedStatsType = '1RM';
  StatsSelectedLift(this.selectedLift, {this.selectedStatsType = '1RM'});

  changeLift(DbLift newLift) {
    this.selectedLift = newLift;
    notifyListeners();
  }

  changeStatsType(String newStat) {
    this.selectedStatsType = newStat;
    notifyListeners();
  }
}
