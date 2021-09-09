import 'package:liftcalculator/util/programs.dart';

final bbb = {"1": bbbWeekOne, "2": bbbWeekTwo, "3": bbbWeekThree};

final bbbWeekOne = LiftDay(
  coreLifts: [LiftNumber(70, 5), LiftNumber(80, 5), LiftNumber(90, 5)],
  cycleLift: [LiftNumber(60, 10, sets: 5)],
);

final bbbWeekTwo = LiftDay(
  coreLifts: [LiftNumber(65, 5), LiftNumber(75, 5), LiftNumber(85, 5)],
  cycleLift: [LiftNumber(50, 10, sets: 5)],
);
final bbbWeekThree = LiftDay(
  coreLifts: [LiftNumber(75, 5), LiftNumber(85, 5), LiftNumber(95, 5)],
  cycleLift: [LiftNumber(70, 10, sets: 5)],
);

final fsl = {"1": fslWeekOne, "2": fslWeekTwo, "3": fslWeekThree};

final fslWeekOne = LiftDay(
  coreLifts: [
    LiftNumber(65, 5),
    LiftNumber(75, 5),
    LiftNumber(85, 5, pr: true)
  ],
  cycleLift: [LiftNumber(65, 15, sets: 1)],
);

final fslWeekTwo = LiftDay(
  coreLifts: [
    LiftNumber(70, 3),
    LiftNumber(80, 3),
    LiftNumber(90, 3, pr: true)
  ],
  cycleLift: [LiftNumber(70, 15, sets: 1)],
);

final fslWeekThree = LiftDay(
  coreLifts: [
    LiftNumber(75, 5),
    LiftNumber(85, 3),
    LiftNumber(85, 1, pr: true)
  ],
  cycleLift: [LiftNumber(65, 15, sets: 1)],
);
