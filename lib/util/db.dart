import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  late Database db;

  static Future<DatabaseClient> create() async {
    WidgetsFlutterBinding.ensureInitialized();
    var component = DatabaseClient();
    await component._setup();
    return component;
  }

  _setup() async {
    print("[DATABASE]: Starting...");
    this.db = await openDatabase(
      join(await getDatabasesPath(), 'training_data.db'),
      onCreate: this._create,
      version: 1,
    );
  }

  Future _create(Database db, int version) async {
    print("[DATABASE]: Creating tables...");
    await db.execute("""
            CREATE TABLE lift (
              id INTEGER NOT NULL,
              date INTEGER NOT NULL,
              weight DOUBLE NOT NULL,
              reps INTEGER NOT NULL,
              calculated1RM INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE assistance (
              exerciseName TEXT NOT NULL,
              relatedCoreExerciseId INTEGER NOT NULL,
              sets INTEGER NOT NULL,
              reps INTEGER NOT NULL,
              weight DOUBLE NOT NULL
            )""");

    await db.execute("""
        CREATE TABLE training_max (
          id INTEGER NOT NULL,
          date INTEGER NOT NULL,
          weight DOUBLE NOT NULL,
          PRIMARY KEY (id, date)
        )""");
  }
}
