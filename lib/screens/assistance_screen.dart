import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/util/assistance.dart';
import 'package:provider/provider.dart';

class AssistanceScreen extends StatefulWidget {
  @override
  _AssistanceScreenState createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  int reps = -1;
  int currentAssistanceNumber = 0;
  bool assistanceDone = false;
  int currentSet = 0;

  void increase() {
    setState(() {
      reps++;
    });
  }

  void decrease() {
    setState(() {
      reps--;
    });
  }

  void updateExercise(int sets, int totalExercises) {
    setState(() {
      // Reset reps
      reps = -1;
      currentSet++;
      if (sets == currentSet) {
        // End reached?
        if (totalExercises == currentAssistanceNumber + 1) {
          assistanceDone = true;
        } else {
          // Go to next assistance exercise
          currentAssistanceNumber++;
          currentSet = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context, listen: false);
    return FutureBuilder(
        future: loadData(profile.currentExercise.id),
        builder: (BuildContext context,
                AsyncSnapshot<List<AssistanceExercise>> snapshot) =>
            buildOutput(context, snapshot, profile));
  }

  Future<List<AssistanceExercise>> loadData(int liftId) async {
    return await AssistanceLiftHelper().getAllExercises(liftId);
  }

  buildOutput(BuildContext context,
      AsyncSnapshot<List<AssistanceExercise>> snapshot, UserProfile profile) {
    if (snapshot.hasData) {
      if (snapshot.data!.length == 0) {
          Timer.run(() {
            showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          drawTrainingFinished(context, profile));
          });
        return Scaffold(
          appBar: buildAppBar(context, setState),
          drawer: buildDrawer(context),
        );
      } else {
        AssistanceExercise exercise = snapshot.data![currentAssistanceNumber];
        if (reps == -1) reps = exercise.reps;
        return Scaffold(
          appBar: buildAppBar(context, setState, exercise.exerciseName),
          body: Center(
            child: Column(
                children: buildExerciseScreenArea(
                    context,
                    reps,
                    exercise.sets,
                    currentSet,
                    exercise.weight,
                    snapshot.data!.length,
                    profile,
                    increase,
                    decrease)),
          ),
          drawer: buildDrawer(context),
        );
      }
    } else
      return Scaffold(
          appBar: buildAppBar(context, setState, 'Assistance'),
          body: Center(
            child: Column(children: dataFetchingIndicator()),
          ),
          drawer: buildDrawer(context));
  }

  drawTrainingFinished(BuildContext context, UserProfile profile) =>
      AlertDialog(
        title: Text('Session done'),
        content: Text('Well done - Time to rest'),
        actions: [
          TextButton(
            onPressed: () {
              profile.cycleWeek
                  .markLiftAsDone(profile.currentExercise.id, profile);
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/');
            },
            child: Text('AWESOME'),
          ),
        ],
      );

  buildExerciseScreenArea(
      BuildContext context,
      int reps,
      int sets,
      int currentSetNumber,
      double weight,
      int totalExercises,
      UserProfile profile,
      increase,
      decrease) {
    final theme = Theme.of(context);
    return [
      Spacer(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(reps.toString(),
              style: theme.textTheme.headline1!.copyWith(fontSize: 160)),
          if (sets > 1)
            Text(currentSetNumber.toString() + '/' + sets.toString(),
                style: theme.textTheme.headline4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.add, size: 32),
                  color: Colors.white,
                  onPressed: increase),
              IconButton(
                  icon: Icon(Icons.remove, size: 32),
                  color: Colors.white,
                  onPressed: decrease)
            ],
          ),
          Divider(
            thickness: 4,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(weight.toString(), style: theme.textTheme.headline3),
          ),
        ],
      ),
      Spacer(),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              style:
                  OutlinedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
              onPressed: () {
                // Handle sets
                updateExercise(sets, totalExercises);
                if (assistanceDone) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          drawTrainingFinished(context, profile));
                }
              },
              child: Text("DONE"),
            ),
          ),
        ],
      )
    ];
  }
}
