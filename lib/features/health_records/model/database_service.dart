import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HealthRecord {
  final int? id;
  final String date;
  final int steps;
  final int calories;
  final double waterIntake;

  HealthRecord({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.waterIntake,
  });

  // Convert a HealthRecord into a Map object (to save to SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'date': date,
      'steps': steps,
      'calories': calories,
      'water_intake': waterIntake,
    };
  }

  // Convert a Map object to a HealthRecord (for fetching records from the database)
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      date: map['date'],
      steps: map['steps'],
      calories: map['calories'],
      waterIntake: map['water_intake'],
    );
  }
}

class DatabaseService {
  static Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'healthmate.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE health_records(id INTEGER PRIMARY KEY, date TEXT, steps INTEGER, calories INTEGER, water_intake REAL)',
        );
      },
      version: 1,
    );
    print("datanase initialized sucessfully");
    return _database!;
  }

  // Fetch all health records
  Future<List<HealthRecord>> getHealthRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('health_records');
    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  // Insert a health record
  Future<void> insertHealthRecord(HealthRecord record) async {
    final db = await database;
    await db.insert(
      'health_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Map<String, dynamic>> maps = await db.query('health_records');
    print("Current records in the database: ${maps.length}");
  }

  // Update an existing health record
  Future<void> updateHealthRecord(HealthRecord record) async {
    final db = await database;
    await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  // Delete a health record
  Future<void> deleteHealthRecord(int id) async {
    final db = await database;
    await db.delete('health_records', where: 'id = ?', whereArgs: [id]);
  }
}
