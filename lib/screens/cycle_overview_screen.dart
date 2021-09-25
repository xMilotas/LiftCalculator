// Quick overview screen on the all the lifts for the current cycle (3 weeks)

import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/models/training.dart';
import 'package:liftcalculator/util/globals.dart';
import 'package:liftcalculator/util/programs.dart';
import 'package:liftcalculator/util/weight_reps.dart';
import 'package:provider/provider.dart';

class CycleOverviewScreen extends StatefulWidget {
  @override
  _CycleOverviewScreenState createState() => _CycleOverviewScreenState();
}

class _CycleOverviewScreenState extends State<CycleOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: buildAppBar(context, "${profile.cycleTemplate} Overview"),
        drawer: buildDrawer(context),
        body: ListView(
          children: GLOBAL_ALL_LIFTS
              .map((lift) => NonTappableCard(
                  cartContent: HomeCard(
                      lift.title,
                      Wrap(children: buildCardContent(profile, lift.id)),
                      'graphics/${lift.abbreviation}.png')))
              .toList(),
        ));
  }
}

buildCardContent(UserProfile user, int liftId) {
  var output = <Widget>[];
  for (var i = 1; i <= 3; i++) {
    LiftDay week = getCurrentWeek(user, customWeek: i);
    double exerciseTrainingMax = user.liftList[liftId].trainingMax;
    List<LiftNumber> lifts =
        calculateTrainingNumbers(exerciseTrainingMax, week.coreLifts);
    List<LiftNumber> cycleLift =
        calculateTrainingNumbers(exerciseTrainingMax, week.cycleLift);

    // 1 Column per week w. 5 Rows
    output.add(
      Padding(padding: EdgeInsets.only(right: 8, left: 8), child: Column(
      children: [
        Padding(child: Text('Week $i', style:  TextStyle(fontSize: 16),), padding: EdgeInsets.only(bottom: 8)),
        ...buildAndFormatLiftNumbers(lifts),
        Padding(child: Text(buildSetOutput(cycleLift[0])), padding: EdgeInsets.only(top: 8, bottom: 2)),
        Text(WeightReps(cycleLift[0].weight, cycleLift[0].reps).toString())
      ],
    )));
  }
  return output;
}
