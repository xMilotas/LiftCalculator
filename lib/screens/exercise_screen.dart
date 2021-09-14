import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
import 'package:liftcalculator/models/training.dart';
import 'package:liftcalculator/util/programs.dart';
import 'package:liftcalculator/util/weight.dart';
import 'package:provider/provider.dart';

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
  int currentAssistantExercise = -1;

  // TODO: Assistance..

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

  void updateExercise(int sets){
    setState(() {
      // Reset reps
      reps = -1;

      // Handle core exercises:
      if(currentCoreExercise < 3) currentCoreExercise++;
      if(currentCoreExercise == 3){
        coreDone = true;
      }
      // Handle cycle - compare to sets 
      if(coreDone){
        currentCycleExercise ++;
        if(sets == currentCycleExercise) cycleDone = true;
      }
    });
  }


  LiftNumber getCurrentExercise(LiftDay week){
    if(currentCoreExercise < 3)
      return week.coreLifts[currentCoreExercise];
    else return week.cycleLift[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var profile = Provider.of<UserProfile>(context, listen: false);
    LiftDay week = getCurrentWeek(profile);

    int exerciseTrainingMax = (profile.currentExercise.current1RM * profile.currentTrainingMaxPercentage / 100).round();
    LiftNumber exerciseToDo = getCurrentExercise(week);
    WeightReps weightReps = WeightReps(exerciseToDo.weightPercentage/100 * exerciseTrainingMax, exerciseToDo.reps);
    if(reps == -1) reps = weightReps.reps;

    return Scaffold(
        appBar: buildAppBar(context, profile.currentExercise.title),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(exerciseToDo.pr)
                    RichText(
                      text: TextSpan(
                        text: reps.toString(), 
                        style: theme.textTheme.headline1!.copyWith(fontSize: 160),
                        children: [
                          WidgetSpan(child: Transform.translate(offset: Offset(10.0, -40.0), child: Text("+", style: theme.textTheme.headline2,),))
                        ]
                      ),
                    )
                  else Text(reps.toString(), style: theme.textTheme.headline1!.copyWith(fontSize: 160)),
                  if(exerciseToDo.sets >1) Text(currentCycleExercise.toString()+'/'+exerciseToDo.sets.toString(), style: theme.textTheme.headline4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, size: 32),
                        color: Colors.white,
                        onPressed: increase
                      ),
                      IconButton(
                        icon: Icon(Icons.remove, size: 32),
                        color: Colors.white,
                        onPressed: decrease
                      )
                    ],
                  ),
                  Divider(thickness: 4,),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(weightReps.weight.toString(), style: theme.textTheme.headline3),
                  ),
                  Divider(thickness: 4,),
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
                        // TODO: Save to DB
                        print("[EXERCISE]: Saving to DB reps: $reps, weight: ${weightReps.weight}");
                        // Increase counter of exercise --
                        updateExercise(exerciseToDo.sets);
                        // If we have a next exercise then redraw the screen with the next one, if not move to home screen - or show notification
                        if (cycleDone && coreDone){

                          // Mark exercise for this week as done, set current to the next one
                          // If all for this week = done -- next week
                          // If week 3 - cycle handling

                          // Draw overlay
                          showDialog(
                            context: context,
                            builder: (context) => drawTrainingFinished(context)
                          );
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

drawTrainingFinished(context) => AlertDialog(
    title: Text('Session done'),
    content: Text('Well done - Time to rest'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        child: Text('AWESOME'),
      ),

    ],
  );

