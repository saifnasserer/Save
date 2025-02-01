import 'package:path/path.dart';
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
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add upgrade logic here when needed
    // For example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE $kMemoTable ADD COLUMN new_column TEXT');
    // }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
