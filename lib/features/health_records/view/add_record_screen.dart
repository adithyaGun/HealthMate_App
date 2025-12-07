import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/health_record.dart';
import '../view_model/health_record_view_model.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  // Function to show the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = DateTime(2101);

    // Show date picker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _dateController.text = pickedDate.toLocal().toString().split(
          ' ',
        )[0]; // Format as 'YYYY-MM-DD'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthRecordViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Record'),
        backgroundColor: Colors.teal, 
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select date',
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.isEmpty) ? 'Select a date' : null,
              ),
              const SizedBox(height: 20),

              
              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Steps',
                  hintText: 'Enter number of steps',
                  prefixIcon: const Icon(Icons.directions_walk, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter steps' : null,
              ),
              const SizedBox(height: 20),

              
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Calories',
                  hintText: 'Enter number of calories burned',
                  prefixIcon: const Icon(Icons.local_fire_department, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter calories' : null,
              ),
              const SizedBox(height: 20),

              
              TextFormField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Water Intake (ml)',
                  hintText: 'Enter water intake in ml',
                  prefixIcon: const Icon(Icons.local_drink, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter water intake' : null,
              ),
              const SizedBox(height: 30),

              
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final newRecord = HealthRecord(
                    id: null,
                    title: _dateController.text.trim(), // Store the selected date as title
                    steps: int.parse(_stepsController.text.trim()),
                    calories: double.parse(_caloriesController.text.trim()),
                    waterIntake: int.parse(_waterController.text.trim()),
                    createdAt: DateTime.now().toIso8601String(),
                  );

                  await viewModel.saveRecordToDatabase(newRecord);

                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  shadowColor: Colors.teal.withOpacity(0.5),
                  elevation: 8.0,
                ),
                child: const Text(
                  'Save Record',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
