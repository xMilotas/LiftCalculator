import 'dart:async';
import 'package:liftcalculator/util/globals.dart';
import 'package:liftcalculator/util/weight_reps.dart';
import 'package:sqflite/sqflite.dart';

// Base Lift class

class DbLift {
  int id;
  DateTime date;
  int calculated1RM;
  WeightReps weightRep;

  DbLift(this.id, this.date, this.weightRep)
      : calculated1RM =
            ((weightRep.weight * weightRep.reps * 0.0333) + weightRep.weight)
                .round();

  DbLift.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']),
        weightRep = WeightReps(map['weight'], map['reps']),
        calculated1RM = map['calculated1RM'];

  /// Transform a Lift into the DB structure:
  /// Transposes weight rep into separate attributes and transforms date into int
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'weight': weightRep.weight,
      'reps': weightRep.reps,
      'calculated1RM': calculated1RM,
    };
  }

  @override
  String toString() {
    return 'Lift{ id: $id, date: $date, \n calculated1RM: $calculated1RM \n $weightRep }';
  }
}

class LiftHelper {
  /// Finds the top 3 lifts with the highest 1RM for the corresponding lift type.
  Future<List<DbLift>> getHighest1RMs(int id) async {
    List<Map> lifts = await GLOBAL_DB!.query('Lift',
        where: 'id = ?',
        whereArgs: [id],
        orderBy: 'calculated1RM DESC',
        limit: 3);
    return List.generate(lifts.length, (i) => DbLift.fromMap(lifts[i]));
  }

  /// Gets all performed lifts for this lift type
  Future<List<DbLift>> getAllLifts(int id) async {
    List<Map> lifts =
        await GLOBAL_DB!.query('Lift', where: 'id = ?', whereArgs: [id]);
    return List.generate(lifts.length, (i) => DbLift.fromMap(lifts[i]));
  }

  /// Gets only the biggest lift per day for a lift type
  getHighestLiftsPerDay(int id) async {
    List<Map> lifts = await GLOBAL_DB!.rawQuery(
        'SELECT a.calculated1RM, a.date, a.id, a.weight, a.reps FROM lift a INNER JOIN(SELECT MAX(calculated1RM) as calculated1RM, date, id FROM lift WHERE ID = $id GROUP BY id, date) b ON a.id = b.id and a.calculated1RM = b.calculated1RM');
    return List.generate(lifts.length, (i) => DbLift.fromMap(lifts[i]));
  }

  /// Gets only the biggest lift per day for a lift type
  getHighestWeightPerDay(int id) async {
    List<Map> lifts = await GLOBAL_DB!.rawQuery(
        'SELECT a.calculated1RM, a.date, a.id, a.weight, a.reps FROM lift a INNER JOIN(SELECT MAX(weight) as weight, date, id FROM lift WHERE ID = $id GROUP BY id, date) b ON a.id = b.id and a.weight = b.weight');
    return List.generate(lifts.length, (i) => DbLift.fromMap(lifts[i]));
  }

  /// Gets 1RM maxes for all lifts
  Future<Map<int, int>> get1RMMaxes() async {
    List<Map> lifts = await GLOBAL_DB!.rawQuery(
        'SELECT MAX(calculated1RM) as calculated1RM, id FROM lift GROUP BY id');
    var result = <int, int>{};
    lifts.forEach((e) {
      result[e['id']] = e['calculated1RM'];
    });
    return result;
  }

  /// Update specific lift
  updateLift(DbLift originalLift, String newReps, String newWeight) async {
    DbLift newLift = DbLift(originalLift.id, originalLift.date,
        WeightReps(double.parse(newWeight), int.parse(newReps)));
    // We don't have unique identifiers for our rows, thus we need to pass the entire original element
    await GLOBAL_DB!.update('Lift', newLift.toMap(),
        where: 'id = ? AND date = ? AND weight = ? AND reps = ?',
        whereArgs: [
          originalLift.id,
          originalLift.date.millisecondsSinceEpoch,
          originalLift.weightRep.weight,
          originalLift.weightRep.reps
        ]);
  }

  /// Gets lifts per day
  Future<List<DbLift>> getLiftsPerDay(DateTime date) async {
    print(date);
    List<Map> lifts = await GLOBAL_DB!.query('Lift',
        where: 'date = ?', whereArgs: [date.millisecondsSinceEpoch]);
    print(lifts);
    return List.generate(lifts.length, (i) => DbLift.fromMap(lifts[i]));
  }
}
