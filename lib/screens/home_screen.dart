import 'package:flutter/material.dart';
import 'package:liftcalculator/models/appBar.dart';
import 'package:liftcalculator/models/drawer.dart';
import 'package:liftcalculator/models/profile.dart';

import 'package:liftcalculator/main.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _TrainingMaxConfigScreenState createState() =>
      _TrainingMaxConfigScreenState();
}

class _TrainingMaxConfigScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);
     if (profile.isLoaded == false) {
      return Splash();
    } else
      return Scaffold(
        appBar: buildAppBar(context),
        body: Scaffold(body: Container(child: Text('Welcome'),),),
        drawer: buildDrawer(context),
      );
  }
}

