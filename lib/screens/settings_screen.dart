import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/util/preferences.dart';
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
            value: profile.cycleWeek.toDouble(),
            onChanged: (value) =>
                storeSetting(context, 'Current_Week', value.toInt()),
          ),
          buildCycleTemplateSetting(context, profile),
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

storeSetting(context, String referenceVar, dynamic value) async {
  Provider.of<UserProfile>(context, listen: false)
      .storeUserSetting(referenceVar, value);
}
