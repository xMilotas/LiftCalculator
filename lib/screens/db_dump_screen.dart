import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/changeLiftDialog.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:provider/provider.dart';


/// This screen just displays all information for a lift type stored in the DB

class DbDumpScreen extends StatefulWidget {
  @override
  _DbDumpScreenState createState() => _DbDumpScreenState();
}

class _DbDumpScreenState extends State<DbDumpScreen> {
  @override
  Widget build(BuildContext context) {
    Lift currentExercise =
        Provider.of<LiftSelector>(context).currentExercise;
    return Scaffold(
      appBar: buildAppBar(context, currentExercise.title),
      body: Scrollbar(
        child: FutureBuilder(
            future: getDBDump(currentExercise),
            builder:
                (BuildContext context, AsyncSnapshot<List<DbLift>> snapshot) =>
                    buildDBDumpOutput(context, snapshot)),
      ),
      drawer: buildDrawer(context),
    );
  }

  Future<List<DbLift>> getDBDump(Lift currentExercise) async {
    LiftHelper helper = LiftHelper();
    List<DbLift> allLifts =
        await helper.getHighestLiftsPerDay(currentExercise.id);
    return allLifts;
  }

  Widget buildDBDumpOutput(
      BuildContext context, AsyncSnapshot<List<DbLift>> snapshot) {
    List<Widget> output;
    if (snapshot.hasData) {
      List<DbLift> data = snapshot.data!;
      if (data.length == 0)
        output = [Text('You have not performed any lifts yet')];
      else {
        output = data
            .map((e) => Row(
                  children: [
                    Text('Date: ${e.date} |'),
                    Text(e.weightRep.toString()),
                    Text('| MAX: ${e.calculated1RM}')
                  ],
                ))
            .toList();
      }
    } else {
      output = dataFetchingIndicator();
    }
    return ListView(
      children: [
        TextButton(
          child: Text('CHANGE EXERCISE'),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Change exercise'),
                  content: StatefulBuilder(
                      builder: (context, setState) =>
                          changeLiftDialog(context, setState)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              }),
        ),
        ...output
      ],
    );
  }
}
