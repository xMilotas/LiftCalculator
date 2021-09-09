import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
import 'package:liftcalculator/models/training.dart';
import 'package:liftcalculator/util/programs.dart';
import 'package:liftcalculator/util/weight.dart';
import 'package:provider/provider.dart';

class ExcerciseScreen extends StatefulWidget {
  @override
  _ExcerciseScreenState createState() => _ExcerciseScreenState();
}

class _ExcerciseScreenState extends State<ExcerciseScreen> {

  int reps = -1;
  // Describes on which current excercise we are 
  int currentCoreExcercise = 0;
  bool coreDone = false;
  bool cycleDone = false;

  int currentCycleExcercise = -1;
  int currentAssistantExcercise = -1;

  // TODO: Assistance..

  // Counter is modifyable outside of context but default value should be set by provider

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

  void updateExcercise(int sets){
    setState(() {
      // Reset reps
      reps = -1;

      // Handle core execises:
      if(currentCoreExcercise < 3) currentCoreExcercise++;
      if(currentCoreExcercise == 3){
        coreDone = true;
      }
      // Handle cycle - compare to sets 
      if(coreDone){
        currentCycleExcercise ++;
        if(sets == currentCycleExcercise) cycleDone = true;
      }
    });
  }


  LiftNumber getCurrentExcercise(LiftDay week){
    if(currentCoreExcercise < 3)
      return week.coreLifts[currentCoreExcercise];
    else return week.cycleLift[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var profile = Provider.of<UserProfile>(context, listen: false);
    LiftDay week = getCurrentWeek(profile);

    int excerciseTrainingMax = (profile.currentExcercise.current1RM * profile.currentTrainingMaxPercentage / 100).round();
    LiftNumber excerciseToDo = getCurrentExcercise(week);
    WeightReps weightReps = WeightReps(excerciseToDo.weightPercentage/100 * excerciseTrainingMax, excerciseToDo.reps);
    if(reps == -1) reps = weightReps.reps;

    return Scaffold(
        appBar: buildAppBar(context, profile.currentExcercise.title),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(reps.toString(), style: theme.textTheme.headline1!.copyWith(fontSize: 160)),
                  if(excerciseToDo.sets >1) Text(currentCycleExcercise.toString()+'/'+excerciseToDo.sets.toString(), style: theme.textTheme.headline4),
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
                        print("[EXCERCISE]: Saving to DB reps: $reps, weight: ${weightReps.weight}");
                        // Increase counter of excercise --
                        updateExcercise(excerciseToDo.sets);
                        // If we have a next excercise then redraw the screen with the next one, if not move to home screen - or show notification
                        if (cycleDone && coreDone){

                          // Mark excercise for this week as done, set current to the next one
                          // If all for this week = done -- next week
                          // If week 3 - cycle handling

                          // Draw overlay
                          showDialog(
                            context: context,
                            builder: (context) => drawTrainingFinished(context)
                          );
                          Navigator.pushNamed(context, '/');
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

