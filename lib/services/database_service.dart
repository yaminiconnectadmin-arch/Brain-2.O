import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../core/models/brain_item.dart';
import '../core/models/daily_review.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'second_brain.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Table for Brain Items (Tasks, Meetings, Ideas, Decisions)
        await db.execute('''
          CREATE TABLE brain_items (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            type TEXT NOT NULL,
            priority TEXT NOT NULL,
            category TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            scheduledAt TEXT,
            deadline TEXT,
            location TEXT,
            people TEXT,
            tags TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            audioPath TEXT
          )
        ''');

        // Table for Daily Reviews & Midnight Routine
        await db.execute('''
          CREATE TABLE daily_reviews (
            date TEXT PRIMARY KEY,
            mission TEXT NOT NULL,
            completedTasks INTEGER NOT NULL,
            totalTasks INTEGER NOT NULL,
            meetingsAttended INTEGER NOT NULL,
            hoursWorked REAL NOT NULL,
            productivityScore INTEGER NOT NULL,
            topDiscussedTopic TEXT NOT NULL,
            tomorrowSuggestions TEXT,
            wins TEXT
          )
        ''');
      },
    );
  }

  // --- CRUD for Brain Items ---

  Future<int> insertBrainItem(BrainItem item) async {
    final db = await database;
    return await db.insert(
      'brain_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BrainItem>> getAllBrainItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'brain_items',
      orderBy: 'CASE WHEN scheduledAt IS NULL THEN 1 ELSE 0 END, scheduledAt ASC, createdAt ASC',
    );
    return maps.map((map) => BrainItem.fromMap(map)).toList();
  }

  Future<List<BrainItem>> getBrainItemsByCategory(TimelineCategory category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'brain_items',
      where: 'category = ?',
      whereArgs: [category.name],
      orderBy: 'CASE WHEN scheduledAt IS NULL THEN 1 ELSE 0 END, scheduledAt ASC, createdAt ASC',
    );
    return maps.map((map) => BrainItem.fromMap(map)).toList();
  }

  Future<BrainItem?> checkTimeConflict(DateTime targetTime) async {
    final items = await getAllBrainItems();
    for (final item in items) {
      if (item.isCompleted) continue;
      if (item.scheduledAt != null) {
        final diffMinutes = item.scheduledAt!.difference(targetTime).inMinutes.abs();
        if (diffMinutes < 30) {
          return item;
        }
      }
    }
    return null;
  }

  Future<int> updateBrainItem(BrainItem item) async {
    final db = await database;
    return await db.update(
      'brain_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteBrainItem(String id) async {
    final db = await database;
    return await db.delete(
      'brain_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD for Daily Reviews ---

  Future<int> insertOrUpdateDailyReview(DailyReview review) async {
    final db = await database;
    return await db.insert(
      'daily_reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DailyReview?> getDailyReview(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_reviews',
      where: 'date = ?',
      whereArgs: [date],
    );
    if (maps.isEmpty) return null;
    return DailyReview.fromMap(maps.first);
  }
}
