/**
 * 
 * This is for individual lifts
 * 
 * A lift is defined by no. reps, weight, & type of excercise
 * Once performed we can use it to calculate our 1 RM
 * And store it accordingly
 * The weight and the number of reps is pre-set and calculated via 'Training' but should be customizable
 * 
 */
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
import 'package:provider/provider.dart';

class ExcerciseScreen extends StatefulWidget {
  @override
  _ExcerciseScreenState createState() => _ExcerciseScreenState();
}

class _ExcerciseScreenState extends State<ExcerciseScreen> {
  int reps = 5;
    

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var profile = Provider.of<UserProfile>(context);
 
    if (profile.isLoaded == false) {
      return Splash();
    } else
      return Scaffold(
        appBar: buildAppBar(context, 'Overhead Press'),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(reps.toString(), style: theme.textTheme.headline1!.copyWith(fontSize: 160)),
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
                    child: Text('40 kg', style: theme.textTheme.headline3),
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
                        // Make sure we get current value of counter here - if we have counter as a screen state/or some other state this is possible
                        // Save it to DB
                        // If we have a next excercise then redraw the screen with the next one, if not move to home screen - or show notification
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



