import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reminders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dateTime TEXT NOT NULL,
        userId TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE reminders ADD COLUMN userId TEXT NOT NULL DEFAULT "admin"',
      );
    }
  }

  Future<int> createReminder(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('reminders', row);
  }

  Future<List<Map<String, dynamic>>> getRemindersByUserId(String userId) async {
    final db = await instance.database;
    return await db.query(
      'reminders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateTime DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllReminders() async {
    final db = await instance.database;
    return await db.query('reminders', orderBy: 'dateTime DESC');
  }

  Future<Map<String, dynamic>?> getReminder(int id) async {
    final db = await instance.database;
    final maps = await db.query('reminders', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateReminder(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await instance.database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
