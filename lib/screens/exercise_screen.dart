import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/models/training.dart';
import 'package:liftcalculator/util/globals.dart';
import 'package:liftcalculator/util/programs.dart';
import 'package:liftcalculator/util/weight_reps.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sql.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int reps = -1;
  // Describes on which current exercise we are
  int currentCoreExercise = 0;
  bool coreDone = false;
  bool cycleDone = false;

  int currentCycleExercise = -1;

  // Counter is modifiable outside of context but default value should be set by provider

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

  void updateExercise(int sets) {
    setState(() {
      // Reset reps
      reps = -1;

      // Handle core exercises:
      if (currentCoreExercise < 3) currentCoreExercise++;
      if (currentCoreExercise == 3) {
        coreDone = true;
      }
      // Handle cycle - compare to sets
      if (coreDone) {
        currentCycleExercise++;
        if (sets == currentCycleExercise) cycleDone = true;
      }
    });
  }

  /// Gets the percentages for the current week/exercise
  LiftNumber getCurrentExercise(LiftDay week, int exerciseId) {
    if (!coreDone)
      return week.coreLifts[currentCoreExercise];
    else
      return week.cycleLift[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var profile = Provider.of<UserProfile>(context, listen: false);
    // Get percentages for this exercise
    LiftDay week = getCurrentWeek(profile);
    LiftNumber exerciseToDo =
        getCurrentExercise(week, profile.currentExercise.id);

    // Perform calculations
    WeightReps weightReps = WeightReps(
        profile.currentExercise.trainingMax *
            exerciseToDo.weightPercentage /
            100,
        exerciseToDo.reps);
    if (reps == -1) reps = weightReps.reps;
    int calculated1RM =
        ((weightReps.weight * reps * 0.0333) + weightReps.weight).round();
    int maxCalculated1RM = profile.max1RMs[profile.currentExercise.id]!;
    int repsForNew1RM =
        ((maxCalculated1RM - weightReps.weight) / weightReps.weight * 30.03003)
            .round();

    return Scaffold(
      appBar: buildAppBar(context, profile.currentExercise.title),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (exerciseToDo.pr)
                  RichText(
                    text: TextSpan(
                        text: reps.toString(),
                        style:
                            theme.textTheme.headline1!.copyWith(fontSize: 160),
                        children: [
                          WidgetSpan(
                              child: Transform.translate(
                            offset: Offset(10.0, -40.0),
                            child: Text(
                              "+",
                              style: theme.textTheme.headline2,
                            ),
                          ))
                        ]),
                  )
                else
                  Text(reps.toString(),
                      style:
                          theme.textTheme.headline1!.copyWith(fontSize: 160)),
                if (exerciseToDo.sets > 1)
                  Text(
                      currentCycleExercise.toString() +
                          '/' +
                          exerciseToDo.sets.toString(),
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
                  child: Text(weightReps.weight.toString(),
                      style: theme.textTheme.headline3),
                ),
                Divider(
                  thickness: 4,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Calculated 1RM: $calculated1RM kg',
                      style: theme.textTheme.headline3!.copyWith(fontSize: 16)),
                ),
                if (exerciseToDo.pr)
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text('Perform $repsForNew1RM+ reps for a new PR',
                        style:
                            theme.textTheme.headline3!.copyWith(fontSize: 16)),
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
                    style: OutlinedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20)),
                    onPressed: () {
                      // Prevent accidental presses by checking if current exercise is done already
                      if (!profile.cycleWeek
                          .getLiftStatus(profile.currentExercise.id)) {
                        DateTime today = DateTime.now();
                        DbLift _tempLift = DbLift(
                            profile.currentExercise.id,
                            DateTime(
                                today.year,
                                today.month,
                                today
                                    .day), // only store the current day, not time
                            WeightReps(weightReps.weight, reps));
                        writeToDB(_tempLift);
                        // Increase counter of exercise --
                        updateExercise(exerciseToDo.sets);
                        // If we have a next exercise then redraw the screen with the next one, if not move to assistance screen
                        if (cycleDone && coreDone) {
                          Navigator.popAndPushNamed(context, '/assistance');
                        }
                      }
                    },
                    child: Text("DONE"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }
}

writeToDB(DbLift lift) async {
  print("[EXERCISE]: Saving to DB $lift");
  await GLOBAL_DB!.insert('lift', lift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}
