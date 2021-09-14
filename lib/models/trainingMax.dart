import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcalculator/util/preferences.dart';
import 'dart:async';

class TrainingMax {
  final int id;
  final String title;
  final String abbreviation;
  IconData? icon; //TODO: Add some nice icons here
  late bool isExpanded;
  late int weight;
  late int reps;
  late int current1RM;
  int trainingMax;
  int new1RM;

  TrainingMax._create(this.id, this.title, this.abbreviation, {this.icon})
      : isExpanded = false,
        new1RM = 0,
        trainingMax = 0;

  static Future<TrainingMax> create(int id, String title, String abbreviation,
      {IconData? icon}) async {
    var component = TrainingMax._create(id, title, abbreviation, icon: icon);
    await component._loadData();
    return component;
  }

  calculate1RM() async {
    this.new1RM = ((this.weight * this.reps * 0.0333) + this.weight).round();
    print('Current 1RM ${this.current1RM}');
    print('Calculated 1RM for current inputs  ${this.new1RM}');
    return this.new1RM;
  }

  // Store the current weight/reps in shared pref as key: liftName_weight (OHP_weight)
  storeValue(String type, int value) async {
    // Store in class var
    if (type == 'weight') this.weight = value;
    if (type == 'reps') this.reps = value;
    this.calculate1RM();
  }

  _loadData() async {
    Preferences pref = await Preferences.create();
    this.weight = await pref.getSharedPrefValueInt('${this.abbreviation}_weight');
    this.reps = await pref.getSharedPrefValueInt('${this.abbreviation}_reps');
    this.current1RM =
        await pref.getSharedPrefValueInt('${this.abbreviation}_1RM');
  }

  saveData() async {
    Preferences pref = await Preferences.create();
    await pref.setSharedPrefValueInt('${this.abbreviation}_weight', this.weight);
    await pref.setSharedPrefValueInt('${this.abbreviation}_reps', this.reps);
    await pref.setSharedPrefValueInt(
        '${this.abbreviation}_1RM', await calculate1RM());
    this.current1RM = this.new1RM;
  }

  @override
  String toString() {
    return '$title, $reps, $weight';
  }
}
