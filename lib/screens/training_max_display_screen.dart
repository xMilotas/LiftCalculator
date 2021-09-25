import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/dbTrainingMax.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TrainingMaxScreen extends StatefulWidget {
  @override
  _TrainingMaxScreenState createState() => _TrainingMaxScreenState();
}

class _TrainingMaxScreenState extends State<TrainingMaxScreen> {
  @override
  Widget build(BuildContext context) {
    var tms = <int, double>{};
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
      appBar: buildAppBar(context, "Training Max Overview"),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...profile.liftList
              .map((lift) => TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '${lift.title} Training Max',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: lift.trainingMax.toString(),
                  onChanged: (String? value) {
                    if (value != '') {
                      tms[lift.id] = double.parse(value!);
                    }
                  }))
              .toList(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => onPressed(context, tms),
                child: Text('Save'),
              ),
            ],
          )
        ]),
      ),
    );
  }

  onPressed(BuildContext context, Map<int, double> tms) {
    var profile = Provider.of<UserProfile>(context, listen: false);
    // for each TM check if input has changed and store accordingly
    profile.liftList.forEach((tm) {
      if (tms[tm.id] != null && tms[tm.id] != tm.trainingMax) {
        tm.trainingMax = tms[tm.id]!;
        tm.saveData();
        DateTime today = DateTime.now();
        DbTrainingMax dbTM = DbTrainingMax(tm.id,
            DateTime(today.year, today.month, today.day), tm.trainingMax);
        dbTM.writeToDB();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueGrey,
        content: const Text('Saved successfully'),
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
  }
}
