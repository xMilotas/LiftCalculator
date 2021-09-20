import 'package:flutter/material.dart';

import 'dbLift.dart';


// Maybe change to map ..
class StatsSelectedLift with ChangeNotifier {
  late DbLift selectedLift;

  StatsSelectedLift(this.selectedLift);

  changeLift(DbLift newLift) {
    this.selectedLift = newLift;
    notifyListeners();
  }
}
