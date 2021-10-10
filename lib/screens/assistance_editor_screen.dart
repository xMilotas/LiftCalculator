// Used to edit performed lifts

import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/util/globals.dart';

class AssistanceEditorScreen extends StatefulWidget {
  @override
  _StatsPerDayScreenState createState() => _StatsPerDayScreenState();
}

class _StatsPerDayScreenState extends State<AssistanceEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Assistance"),
      drawer: buildDrawer(context),
      //TODO: Add icon to button 
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add new assistance exercise'),
                content: StatefulBuilder(
                    builder: (context, setState) =>
                        addAssistanceDialog(context, setState)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    //TODO: Actually safe whatever was passed -- probably creates a new assistance class object and saves it to the DB
                    onPressed: () => Navigator.pop(context, 'Saved'),
                    child: const Text('Save'),
                  ),
                ],
              );
            }),
      ),
      body: ListView(children: [
        ...GLOBAL_ALL_LIFTS
            .map((e) => Card(
                  child: Column(
                    children: [
                      // TODO: needs to be a DB call to load the input
                      // List current configured assistance exercises
                    ],
                  ),
                ))
            .toList(),
      ]),
    );
  }
}

addAssistanceDialog(BuildContext context, StateSetter setState) {
  //TODO: Set proper editing controllers that can be accessed by outer scope
  return Column(mainAxisSize: MainAxisSize.min, children: [
    TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: 'Exercise Name',
      ),
      keyboardType: TextInputType.text,
      controller: TextEditingController(),
    ),
    //TODO: Fix formatting
    DropdownButton<Lift>(
        items: GLOBAL_ALL_LIFTS
            .map((e) => DropdownMenuItem(value: e, child: Text(e.title)))
            .toList(),
        onChanged: ((Lift? value) => print(value?.title))),
    TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: 'Number of sets',
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(),
    ),
    TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: 'Number of reps per set',
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(),
    ),
    TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: '(Optional) Weight per rep',
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(),
    ),
  ]);
}
