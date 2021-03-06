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
    for (var lift in widget.selectedLift) {
      controllers[lift] = LiftEditor(
          TextEditingController(text: lift.weightRep.reps.toString()),
          TextEditingController(text: lift.weightRep.weight.toString()));
    }
    return Scaffold(
      appBar:
          buildAppBar(context, setState, "Edit ${widget.selectedLift[0].date}"),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: const Text('Successfully saved'),
                  duration: const Duration(milliseconds: 1500),
                  width: 280.0, // Width of the SnackBar.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, // Inner padding for SnackBar content.
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
              Navigator.pop(context);
            })
          },
          child: Text('Save'),
        ),
      ]),
    );
  }
}
