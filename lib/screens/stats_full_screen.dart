import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/dbTrainingMax.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/models/liftChart.dart';
import 'package:provider/provider.dart';

class StatsFullScreen extends StatefulWidget {
  final int liftId;
  final String selectedStat;
  const StatsFullScreen(this.liftId, this.selectedStat);
  @override
  _StatsFullScreenState createState() => _StatsFullScreenState();
}

class _StatsFullScreenState extends State<StatsFullScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: buildAppBar(context, setState, "Stats"),
        drawer: buildDrawer(context),
        body: buildChart(profile, widget.liftId, widget.selectedStat));
  }
}

buildChart(UserProfile user, int liftId, String selectedStat) {
  if (selectedStat == 'TM') return tmBuilder(user, liftId);
  else return FutureBuilder(
      future: dataFetcher(liftId),
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, List<DbLift>>> snapshot) {
        Widget output;
        if (snapshot.hasData) {
          Map<int, List<DbLift>> data = snapshot.data!;
          var liftCharts = <Widget>[];
          for (MapEntry<int, List<DbLift>> e in data.entries) {
            // Build series
            var liftSeries = new charts.Series<DbLift, DateTime>(
              id: e.key.toString(),
              domainFn: (DbLift lift, _) => lift.date,
              measureFn: (DbLift lift, _) => (selectedStat == '1RM')
                  ? lift.calculated1RM
                  : lift.weightRep.weight,
              data: e.value,
            );
            liftCharts.add(LiftChart(
                [liftSeries], user.liftList[e.key].title, selectedStat,
                fullscreen: true));
          }
          output = Column(children: liftCharts);
        } else
          output =
              Center(child: Column(children: [...dataFetchingIndicator()]));
        return output;
      });
}

/// Queries the data for all lifts and returns it as a Map[ID - List[Lift]]
Future<Map<int, List<DbLift>>> dataFetcher(int liftId) async {
  var stats = <int, List<DbLift>>{};
  List<DbLift> tmp = await LiftHelper().getHighestLiftsPerDay(liftId);
  stats[liftId] = tmp;
  return stats;
}

tmBuilder(UserProfile user, int liftId) {
  return FutureBuilder(
      future: tmDataFetcher(liftId),
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, List<DbTrainingMax>>> snapshot) {
        Widget output;
        if (snapshot.hasData) {
          Map<int, List<DbTrainingMax>> data = snapshot.data!;
          var liftCharts = <Widget>[];
          for (MapEntry<int, List<DbTrainingMax>> e in data.entries) {
            // Build series
            var liftSeries = new charts.Series<DbTrainingMax, DateTime>(
              id: e.key.toString(),
              domainFn: (DbTrainingMax lift, _) => lift.date,
              measureFn: (DbTrainingMax lift, _) => lift.weight,
              data: e.value,
            );
            liftCharts.add(LiftChart(
                [liftSeries], user.liftList[e.key].title, 'TM',
                fullscreen: true));
          }
          output = Column(children: liftCharts);
        } else
          output =
              Center(child: Column(children: [...dataFetchingIndicator()]));
        return output;
      });
}

Future<Map<int, List<DbTrainingMax>>> tmDataFetcher(int liftId) async {
  var stats = <int, List<DbTrainingMax>>{};
  List<DbTrainingMax> tmp = await TrainingMaxHelper().getAll(liftId);
  stats[liftId] = tmp;
  return stats;
}
