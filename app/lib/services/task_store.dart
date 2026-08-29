import '../models/task.dart';

class TaskStore {
  TaskStore({List<DayTask>? initialTasks}) : _tasks = [...?initialTasks];

  final List<DayTask> _tasks;
  final List<FocusSession> _sessions = [];

  List<DayTask> get tasks => List.unmodifiable(_tasks);
  List<FocusSession> get sessions => List.unmodifiable(_sessions);

  void addTask(DayTask task) => _tasks.add(task);

  void updateTask(DayTask task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index >= 0) _tasks[index] = task;
  }

  void deleteTask(String id) => _tasks.removeWhere((task) => task.id == id);

  void addSession(FocusSession session) => _sessions.add(session);

  DayTask? findTask(String id) {
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }
}
