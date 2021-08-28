
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  late Database db;

  Future create(String dbType) async {
   db = await openDatabase(
      join(await getDatabasesPath(), 'training_data.db'),
      onCreate: this._create,
      version: 1,
    );
  }

 Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE lift (
              id INTEGER PRIMARY KEY, 
              date INTEGER NOT NULL,
              weight TEXT NOT NULL,
              reps TEXT NOT NULL,
            )""");

    await db.execute("""
            CREATE TABLE training (
              id INTEGER PRIMARY KEY,
              lift TEXT NOT NULL
            )""");
  }
}