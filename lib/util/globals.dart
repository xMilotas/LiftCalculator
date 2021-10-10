// ignore_for_file: non_constant_identifier_names

import 'package:liftcalculator/models/lift.dart';
import 'package:sqflite/sqflite.dart';

final List<Lift> GLOBAL_ALL_LIFTS = [
  Lift(0, "Overhead Press", "OHP"),
  Lift(1, "Deadlift", "DL"),
  Lift(2, "Bench Press", "BP"),
  Lift(3, "Squat", "SQ")
];

Database? GLOBAL_DB;