import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'package:liftcalculator/main.dart';
import 'package:liftcalculator/util/preferences.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
 @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State < SettingsScreen > {

@override
  Widget build(BuildContext context){
    //int trainingMaxPercentage  = Provider.of<User>(context).trainingMaxPercentage;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Define your settings here'),
        ),
        body: 
          ListView(children: [
                  SpinBox(
                    decoration: InputDecoration(labelText: 'Current Training Max Percentage', suffixText: '%',),
                    step: 5,
                    min: 60,
                    max: 95,
                    value: 70, //trainingMaxPercentage.toDouble()
                    onChanged: (value) => storeSetting('Training_Max_Percentage', value),
                  )
                ],
                ),
        );
  }
}

storeSetting(String type, double value) async {
  Preferences pref = await Preferences.create();
  await pref.setSharedPrefValue(type, value.round());
}
