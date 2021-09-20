import 'package:liftcalculator/models/profile.dart';

/// Describes a single cycle week and its current state of finished lifts
class CycleWeek {
  int week;
  bool ohp = false, dl = false, sq = false, bp = false;

  CycleWeek(this.week);

  CycleWeek.fromString(String string)
      : week = int.parse(string.split("|")[0]),
        ohp = parseBool(string.split("|")[1]),
        dl = parseBool(string.split("|")[2]),
        bp = parseBool(string.split("|")[3]),
        sq = parseBool(string.split("|")[4]);

  /// Takes a lift id and sets the corresponding lift as done in this weeks instance
  markLiftAsDone(int liftId, UserProfile user) {
    switch (liftId) {
      case 0:
        this.ohp = true;
        break;
      case 1:
        this.bp = true;
        break;
      case 2:
        this.dl = true;
        break;
      case 3:
        this.sq = true;
        break;
    }
    // Week completed
    if (this.ohp & this.bp & this.dl & this.sq) {
      print("[CYCLE WEEK]: WEEK COMPLETED");
      if (this.week == 3) {
        print("[CYCLE WEEK]: 3 Weeks done");

        /// Go to next cycle
        if (user.program.maxCycles > user.cycleNumber) {
          user.storeUserSetting('Current_Cycle', user.cycleNumber + 1);
          print("[CYCLE WEEK]: Next cycle started");
        } else {
          // Reset cycle
          user.storeUserSetting('Current_Cycle', 1);
          var currentTemplate = user.cycleTemplate;
          if (currentTemplate == 'FirstSetLast')
            user.storeUserSetting('Cycle_Template', 'BoringButBig');
          else
            user.storeUserSetting('Cycle_Template', 'FirstSetLast');
          print("[CYCLE WEEK]: Template switched");
        }
        // Reset week
        this.week = 0;
        // Increase training maxes by 2.5/5kg
        user.liftList.forEach((lift) {
          if (lift.id == 0 || lift.id == 2)
            lift.trainingMax = lift.trainingMax + 2.5;
          else
            lift.trainingMax = lift.trainingMax + 5;
          lift.saveData();
        });
      }
      // Go to next week
      this.week = week + 1;
      // Reset lift id
      liftId = -1;
      // Reset lifts
      resetWeekProgress();
    }
    user.storeUserSetting('Current_Week', this.toString());
    user.storeUserSetting('Current_Exercise', getNextLiftId(liftId));
  }

  /// Returns wether or not a lift is completed
  bool getLiftStatus(int liftId) {
    switch (liftId) {
      case 0:
        return this.ohp;
      case 1:
        return this.bp;
      case 2:
        return this.dl;
      case 3:
        return this.sq;
      default:
        return false;
    }
  }

  /// Selects the next exercise
  /// Checks wether next lift is already completed - finds first non-completed lift
  int getNextLiftId(int currentLiftId) {
    int nextId = currentLiftId + 1;
    if (getLiftStatus(nextId))
      return getNextLiftId(nextId);
    else
      return nextId;
  }

  /// Resets the current week
  resetWeekProgress({user}) {
    this.bp = false;
    this.dl = false;
    this.sq = false;
    this.ohp = false;
    if (user != null) user.storeUserSetting('Current_Week', this.toString());
  }

  @override
  String toString() {
    return "$week|$ohp|$dl|$bp|$sq";
  }
}

bool parseBool(boolString) {
  return boolString.toLowerCase() == 'true';
}
