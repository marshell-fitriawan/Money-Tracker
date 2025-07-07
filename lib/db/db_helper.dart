import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trancs.dart';
import '../models/goals.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            date TEXT,
            jenis INTEGER,
            desc TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE goals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            desc TEXT,
            target REAL
          )
        ''');
      },
    );
  }

  // TRANSACTIONS CRUD
  Future<int> insertTransaction(Trancs tranc) async {
    final db = await database;
    return await db.insert('transactions', tranc.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Trancs>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Trancs.fromMap(maps[i]));
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTransaction(Trancs tranc) async {
    final db = await database;
    return await db.update(
      'transactions',
      tranc.toMap(),
      where: 'id = ?',
      whereArgs: [tranc.id],
    );
  }

  // GOALS CRUD
  Future<int> insertGoal(Goal goal) async {
    final db = await database;
    return await db.insert('goals', goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Goal>> getGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('goals', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
  }

  Future<int> deleteGoal(int id) async {
    final db = await database;
    return await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await database;
    return await db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }
}
