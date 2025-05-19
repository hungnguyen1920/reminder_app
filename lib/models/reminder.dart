class Reminder {
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String userId;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'userId': userId,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      userId: map['userId'] as String,
    );
  }
}
