import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBHelper {
  static Database? _database;
  static const String tableName = 'history';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT UNIQUE)",
        );
      },
    );
  }

  static Future<void> insertHistory(String url) async {
    final db = await database;
    await db.insert(
      tableName,
      {'url': url},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore duplicates
    );
  }

  static Future<List<String>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName, orderBy: "id DESC");
    return List.generate(maps.length, (i) => maps[i]['url'] as String);
  }

  static Future<void> clearHistory() async {
    final db = await database;
    await db.delete(tableName);
  }
}