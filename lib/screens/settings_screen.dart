import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/util/preferences.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) =>
                    storeSetting('Training_Max_Percentage', value),
              );
            },
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
