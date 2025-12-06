import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/health_record.dart';

class HealthRecordRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_records.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute(
            'ALTER TABLE health_records ADD COLUMN steps INTEGER DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE health_records ADD COLUMN calories REAL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE health_records ADD COLUMN waterIntake INTEGER DEFAULT 0',
          );
        }
      },
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories REAL NOT NULL,
        waterIntake INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> save(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getAll() async {
    final db = await database;

    final result = await db.query('health_records', orderBy: 'id DESC');

    return result.map((e) => HealthRecord.fromMap(e)).toList();
  }

  Future<void> delete(HealthRecord record) async {
    final db = await database;
    await db.delete('health_records', where: 'id = ?', whereArgs: [record.id]);
  }

  Future<void> update(HealthRecord record) async {
    final db = await database; 
    await db.update(
      'health_records', 
      record
          .toMap(), 
      where: 'id = ?',
      whereArgs: [record.id], 
    );
  }
}
