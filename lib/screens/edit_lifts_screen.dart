// Used to edit performed lifts

import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/drawer.dart';

class EditLiftsScreen extends StatefulWidget {
  final List<DbLift> selectedLift;
  const EditLiftsScreen(this.selectedLift);

  @override
  _StatsPerDayScreenState createState() => _StatsPerDayScreenState();
}

class LiftEditor {
  TextEditingController repsController;
  TextEditingController weightController;

  LiftEditor(this.repsController, this.weightController);
}

class _StatsPerDayScreenState extends State<EditLiftsScreen> {
  var controllers = <DbLift, LiftEditor>{};
  @override
  Widget build(BuildContext context) {
    var initialValues = widget.selectedLift;

    for (var lift in widget.selectedLift) {
      controllers[lift] = LiftEditor(
          TextEditingController(text: lift.weightRep.reps.toString()),
          TextEditingController(text: lift.weightRep.weight.toString()));
    }
    return Scaffold(
      appBar: buildAppBar(context, "Edit ${widget.selectedLift[0].date}"),
      drawer: buildDrawer(context),
      body: ListView(children: [
        ...widget.selectedLift
            .map(
              (e) => Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Reps',
                      ),
                      keyboardType: TextInputType.number,
                      controller: controllers[e]?.repsController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          filled: true, labelText: 'Weight', suffixText: 'kg'),
                      keyboardType: TextInputType.number,
                      controller: controllers[e]?.weightController,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        ElevatedButton(
          onPressed: () => {
            widget.selectedLift.forEach((element) {
              print(element);
              var reps = controllers[element]!.repsController.text;
              var weight = controllers[element]!.weightController.text;
              // Update DB
              LiftHelper().updateLift(element, reps, weight);
            })
          },
          child: Text('Save'),
        ),
      ]),
    );
  }
}
