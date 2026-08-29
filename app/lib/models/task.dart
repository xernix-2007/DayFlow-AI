enum TaskCategory { dsa, aiData, development, college, fitness, personal, other }

enum TaskPriority { low, medium, high, critical }

class DayTask {
  const DayTask({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.plannedStart,
    required this.plannedMinutes,
    this.difficulty = 3,
    this.completed = false,
    this.actualStart,
    this.actualEnd,
    this.predictedMinutes,
    this.qualityScore,
  });

  final String id;
  final String title;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime plannedStart;
  final int plannedMinutes;
  final int difficulty;
  final bool completed;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final double? predictedMinutes;
  final int? qualityScore;

  int? get actualMinutes {
    if (actualStart == null || actualEnd == null) return null;
    return actualEnd!.difference(actualStart!).inMinutes;
  }

  DayTask copyWith({
    String? title,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? plannedStart,
    int? plannedMinutes,
    int? difficulty,
    bool? completed,
    DateTime? actualStart,
    DateTime? actualEnd,
    double? predictedMinutes,
    int? qualityScore,
  }) {
    return DayTask(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      plannedStart: plannedStart ?? this.plannedStart,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      difficulty: difficulty ?? this.difficulty,
      completed: completed ?? this.completed,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      predictedMinutes: predictedMinutes ?? this.predictedMinutes,
      qualityScore: qualityScore ?? this.qualityScore,
    );
  }
}

class FocusSession {
  const FocusSession({
    required this.id,
    required this.taskId,
    required this.startedAt,
    this.endedAt,
    this.pausedSeconds = 0,
    this.distractionSeconds = 0,
  });

  final String id;
  final String taskId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int pausedSeconds;
  final int distractionSeconds;

  int get activeSeconds {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt).inSeconds - pausedSeconds;
  }
}
