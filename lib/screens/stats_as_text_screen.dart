// Lists the top performing lifts as text form to make it easier to see them in 1 place
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/databaseLoadIndicator.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/models/selectedLift.dart';
import 'package:provider/provider.dart';

class StatsTextScreen extends StatefulWidget {
  @override
  _StatsTextScreenState createState() => _StatsTextScreenState();
}

class _StatsTextScreenState extends State<StatsTextScreen> {
  String _selectedStat = '1RM';
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar: buildAppBar(context, setState, "Stats"),
        body: buildCharts(profile));
  }

  buildCharts(UserProfile user) {
    return FutureBuilder(
        future: dataFetcher(user, _selectedStat),
        builder: (BuildContext context,
            AsyncSnapshot<Map<int, List<DbLift>>> snapshot) {
          Widget output;
          if (snapshot.hasData) {
            Map<int, List<DbLift>> data = snapshot.data!;
            var liftResults = <Widget>[];
            for (MapEntry<int, List<DbLift>> e in data.entries) {
              liftResults.add(Padding(
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
                                  child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            (_selectedStat == '1RM') ? user.liftList[e.key].title + ' (1RM)' : user.liftList[e.key].title + ' (Weight)', 
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        ...e.value
                                          .map((e) => Row(
                                                children: [
                                                  Text(
                                                      '${e.calculated1RM} via '),
                                                  Text('${e.weightRep} on '),
                                                  Text(DateFormat('yyyy-MM-dd').format(e.date))
                                                  
                                                ],
                                              ))
                                          .toList()
                                        ]))),
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
                        ],
                      ))));
            }
            output = ListView(children: liftResults);
          } else
            output =
                Center(child: Column(children: [...dataFetchingIndicator()]));
          return output;
        });
  }

  /// Queries the data for all lifts and returns it as a Map[ID - List[Lift]]
  Future<Map<int, List<DbLift>>> dataFetcher(
      UserProfile profile, String statsType) async {
    LiftHelper helper = LiftHelper();
    var stats = <int, List<DbLift>>{};
    for (var i = 0; i < profile.liftList.length; i++) {
      int id = profile.liftList[i].id;
      List<DbLift> tmp = await getStatsTypeData(helper, statsType, id);
      if(statsType == '1RM') tmp.sort((a,b) => b.calculated1RM.compareTo(a.calculated1RM));
      else tmp.sort((a,b) => b.weightRep.weight.compareTo(a.weightRep.weight));
      stats[id] = tmp.take(13).toList();
    }
    return stats;
  }

  getStatsTypeData(LiftHelper helper, String type, int id) async {
    if (type == '1RM') return await helper.getHighestLiftsPerDay(id);
    if (type == 'Weight') return await helper.getHighestWeightPerDay(id);
  }
}
