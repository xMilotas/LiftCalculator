import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
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
                  child: TappableCard(
                      sectionTitle: 'Current Max Reps',
                      cartContent: HomeCard(
                          'OHP',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('45kg via 5 x 40kg'),
                              Text('40kg via 4 x 38kg'),
                              Text('38kg via 4x 20kg'),
                            ],),
                          'graphics/stats.png'),
                      route: '/stats')),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TappableCard(
                      sectionTitle: 'Cycle Information',
                      cartContent: HomeCard(
                        //TODO: Make this a cosumer card instead of static text
                          'Boring But Big',
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('Cycle Type: Leader'),
                          Text('Cycle Number: Cycle 1'),
                          Text('Current Week: Week 2'),
                            ],),
                          'graphics/cycle.png'),
                      route: '/cycleOverview')),
            ],
          ),
        ),
        drawer: buildDrawer(context),
      );
  }
}

buildTrainingCard() {
  return Consumer<UserProfile>(builder: (context, user, child) {
    int excerciseTrainingMax = (user.currentExcercise.current1RM * user.currentTrainingMaxPercentage / 100).round();
    List<LiftNumber> lifts = calculateTrainingNumbers(excerciseTrainingMax, user.program.week1.coreLifts);

    return TappableCard(
        sectionTitle: 'Todays Training',
        cartContent: HomeCard(
          user.currentExcercise.title,
          Column(children: buildAndformatLiftNumbers(lifts)), 
          'graphics/ohp.png',
          changeable: true),
        route: '/excercise');
  });
}



/// Returns the calculated weights for a given List of Lift Numbers
calculateTrainingNumbers(int trainingMax, List<LiftNumber> program ) => 
program.map((e) => LiftNumber(e.weightPercentage, e.reps, weight: (e.weightPercentage/100 * trainingMax))).toList();

/// Build training output
/// TODO: Fix output to a proper format add reps
buildAndformatLiftNumbers(List<LiftNumber> lifts){
  return lifts.map((e) => Text(e.weight.toString())
  ).toList();
}

/**
 * TODO:
 *      - Show current cycle number
 *      - Show current cycle type
 *      - Have a top row that shows current TM (can be straight forward) 
 *      - Today's training as card - on press - move 
 *      - (Give option to change training)
 * */


 // TODO: Write function that rounds to .5/1kg 