import 'dart:async';
import 'package:sqflite/sqflite.dart';

// Base Lift class

class Lift {
  // Name of the lift (OHP: 0, DL: 1, Squat: 2, Bench: 3) - Can be stored as const somewhere
  int id, date, weight, reps, calculated1RM;

  Lift(this.id, this.date, this.weight, this.reps): 
   calculated1RM =  ((weight + reps *0.0333) + reps).round();

  Lift.fromMap(Map<dynamic, dynamic> map):
    id = map['id'],
    date = map['date'],
    weight = map['weight'],
    reps = map['reps'],
    calculated1RM= map['calculated1RM']
    {
    print('Lift.froMap(): ($id, $weight, $calculated1RM)');
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

  // Probably doesn't need to be a function - we'll see
  int convertDateToInt(DateTime date){
    return date.millisecondsSinceEpoch;
  }
}

class LiftHelper{
    /// Finds the lift with the highest 1RM for the corresponding lift type.
  Future<Lift> getHighest1RM(int id, Database db) async {
    List<Map> maps = await db.query('Lift',
        where: 'id = ?',
        whereArgs: [id]);
    return Lift.fromMap(maps.first);
  }
}


 