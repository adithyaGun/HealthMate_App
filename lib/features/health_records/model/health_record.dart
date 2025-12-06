class HealthRecord {
  int? id;
  String title;
  int steps;
  double calories;
  int waterIntake;
  String createdAt;

  HealthRecord({
    this.id,
    required this.title,
    required this.steps,
    required this.calories,
    required this.waterIntake,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'steps': steps,
      'calories': calories,
      'waterIntake': waterIntake,
      'createdAt': createdAt,
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      title: map['title'],
      steps: map['steps'],
      calories: (map['calories'] as num).toDouble(),
      waterIntake: map['waterIntake'],
      createdAt: map['createdAt'],
    );
  }
}
