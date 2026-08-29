import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DayFlowDatabase {
  DayFlowDatabase._();
  static final DayFlowDatabase instance = DayFlowDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final root = await getDatabasesPath();
    _database = await openDatabase(
      p.join(root, 'dayflow.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            priority TEXT NOT NULL,
            planned_start TEXT NOT NULL,
            planned_minutes INTEGER NOT NULL,
            difficulty INTEGER NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0,
            actual_start TEXT,
            actual_end TEXT,
            predicted_minutes REAL,
            quality_score INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE sessions (
            id TEXT PRIMARY KEY,
            task_id TEXT NOT NULL,
            started_at TEXT NOT NULL,
            ended_at TEXT,
            paused_seconds INTEGER NOT NULL DEFAULT 0,
            distraction_seconds INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
