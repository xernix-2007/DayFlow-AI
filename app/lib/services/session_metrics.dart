import '../models/task.dart';

class SessionMetrics {
  const SessionMetrics({
    required this.plannedMinutes,
    required this.actualMinutes,
    required this.focusMinutes,
    required this.distractionMinutes,
    required this.speedRatio,
    required this.absolutePredictionError,
  });

  final int plannedMinutes;
  final int actualMinutes;
  final int focusMinutes;
  final int distractionMinutes;
  final double speedRatio;
  final double? absolutePredictionError;

  double get focusRatio {
    final total = focusMinutes + distractionMinutes;
    return total == 0 ? 0 : focusMinutes / total;
  }

  static SessionMetrics fromTask(DayTask task, {int? focusMinutes, int? distractionMinutes}) {
    final actual = task.actualMinutes ?? 0;
    final focus = focusMinutes ?? actual;
    final distraction = distractionMinutes ?? 0;
    final speed = actual <= 0 ? 0 : task.plannedMinutes / actual;
    final error = task.predictedMinutes == null
        ? null
        : (task.predictedMinutes! - actual).abs();

    return SessionMetrics(
      plannedMinutes: task.plannedMinutes,
      actualMinutes: actual,
      focusMinutes: focus,
      distractionMinutes: distraction,
      speedRatio: speed,
      absolutePredictionError: error,
    );
  }
}

class ProductivityScore {
  const ProductivityScore(this.value);

  final double value;

  static ProductivityScore calculate({
    required double completionRatio,
    required double focusRatio,
    required double scheduleAdherence,
    double qualityRatio = 1,
  }) {
    final score = (completionRatio * 0.35 +
            focusRatio * 0.30 +
            scheduleAdherence * 0.20 +
            qualityRatio * 0.15) *
        100;
    return ProductivityScore(score.clamp(0, 100).toDouble());
  }
}
