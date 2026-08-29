import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DayFlowApp());
}

class DayFlowApp extends StatelessWidget {
  const DayFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayFlow AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B10),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: const Color(0xFF10151D),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF202936)),
          ),
        ),
      ),
      home: const TodayScreen(),
    );
  }
}

class DayTask {
  DayTask({
    required this.title,
    required this.category,
    required this.start,
    required this.duration,
    this.done = false,
  });

  final String title;
  final String category;
  final TimeOfDay start;
  final Duration duration;
  bool done;
}

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final List<DayTask> tasks = [
    DayTask(
      title: 'Morning routine',
      category: 'Personal',
      start: const TimeOfDay(hour: 7, minute: 0),
      duration: const Duration(minutes: 30),
      done: true,
    ),
    DayTask(
      title: 'DSA practice',
      category: 'DSA',
      start: const TimeOfDay(hour: 9, minute: 0),
      duration: const Duration(hours: 2),
    ),
    DayTask(
      title: 'Data Science',
      category: 'AI / Data',
      start: const TimeOfDay(hour: 11, minute: 30),
      duration: const Duration(hours: 2),
    ),
    DayTask(
      title: 'College work',
      category: 'College',
      start: const TimeOfDay(hour: 15, minute: 0),
      duration: const Duration(hours: 1, minutes: 30),
    ),
    DayTask(
      title: 'DayFlow project',
      category: 'Development',
      start: const TimeOfDay(hour: 17, minute: 0),
      duration: const Duration(hours: 2),
    ),
    DayTask(
      title: 'Workout',
      category: 'Fitness',
      start: const TimeOfDay(hour: 20, minute: 0),
      duration: const Duration(hours: 1),
    ),
  ];

  int get completed => tasks.where((task) => task.done).length;
  double get progress => tasks.isEmpty ? 0 : completed / tasks.length;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'DAYFLOW AI',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
              children: [
                Text(date, style: TextStyle(color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                const Text(
                  'Design your day.',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plan realistically. Work. Learn from what actually happened.',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                const SizedBox(height: 20),
                _SummaryCard(progress: progress, completed: completed, total: tasks.length),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Text('TODAY', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                    const Spacer(),
                    Text(
                      '${tasks.length} blocks',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...tasks.asMap().entries.map((entry) => _TaskTile(
                      task: entry.value,
                      onChanged: (value) {
                        setState(() => entry.value.done = value ?? false);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTask(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
      ),
    );
  }

  Future<void> _showAddTask(BuildContext context) async {
    final controller = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Solve 3 DSA problems',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Add')),
        ],
      ),
    );

    if (added == true && controller.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(DayTask(
          title: controller.text.trim(),
          category: 'Other',
          start: const TimeOfDay(hour: 21, minute: 0),
          duration: const Duration(hours: 1),
        ));
      });
    }
    controller.dispose();
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.progress, required this.completed, required this.total});

  final double progress;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Daily progress', style: TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 9,
                backgroundColor: const Color(0xFF202936),
              ),
            ),
            const SizedBox(height: 12),
            Text('$completed of $total tasks completed', style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onChanged});

  final DayTask task;
  final ValueChanged<bool?> onChanged;

  String _time(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(task.start, alwaysUse24HourFormat: false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onChanged(!task.done),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              SizedBox(
                width: 62,
                child: Text(_time(context), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ),
              Container(width: 2, height: 42, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        decoration: task.done ? TextDecoration.lineThrough : null,
                        color: task.done ? Colors.grey.shade500 : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.category}  •  ${task.duration.inMinutes} min',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Checkbox(value: task.done, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
