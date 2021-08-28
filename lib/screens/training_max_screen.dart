import 'package:flutter/material.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/screens/settings_screen.dart';

import 'dart:async';
import 'package:path/path.dart';

import 'package:liftcalculator/models/trainingMax.dart';
import 'package:flutter/services.dart';
import 'package:liftcalculator/main.dart';
import 'package:provider/provider.dart';

class TrainingMaxConfigScreen extends StatefulWidget {
 @override
  _TrainingMaxConfigScreenState createState() => _TrainingMaxConfigScreenState();
}

class _TrainingMaxConfigScreenState extends State < TrainingMaxConfigScreen > {

@override
  Widget build(BuildContext context){
    List<TrainingMax> liftList = Provider.of<User>(context).liftList;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Lift Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) {
                    return SettingsScreen();
                  }),
                );
              }
            ),
          ] ,
        ),
        body: 
            SingleChildScrollView(
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ExpansionPanelList.radio(
                          expansionCallback: (index, isExpanded) {
                            final tile = liftList[index];
                            setState(() => tile.isExpanded = isExpanded);
                          },
                          children: liftList
                              .map((tile) => ExpansionPanelRadio(
                                    value: tile.title,
                                    canTapOnHeader: true,
                                    headerBuilder: (context, isExpanded) => buildHeader(tile),
                                    body: Column(
                                      children: [
                                        TextFormField(
                                          decoration: 
                                            InputDecoration(
                                                        filled: true,
                                                        labelText: 'Weight in kg',
                                                      ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          initialValue: tile.weight.toString(),
                                          onChanged: (String? value) {
                                                      if(value != ''){
                                                        tile.storeValue('weight', int.parse(value!));
                                                      }
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                                      filled: true,
                                                      labelText: 'Number of reps',
                                                      ),
                                          keyboardType: TextInputType.number,
                                          initialValue: tile.reps.toString(),
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          onChanged: (String? value) {
                                                      if(value != ''){
                                                        tile.storeValue('reps', int.parse(value!));
                                                      }
                                          }
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => onPressed(liftList, context), 
                                      child: Text('Save'),
                                      ),
                                  ],)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                ),
        );
  }

  Widget buildHeader(TrainingMax tile) => ListTile(
        leading: tile.icon != null ? Icon(tile.icon) : null,
        title: Text(tile.title),
        subtitle:
        Column(children: [
                  Text('Your saved 1RM is: '+tile.current1RM.toString() + 'kg', 
              style: TextStyle(fontSize: 10)
              ,
        ),
                Text('Your current 1RM is: '+tile.new1RM.toString() + 'kg', 
              style: TextStyle(fontSize: 10)
              ,
        ),
        ],)
      );

  onPressed(List<TrainingMax> liftList, context){
    liftList.forEach((tile) {
      tile.saveData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueGrey,
          content: const Text('Training maxes saved'),
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


// This is fine for now