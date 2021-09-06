import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
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
                          '45kg via 5 x 40kg',
                          '40kg via 4 x 38kg',
                          '38kg via 4x 20kg',
                          'graphics/stats.png'),
                      route: '/stats')),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TappableCard(
                      sectionTitle: 'Cycle Information',
                      cartContent: HomeCard(
                          'Boring But Big',
                          'Cycle Type: Leader',
                          'Cycle Number: Cycle 1',
                          'Current Week: Week 2',
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
    return TappableCard(
        sectionTitle: 'Todays Training',
        cartContent: HomeCard(
          user.currentExcercise, 
          '5 x 20kg', 
          '5 x 30kg',
          '5 x 40kg', 
          'graphics/ohp.png',
          changeable: true),
        route: '/excercise');
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