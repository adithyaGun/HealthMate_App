import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_model/health_record_view_model.dart';
import 'add_record_screen.dart';
import 'health_record_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthRecordViewModel>(context, listen: false).fetchRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: kPrimary,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Show date picker and filter data based on selected date
              DateTime? pickedDate = await _selectDate(context);
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
      body: Consumer<HealthRecordViewModel>(
        builder: (context, vm, child) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          List filteredRecords = _selectedDate != null
              ? vm.records.where((record) {
                  DateTime recordDate = DateTime.parse(record.createdAt);
                  return recordDate.year == _selectedDate!.year &&
                      recordDate.month == _selectedDate!.month &&
                      recordDate.day == _selectedDate!.day;
                }).toList()
              : vm.records;

          if (filteredRecords.isEmpty) {
            return const Center(
              child: Text(
                'No records available for the selected date',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final latestRecord = filteredRecords.isNotEmpty ? filteredRecords.first : null;

          if (latestRecord == null) {
            return const Center(child: Text('No records available.'));
          }

          final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(latestRecord.createdAt));

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header for the latest record
                _buildHeader(latestRecord.title, formattedDate),

                const SizedBox(height: 24.0),

                // Main Data Cards for Steps, Calories, and Water Intake
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard("Steps", latestRecord.steps),
                    _buildInfoCard("Calories", latestRecord.calories),
                    _buildInfoCard("Water", latestRecord.waterIntake),
                  ],
                ),

                const SizedBox(height: 30.0),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCircularProgress("Steps", latestRecord.steps, 10000),
                    _buildCircularProgress("Calories", latestRecord.calories, 2000),
                    _buildCircularProgress("Water", latestRecord.waterIntake, 2500),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'all',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HealthRecordListScreen(),
                  ),
                );
              },
              backgroundColor: kPrimary,
              child: const Icon(Icons.list, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddRecordScreen()),
                );
              },
              backgroundColor: kPrimary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Show date picker to select a date
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  // Header Section to display title and date
  Widget _buildHeader(String title, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Recorded on: $date',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // A helper to build the info cards for Steps, Calories, Water
  Widget _buildInfoCard(String title, dynamic value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6.0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 154, 241),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build circular progress indicators
  Widget _buildCircularProgress(String title, dynamic value, double max) {
    double progress = 0.0;

    if (value is int) {
      progress = value / max;
    } else if (value is double) {
      progress = value / max;
    }

    progress = progress > 1.0 ? 1.0 : progress;

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 77, 154, 255),
          ),
        ),
        const SizedBox(height: 8.0),
        CircularProgressIndicator(
          value: progress,
          strokeWidth: 8,
          backgroundColor: const Color.fromARGB(255, 173, 237, 231),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      ],
    );
  }
}
