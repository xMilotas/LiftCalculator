import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/models/liftChart.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: buildAppBar(context, "Stats"),
        drawer: buildDrawer(context),
        body: buildCharts(profile));
  }
}

buildCharts(UserProfile user) {
  return FutureBuilder(
      future: dataFetcher(user),
      builder:
          (BuildContext context, AsyncSnapshot<Map<int, List<DbLift>>> snapshot) {
        Widget output;
        if (snapshot.hasData) {
          Map<int, List<DbLift>> data = snapshot.data!;
          var liftCharts = <Widget>[];
          for (MapEntry<int, List<DbLift>> e in data.entries) {
            // Build series
            var liftSeries = new charts.Series<DbLift, DateTime>(
              id: e.key.toString(),
              domainFn: (DbLift lift, _) => lift.date,
              measureFn: (DbLift lift, _) => lift.calculated1RM,
              data: e.value,
            );
            liftCharts.add(SizedBox(
                height: 250.0,
                child: LiftChart([liftSeries], user.liftList[e.key].title)));
          }
          output = ListView(children: liftCharts);
        } else
          output =
              Center(child: Column(children: [...dataFetchingIndicator()]));
        return output;
      });
}

/// Queries the data for all lifts and returns it as a Map[ID - List[Lift]]
Future<Map<int, List<DbLift>>> dataFetcher(UserProfile profile) async {
  LiftHelper helper = LiftHelper(profile.db);
  var stats = <int, List<DbLift>>{};
  for (var i = 0; i < profile.liftList.length; i++) {
    int id = profile.liftList[i].id;
    List<DbLift> tmp = await helper.getHighestLiftsPerDay(id);
    stats[id] = tmp;
  }
  return stats;
}
