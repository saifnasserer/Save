import 'package:path/path.dart';
import 'package:save/Screens/notifs.dart';
import 'package:save/models/memo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'database_constants.dart';

class DatabaseService {
  // Singleton pattern to ensure only one instance of DatabaseService
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Database instance
  Database? _database;

  // Get database instance, create if not exists
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the directory path for both Android and iOS
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, kDatabaseName);

    // Open/create the database at a given path
    return await openDatabase(
      path,
      version: kDatabaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables when database is first created
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(kCreateMemoTable);
    await db.execute(kCreateNotificationTable);
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(kCreateNotificationTable);
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Create: Insert a new memo
  Future<int> insertMemo(Memo memo) async {
    final db = await database;
    return await db.insert(
      kMemoTable,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read: Get a single memo by id
  Future<Memo?> getMemo(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      kMemoTable,
      where: '$kColumnId = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Memo.fromMap(maps.first);
  }

  // Read: Get all memos
  Future<List<Memo>> getAllMemos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      kMemoTable,
      orderBy: '$kColumnModifiedAt DESC',
    );

    return List.generate(maps.length, (i) => Memo.fromMap(maps[i]));
  }

  // Update: Modify an existing memo
  Future<int> updateMemo(Memo memo) async {
    final db = await database;
    return await db.update(
      kMemoTable,
      memo.toMap(),
      where: '$kColumnId = ?',
      whereArgs: [memo.id],
    );
  }

  // Delete: Remove a memo
  Future<int> deleteMemo(int id) async {
    final db = await database;
    return await db.delete(
      kMemoTable,
      where: '$kColumnId = ?',
      whereArgs: [id],
    );
  }

  // Search: Find memos by title or content
  Future<List<Memo>> searchMemos(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      kMemoTable,
      where: '$kColumnTitle LIKE ? OR $kColumnContent LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '$kColumnModifiedAt DESC',
    );

    return List.generate(maps.length, (i) => Memo.fromMap(maps[i]));
  }

  // Notification Methods

  // Create notification
  Future<int> createNotification(MemoNotification notification) async {
    final db = await database;
    return await db.insert(
      kNotificationTable,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notifications
  Future<List<MemoNotification>> getAllNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> notificationMaps = await db.rawQuery('''
      SELECT n.*, m.*
      FROM $kNotificationTable n
      JOIN $kMemoTable m ON n.$kColumnMemoId = m.$kColumnId
      WHERE n.$kColumnIsCompleted = 0
      ORDER BY n.$kColumnNotificationTime ASC
    ''');

    return Future.wait(
      notificationMaps.map((map) async {
        final memoMap = {
          kColumnId: map[kColumnMemoId],
          kColumnTitle: map[kColumnTitle],
          kColumnContent: map[kColumnContent],
          kColumnCreatedAt: map[kColumnCreatedAt],
          kColumnModifiedAt: map[kColumnModifiedAt],
          kColumnIsPinned: map[kColumnIsPinned],
          kColumnCategory: map[kColumnCategory],
        };

        return MemoNotification(
          id: map[kColumnId] as int,
          memo: Memo.fromMap(memoMap),
          notificationTime:
              DateTime.parse(map[kColumnNotificationTime] as String),
          isCompleted: (map[kColumnIsCompleted] as int) == 1,
        );
      }),
    );
  }

  // Mark notification as completed
  Future<int> completeNotification(int id) async {
    final db = await database;
    return await db.update(
      kNotificationTable,
      {kColumnIsCompleted: 1},
      where: '$kColumnId = ?',
      whereArgs: [id],
    );
  }

  // Delete notification
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete(
      kNotificationTable,
      where: '$kColumnId = ?',
      whereArgs: [id],
    );
  }

  // Get notifications for a specific memo
  Future<List<MemoNotification>> getNotificationsForMemo(int memoId) async {
    final db = await database;
    final List<Map<String, dynamic>> notificationMaps = await db.rawQuery('''
      SELECT n.*, m.*
      FROM $kNotificationTable n
      JOIN $kMemoTable m ON n.$kColumnMemoId = m.$kColumnId
      WHERE n.$kColumnMemoId = ? AND n.$kColumnIsCompleted = 0
      ORDER BY n.$kColumnNotificationTime ASC
    ''', [memoId]);

    return Future.wait(
      notificationMaps.map((map) async {
        final memoMap = {
          kColumnId: map[kColumnMemoId],
          kColumnTitle: map[kColumnTitle],
          kColumnContent: map[kColumnContent],
          kColumnCreatedAt: map[kColumnCreatedAt],
          kColumnModifiedAt: map[kColumnModifiedAt],
          kColumnIsPinned: map[kColumnIsPinned],
          kColumnCategory: map[kColumnCategory],
        };

        return MemoNotification(
          id: map[kColumnId] as int,
          memo: Memo.fromMap(memoMap),
          notificationTime:
              DateTime.parse(map[kColumnNotificationTime] as String),
          isCompleted: (map[kColumnIsCompleted] as int) == 1,
        );
      }),
    );
  }
}
