// used to add custom lifts for stats keeping (this is useful for days where we perform deload weeks)
// Class has the 2 controllers and the 2 fields with the corresponding controller
// Which controls the number of Inputs on the screen
// + Button creates a new class/element
// Save button walks trough list of all elements and stores it

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/screens/exercise_screen.dart';
import 'package:liftcalculator/util/globals.dart';
import 'package:liftcalculator/util/weight_reps.dart';

class AddCustomLiftsScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddCustomLiftsScreen(this.selectedDate);

  @override
  _StatsPerDayScreenState createState() => _StatsPerDayScreenState();
}

class LiftEditor {
  TextEditingController repsController;
  TextEditingController weightController;

  LiftEditor(this.repsController, this.weightController);
}

class _StatsPerDayScreenState extends State<AddCustomLiftsScreen> {
  List<LiftFormField> fields = [];
  Lift dropDownValue = GLOBAL_ALL_LIFTS[0];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, setState,
          "Add lift for ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}"),
      body: ListView(children: [
        Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<Lift>(
                value: dropDownValue,
                items: GLOBAL_ALL_LIFTS
                    .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.title)))
                    .toList(),
                onChanged: (Lift? value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                },
              )
            ])),
        ...fields,
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              fields.add(LiftFormField());
            });
          },
          icon: Icon(Icons.add, size: 18),
          label: Text("Add exercise set"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              fields.removeLast();
            });
          },
          icon: Icon(Icons.delete, size: 18),
          label: Text("Remove exercise set"),
        ),
        ElevatedButton.icon(
          onPressed: () => {
            fields.forEach((element) {
              var reps = element.controllers.repsController.text;
              var weight = element.controllers.weightController.text;
              DbLift _tempLift = DbLift(dropDownValue.id, widget.selectedDate,
                  WeightReps(double.parse(weight), int.parse(reps)));
              writeToDB(_tempLift);
              Navigator.pop(context);
            })
          },
          icon: Icon(Icons.save, size: 18),
          label: Text('Save'),
        ),
      ]),
    );
  }
}

class LiftFormField extends StatelessWidget {
  final LiftEditor controllers;

  LiftFormField()
      : controllers = LiftEditor(
            TextEditingController(text: '0'), TextEditingController(text: '0'));

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Reps',
                ),
                keyboardType: TextInputType.number,
                controller: this.controllers.repsController),
            TextFormField(
              decoration: InputDecoration(
                  filled: true, labelText: 'Weight', suffixText: 'kg'),
              keyboardType: TextInputType.number,
              controller: this.controllers.weightController,
            ),
          ],
        ));
  }
}
