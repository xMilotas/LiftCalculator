// User can input custom exercise (name) with sets,reps & (optional weight)
// Needs to be mapped to a core exercise
import 'package:liftcalculator/util/globals.dart';
import 'package:sqflite/sqflite.dart';

class AssistanceExercise {
  final String exerciseName;
  final int relatedCoreExerciseId;
  int sets;
  int reps;
  double weight;

  AssistanceExercise(
      this.exerciseName, this.relatedCoreExerciseId, this.sets, this.reps,
      {this.weight = 0});

  AssistanceExercise.fromMap(Map<dynamic, dynamic> map)
      : exerciseName = map['exerciseName'],
        relatedCoreExerciseId = map['relatedCoreExerciseId'],
        sets = map['sets'],
        reps = map['reps'],
        weight = map['weight'];

  /// Transform a Lift into the DB structure:
  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'relatedCoreExerciseId': relatedCoreExerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight
    };
  }

  @override
  String toString() {
    if (weight == 0)
      return '$exerciseName: $sets x $reps';
    else
      return '$exerciseName: $sets x $reps @ $weight kg';
  }
}

class AssistanceLiftHelper {
  /// Gets all assistance exercises for a core lift
  Future<List<AssistanceExercise>> getAllExercises(
      int relatedCoreExerciseId) async {
    List<Map> assistanceExercises = await GLOBAL_DB!.query('assistance',
        where: 'relatedCoreExerciseId = ?', whereArgs: [relatedCoreExerciseId]);
    if (assistanceExercises.length != 0) {
      return List.generate(assistanceExercises.length,
          (i) => AssistanceExercise.fromMap(assistanceExercises[i]));
    } else
      return [];
  }

  /// Deletes all assistance exercises for a core lift
  deleteAllExercisesForCoreLift(int relatedCoreExerciseId) async {
    await GLOBAL_DB!
        .delete('assistance', where: 'relatedCoreExerciseId = ?', whereArgs: [
      relatedCoreExerciseId,
    ]);
  }

  writeToDB(AssistanceExercise exercise) async {
    print("[EXERCISE]: Saving to DB $exercise");
    await GLOBAL_DB!.insert('assistance', exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
