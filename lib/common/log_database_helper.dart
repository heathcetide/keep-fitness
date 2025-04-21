import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LogDatabaseHelper {
  static final LogDatabaseHelper _instance = LogDatabaseHelper._internal();

  factory LogDatabaseHelper() => _instance;
  static Database? _database;

  LogDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'logs.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(''' 
        CREATE TABLE logs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          level TEXT,
          message TEXT,
          timestamp TEXT,
          error TEXT,
          stackTrace TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE logs ADD COLUMN error TEXT');
          await db.execute('ALTER TABLE logs ADD COLUMN stackTrace TEXT');
        }
      },
    );
  }

  Future<void> insertLog(
    String level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) async {
    final db = await database;
    await db.insert('logs', {
      'level': level,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'error': error?.toString() ?? '', // Handle null errors
      'stackTrace': stackTrace?.toString() ?? '', // Handle null stack traces
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getLogs(String level) async {
    final db = await database;
    if (level == 'ALL') {
      return await db.query('logs');
    } else {
      return await db.query('logs', where: 'level = ?', whereArgs: [level]);
    }
  }

  Future<void> clearLogs() async {
    final db = await database;
    await db.delete('logs');
  }
}
