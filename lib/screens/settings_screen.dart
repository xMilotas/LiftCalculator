import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:liftcalculator/models/cycleWeek.dart';
import 'package:liftcalculator/models/dbLift.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/screens/exercise_screen.dart';
import 'package:liftcalculator/util/weight_reps.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum CycleTemplates { BoringButBig, FirstSetLast }

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Define your settings here'),
      ),
      body: ListView(
        children: [
          Consumer<UserProfile>(
            builder: (context, user, child) {
              return SpinBox(
                decoration: InputDecoration(
                  labelText: 'Current Training Max Percentage',
                  suffixText: '%',
                ),
                step: 5,
                min: 70,
                max: 95,
                value: user.currentTrainingMaxPercentage.toDouble(),
                onChanged: (value) => storeSetting(
                    context, 'Training_Max_Percentage', value.toInt()),
              );
            },
          ),
          SpinBox(
              decoration: InputDecoration(
                labelText: 'Current Training Week',
              ),
              step: 1,
              min: 1,
              max: 3,
              value: profile.cycleWeek.week.toDouble(),
              onChanged: (value) => storeSetting(context, 'Current_Week',
                  CycleWeek(value.toInt()).toString())),
          buildCycleTemplateSetting(context, profile),
          generateSampleData(context, profile),
          buildResetCycleWeekSetting(context, profile),
          deleteTrainingData(context, profile)
        ],
      ),
    );
  }

  ListTile buildCycleTemplateSetting(
      BuildContext context, UserProfile profile) {
    return ListTile(
      title: Text('Selected cycle template'),
      subtitle: Consumer<UserProfile>(
        builder: (context, user, child) {
          if (user.cycleTemplate == 'FirstSetLast')
            return Text("First Set Last");
          else
            return Text("Boring But Big");
        },
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          CycleTemplates? _cycleTemplate = CycleTemplates.BoringButBig;
          if (profile.cycleTemplate == 'FirstSetLast')
            _cycleTemplate = CycleTemplates.FirstSetLast;
          return AlertDialog(
            title: const Text('Change template'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<CycleTemplates>(
                    title: Text('Boring But Big'),
                    value: CycleTemplates.BoringButBig,
                    groupValue: _cycleTemplate,
                    onChanged: (CycleTemplates? value) {
                      setState(() {
                        _cycleTemplate = value;
                        storeSetting(context, 'Cycle_Template', 'BoringButBig');
                        Navigator.pop(context, 'Saved');
                      });
                    },
                  ),
                  RadioListTile<CycleTemplates>(
                    title: Text('First Set Last'),
                    value: CycleTemplates.FirstSetLast,
                    groupValue: _cycleTemplate,
                    onChanged: (CycleTemplates? value) {
                      setState(() {
                        _cycleTemplate = value;
                        storeSetting(context, 'Cycle_Template', 'FirstSetLast');
                        Navigator.pop(context, 'Saved');
                      });
                    },
                  )
                ],
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }
}

ListTile generateSampleData(BuildContext context, UserProfile profile) {
  return ListTile(
      title: Text('Generate sample data'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Random random = new Random();
        // Setup sample values for TM
        profile.liftList.forEach((trainingMax) {
          trainingMax.storeValue('reps', random.nextInt(9) + 1);
          trainingMax.storeValue('weight', random.nextInt(80) + 30);
          trainingMax.saveData();
        });
        for (var liftId = 0; liftId < 4; liftId++) {
          for (var lift = 1; lift < 50; lift++) {
            // Generate sample lifts - 1 lift is performed every 9th day
            DbLift _tempLift = DbLift(
                liftId,
                DateTime(2021, 7, liftId + 2).add(Duration(days: 9 + lift)),
                WeightReps(random.nextInt(80) + 30, random.nextInt(10) + 1));
            writeToDB(profile, _tempLift);
          }
        }
      });
}

ListTile deleteTrainingData(BuildContext context, UserProfile profile) {
  return ListTile(
      title: Text('Delete all data'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => {
                        deleteDB(profile),
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blueGrey,
                              content: const Text('All data has been deleted'),
                              duration: const Duration(milliseconds: 1500),
                              width: 280.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        Navigator.pop(context, 'Saved')
                        },
                      child: const Text('Delete all progress'),
                    )
                  ],
                ));
      });
}

deleteDB(UserProfile profile) async {
  await profile.db.delete('Lift');
}

storeSetting(context, String referenceVar, dynamic value) async {
  Provider.of<UserProfile>(context, listen: false)
      .storeUserSetting(referenceVar, value);
}

buildResetCycleWeekSetting(BuildContext context, UserProfile profile) {
  return ListTile(
      title: Text('Reset current weeks progress'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => {
                        profile.cycleWeek.resetWeekProgress(user: profile),
                        Navigator.pop(context, 'Saved')
                      },
                      child: const Text('Delete progress'),
                    )
                  ],
                ));
      });
}
