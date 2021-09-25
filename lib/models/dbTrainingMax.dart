import 'dart:async';
import 'package:liftcalculator/util/globals.dart';
import 'package:sqflite/sqflite.dart';

class DbTrainingMax {
  int id;
  DateTime date;
  double weight;

  DbTrainingMax(this.id, this.date, this.weight);

  DbTrainingMax.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']),
        weight = map['weight'];

  /// Transform a TM into the DB structure
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'weight': weight,
    };
  }

  writeToDB() async {
    print("[TrainingMax]: Saving to DB ${this.toMap()}");
    await GLOBAL_DB?.insert('training_max', this.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DbTrainingMax>> getAll(int id) async {
    List<Map> tms = await GLOBAL_DB!
        .query('training_max', where: 'id = ?', whereArgs: [id]);
    return List.generate(tms.length, (i) => DbTrainingMax.fromMap(tms[i]));
  }

  /// Gets the current saved training max for this lift type
  Future<List<DbTrainingMax>> getCurrent(int id) async {
    List<Map> tms = await GLOBAL_DB!
        .query('training_max', where: 'id = ?', whereArgs: [id]);
    return List.generate(tms.length, (i) => DbTrainingMax.fromMap(tms[i]));
  }

  @override
  String toString() {
    return 'TrainingMax{ id: $id, date: $date, \n TrainingMax: $weight }';
  }
}