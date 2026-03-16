class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.days,
  });

  final String id;
  final String title;
  final String description;
  final List<ReadingPlanDay> days;

  factory ReadingPlan.fromJson(Map<String, dynamic> json) => ReadingPlan(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        days: (json['days'] as List)
            .map((d) => ReadingPlanDay.fromJson(d as Map<String, dynamic>))
            .toList(),
      );

  int get totalDays => days.length;
}

class ReadingPlanDay {
  const ReadingPlanDay({
    required this.day,
    required this.uid,
    required this.title,
    this.description,
  });

  final int day;
  final String uid;
  final String title;
  final String? description;

  factory ReadingPlanDay.fromJson(Map<String, dynamic> json) => ReadingPlanDay(
        day: json['day'] as int,
        uid: json['uid'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
      );
}
