import 'package:flutter/material.dart';
import '../model/health_record.dart';
import '../repository/health_record_repository.dart';

class HealthRecordViewModel extends ChangeNotifier {
  final HealthRecordRepository _repo = HealthRecordRepository();

  List<HealthRecord> records = [];
  bool loading = false;

  // Fetch all records from DB and notify listeners
  Future<void> fetchRecords() async {
    try {
      loading = true;
      notifyListeners();
      final fetched = await _repo.getAll(); 
      records = fetched;
    } catch (e) {
      // handle/log error if needed
    } finally {
      loading = false;
      notifyListeners();
    }
  }

 
  Future<void> saveRecordToDatabase(HealthRecord record) async {
    try {
      loading = true;
      notifyListeners();
      await _repo.save(record); 
      records.insert(0, record);
      
    } catch (e) {
      // handle/log
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  
  Future<void> deleteRecordFromDatabase(HealthRecord record) async {
    try {
      loading = true;
      notifyListeners();
      await _repo.delete(record);
      records.removeWhere((r) => r.id == record.id);
    } catch (e) {
      // handle/log
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecordInDatabase(HealthRecord record) async {
    try {
      loading = true;
      notifyListeners();
      await _repo.update(record); 
      int index = records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        records[index] = record; 
      }
    } catch (e) {
      // handle/log
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
