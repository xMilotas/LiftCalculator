import 'package:flutter/material.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:provider/provider.dart';

class LiftSelector with ChangeNotifier {
  Lift currentExercise;

  LiftSelector(): this.currentExercise = Lift(0, "Overhead Press", "OHP");

  changeExercise(Lift newExercise) {
    this.currentExercise = newExercise;
    notifyListeners();
  }
}

Widget changeLiftDialog(BuildContext context, StateSetter setState) {
  var liftSelection = Provider.of<LiftSelector>(context);

  String? _trainingOption = liftSelection.currentExercise.abbreviation;
  List<Widget> output = [];
  GLOBAL_ALL_LIFTS.forEach((e) {
    RadioListTile temp = RadioListTile<String>(
      title: Text(e.title),
      value: e.abbreviation,
      groupValue: _trainingOption,
      onChanged: (String? value) {
        setState(() {
          _trainingOption = value;
          liftSelection.changeExercise(e);
          Navigator.pop(context, 'Saved');
        });
      },
    );
    output.add(temp);
  });

  return Column(mainAxisSize: MainAxisSize.min, children: output);
}


