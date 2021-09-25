import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
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
                Text('Cycle Type:          ' + prog.cycleType),
                Text('Cycle Number:     ' + user.cycleNumber.toString()),
                Text('Current Week:      ' + user.cycleWeek.week.toString()),
              ],
            ),
            'graphics/cycle.png'),
        route: '/cycleOverview');
  });
}

buildStatsCard(UserProfile user) {
  return Consumer<UserProfile>(builder: (context, user, child) {
    LiftHelper helper = LiftHelper();
    return FutureBuilder(
        future: helper.getHighest1RMs(user.currentExercise.id),
        builder: (BuildContext context, AsyncSnapshot<List<DbLift>> snapshot) {
          List<Widget> output;
          if (snapshot.hasData) {
            List<DbLift> data = snapshot.data!;
            if (data.length == 0)
              output = [Text('You have not performed any lifts yet')];
            else {
              output = data
                  .map((e) => Row(
                        children: [
                          Text('${e.calculated1RM} via '),
                          Text('${e.weightRep}')
                        ],
                      ))
                  .toList();
            }
          } else output = dataFetchingIndicator();
          return TappableCard(
              sectionTitle: 'Stats',
              cartContent: HomeCard(
                  'Current Max Reps',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: output,
                  ),
                  'graphics/stats.png'),
              route: '/stats');
        });
  });
}


