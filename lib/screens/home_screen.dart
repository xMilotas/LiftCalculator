import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
import 'package:liftcalculator/models/training.dart';
import 'package:liftcalculator/util/programs.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    if (profile.isLoaded == false) {
      return Splash();
    } else
      return Scaffold(
        appBar: buildAppBar(context),
        body: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: buildTrainingCard()),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: buildCycleCard()),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: buildStatsCard(profile)),
            ],
          ),
        ),
        drawer: buildDrawer(context),
      );
  }
}

buildCycleCard() {
  return Consumer<UserProfile>(builder: (context, user, child) {
    LiftProgram prog = user.program;
    return TappableCard(
        sectionTitle: "Cycle and Program Information",
        cartContent: HomeCard(
            prog.name,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cycle Type:   ' + prog.cycleType),
                Text('Cycle Number: ' + user.cycleNumber.toString()),
                Text('Current Week: ' + user.cycleWeek.toString()),
              ],
            ),
            'graphics/cycle.png'),
        route: '/cycleOverview');
  });
}

buildStatsCard(UserProfile user) {
  return Consumer<UserProfile>(builder: (context, user, child) {
    return TappableCard(
        sectionTitle: 'Stats',
        cartContent: HomeCard(
            'Your current calculated max reps',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.best3Lifts[0].toString()),
              ],
            ),
            'graphics/stats.png'),
        route: '/stats');
  });
}

/**
 * TODO:
 *      - Show current cycle number
 *      - Show current cycle type
 *      - Have a top row that shows current TM (can be straight forward) 
 *      - Today's training as card - on press - move 
 *      - (Give option to change training)
 * */
// What defines a training? i.e. how is it calculated

// The exercise, cycle, week, Training Max -- using these we can calc everything?
// (This defines the overall plan for the 4 lifts)
// per lift we need an doneMarker to indicate if the week is complete or not (completedStatus)
// in theory I want to be able to choose which lift I perform
