import 'dart:async';
import 'package:sqflite/sqflite.dart';

// Base Lift class

class Lift {
  // Name of the lift (OHP: 0, DL: 1, Squat: 2, Bench: 3) - Can be stored as const somewhere
  int id, date, reps, calculated1RM;
  double weight;

  Lift(this.id, this.date, this.weight, this.reps)
      : calculated1RM = ((weight + reps * 0.0333) + reps).round();

  Lift.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        date = map['date'],
        weight = map['weight'],
        reps = map['reps'],
        calculated1RM = map['calculated1RM'] {
    print('Lift.fromMap(): ($id, $weight, $calculated1RM)');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'weight': weight,
      'reps': reps,
      'calculated1RM': calculated1RM,
    };
  }

  @override
  String toString() {
    return 'Lift{ id: $id, date: $date, \n weight: $weight,reps: $reps ,calculated1RM: $calculated1RM }';
  }
}

class LiftHelper {
  Database db;

  LiftHelper(this.db);

  /// Finds the top 3 lifts with the highest 1RM for the corresponding lift type.
  Future<List<Lift>> getHighest1RMs(int id) async {
    List<Map> lifts = await db.query('Lift',
        where: 'id = ?', whereArgs: [id], orderBy: 'calculated1RM', limit: 3);
    return List.generate(lifts.length, (i) => Lift.fromMap(lifts[i]));
  }
}
