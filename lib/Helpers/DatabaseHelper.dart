
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/NotificationModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);
    return await openDatabase(fullPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notifications(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
    )
  ''');
  }


  Future<void> insertNotification(NotificationModel notification) async {
    final db = await instance.database;

    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,  // This will replace existing notifications if needed
    );
  }


  Future<List<NotificationModel>> getNotifications() async {
    final db = await instance.database;
    final result = await db.query('notifications');
    return result.map((map) => NotificationModel.fromMap(map)).toList();
  }

  // In DatabaseHelper.dart
  Future<void> deleteNotification(int id) async {
    final db = await instance.database;

    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}