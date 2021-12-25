import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/dbTrainingMax.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/models/liftChart.dart';
import 'package:liftcalculator/models/selectedLift.dart';
import 'package:liftcalculator/screens/stats_full_screen.dart';
import 'package:liftcalculator/util/globals.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedStat = '1RM';
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: buildAppBar(context, setState, "Stats"),
        body: buildCharts(profile));
  }

  buildCharts(UserProfile user) {
    if (_selectedStat == 'TM') return tmBuilder(user);
    else return FutureBuilder(
        future: dataFetcher(user, _selectedStat),
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
                measureFn: (DbLift lift, _) => (_selectedStat == '1RM')
                    ? lift.calculated1RM
                    : lift.weightRep.weight,
                data: e.value,
              );
              liftCharts.add(Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: SizedBox(
                      height: 300.0,
                      child: Stack(
                        children: [
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: Colors.blueGrey.shade900,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: LiftChart([liftSeries],
                                    user.liftList[e.key].title, _selectedStat),
                              )),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                          child: Text('1 RM'), value: '1RM'),
                                      const PopupMenuItem<String>(
                                          child: Text('TM'), value: 'TM'),
                                      const PopupMenuItem<String>(
                                        child: Text('Weight'),
                                        value: 'Weight',
                                      ),
                                    ],
                                onSelected: (String value) => {
                                      Provider.of<StatsSelectedLift>(context,
                                              listen: false)
                                          .changeStatsType(value),
                                      setState(() {
                                        _selectedStat = value;
                                      }),
                                    }),
                          ),
                          Positioned(
                            top: 220,
                            right: 15,
                            child: IconButton(
                                icon: Icon(Icons.fullscreen),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => StatsFullScreen(
                                            user.liftList[e.key].id,
                                            _selectedStat)))),
                          ),
                        ],
                      ))));
            }
            output = ListView(children: liftCharts);
          } else
            output =
                Center(child: Column(children: [...dataFetchingIndicator()]));
          return output;
        });
  }

  tmBuilder(UserProfile user) {
    return FutureBuilder(
        future: tmDataFetcher(),
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
              liftCharts.add(Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: SizedBox(
                      height: 300.0,
                      child: Stack(
                        children: [
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: Colors.blueGrey.shade900,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: LiftChart([liftSeries],
                                    user.liftList[e.key].title, 'TM'),
                              )),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                          child: Text('1 RM'), value: '1RM'),
                                      const PopupMenuItem<String>(
                                          child: Text('TM'), value: 'TM'),
                                      const PopupMenuItem<String>(
                                        child: Text('Weight'),
                                        value: 'Weight',
                                      ),
                                    ],
                                onSelected: (String value) => {
                                      Provider.of<StatsSelectedLift>(context,
                                              listen: false)
                                          .changeStatsType(value),
                                      setState(() {
                                        _selectedStat = value;
                                      }),
                                    }),
                          ),
                          Positioned(
                            top: 220,
                            right: 15,
                            child: IconButton(
                                icon: Icon(Icons.fullscreen),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => StatsFullScreen(
                                            user.liftList[e.key].id, 'TM')))),
                          ),
                        ],
                      ))));
            }
            output = ListView(children: liftCharts);
          } else
          output =
              Center(child: Column(children: [...dataFetchingIndicator()]));
          return output;
        });
  }
}

/// Queries the data for all lifts and returns it as a Map[ID - List[Lift]]
Future<Map<int, List<DbLift>>> dataFetcher(
    UserProfile profile, String statsType) async {
  LiftHelper helper = LiftHelper();
  var stats = <int, List<DbLift>>{};
  for (var i = 0; i < profile.liftList.length; i++) {
    int id = profile.liftList[i].id;
    List<DbLift> tmp = await getStatsTypeData(helper, statsType, id);
    stats[id] = tmp;
  }
  return stats;
}

getStatsTypeData(LiftHelper helper, String type, int id) async {
  if (type == '1RM') return await helper.getHighestLiftsPerDay(id);
  if (type == 'Weight') return await helper.getHighestWeightPerDay(id);
}

/// Queries the data for all lifts and returns it as a Map[ID - List[Lift]]
Future<Map<int, List<DbTrainingMax>>> tmDataFetcher() async {
  var stats = <int, List<DbTrainingMax>>{};
  for (var i = 0; i < GLOBAL_ALL_LIFTS.length; i++) {
    int id = GLOBAL_ALL_LIFTS[i].id;
    List<DbTrainingMax> tmp = await TrainingMaxHelper().getAll(id);
    stats[id] = tmp;
  }
  return stats;
}
