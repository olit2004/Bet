import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bet_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users Table (Auth Caching)
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT,
        role TEXT,
        firstName TEXT,
        lastName TEXT,
        token TEXT
      )
    ''');

    // Create Proposals Table
    await db.execute('''
      CREATE TABLE proposals (
        id TEXT PRIMARY KEY,
        propertyId TEXT,
        buyerId TEXT,
        status TEXT,
        proposalFileUrl TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // Create Bids Table
    await db.execute('''
      CREATE TABLE bids (
        id TEXT PRIMARY KEY,
        propertyId TEXT,
        buyerId TEXT,
        amount REAL,
        status TEXT,
        bankStatementUrl TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  // Clear Database (e.g. on logout)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    await db.delete('proposals');
    await db.delete('bids');
  }
}
