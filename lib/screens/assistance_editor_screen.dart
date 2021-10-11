// Used to edit performed lifts

import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/card.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/util/assistance.dart';
import 'package:liftcalculator/util/globals.dart';

class AssistanceEditorScreen extends StatefulWidget {
  @override
  _StatsPerDayScreenState createState() => _StatsPerDayScreenState();
}

class _StatsPerDayScreenState extends State<AssistanceEditorScreen> {
  Lift dropDownValue = GLOBAL_ALL_LIFTS[0];
  TextEditingController nameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Assistance Overview"),
      drawer: buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add new assistance'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Exercise Name',
                      ),
                      keyboardType: TextInputType.text,
                      controller: nameController,
                    ),
                    DropdownButtonFormField<Lift>(
                      value: dropDownValue,
                      items: GLOBAL_ALL_LIFTS
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.title)))
                          .toList(),
                      onChanged: (Lift? value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Number of sets',
                      ),
                      keyboardType: TextInputType.number,
                      controller: setsController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Number of reps per set',
                      ),
                      keyboardType: TextInputType.number,
                      controller: repsController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: '(Optional) Weight per rep',
                      ),
                      keyboardType: TextInputType.number,
                      controller: weightController,
                    ),
                  ]);
                }),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      double weight = 0;
                      print(weightController.text);
                      if (weightController.text != "") {
                        weight = double.parse(weightController.text);
                      }
                      var exercise = AssistanceExercise(
                          nameController.text,
                          dropDownValue.id,
                          int.parse(setsController.text),
                          int.parse(repsController.text),
                          weight: weight);
                      AssistanceLiftHelper().writeToDB(exercise);
                      Navigator.pop(context, 'Saved');
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            }),
      ),
      body: FutureBuilder(
          future: loadData(),
          builder: (BuildContext context,
                  AsyncSnapshot<Map<Lift, List<AssistanceExercise>>>
                      snapshot) =>
              buildOutput(context, snapshot)),
    );
  }
}

Future<Map<Lift, List<AssistanceExercise>>> loadData() async {
  var results = <Lift, List<AssistanceExercise>>{};
  for (var lift in GLOBAL_ALL_LIFTS) {
    List<AssistanceExercise> exercises =
        await AssistanceLiftHelper().getAllExercises(lift.id);
    results[lift] = exercises;
  }
  return results;
}

Widget buildOutput(BuildContext context,
    AsyncSnapshot<Map<Lift, List<AssistanceExercise>>> snapshot) {
  var cardTexts = <Lift, List<Widget>>{};
  double height = 250;
  if (snapshot.hasData) {
    Map<Lift, List<AssistanceExercise>> data = snapshot.data!;
    for (var lift in GLOBAL_ALL_LIFTS) {
      var exercises = data[lift];
      if (exercises == null || exercises.length == 0) {
        cardTexts[lift] = [
          Row(children: [Text('You have not created any assistance')]),
          Row(children: [Text('exercises for this core lift yet')]),
        ];
      } else {
        cardTexts[lift] = exercises
            .map((AssistanceExercise e) => Text(e.toString()))
            .toList();
      }
    }
  } else {
    for (var lift in GLOBAL_ALL_LIFTS) {
      cardTexts[lift] = dataFetchingIndicator();
      height = 290;
    }
  }
  return ListView(
      children: GLOBAL_ALL_LIFTS
          .map((e) => NonTappableCard(
                cartContent: HomeCard(e.title, Column(children: cardTexts[e]!),
                    'graphics/${e.abbreviation}.png'),
                customHeight: height,
              ))
          .toList());
}
