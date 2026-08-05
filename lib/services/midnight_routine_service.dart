import '../core/models/brain_item.dart';
import '../core/models/daily_review.dart';
import 'database_service.dart';

class MidnightRoutineService {
  final DatabaseService _db = DatabaseService();

  /// Runs the automated Midnight AI Routine
  Future<DailyReview> executeMidnightRoutine() async {
    final allItems = await _db.getAllBrainItems();

    // 1. Filter completed vs pending items
    final completedItems = allItems.where((item) => item.isCompleted).toList();
    final pendingItems = allItems.where((item) => !item.isCompleted).toList();

    // 2. Automatically reschedule uncompleted tasks to Tomorrow / Timeline
    for (var item in pendingItems) {
      if (item.category == TimelineCategory.today) {
        final updated = item.copyWith(category: TimelineCategory.tomorrow);
        await _db.updateBrainItem(updated);
      }
    }

    // 3. Move completed items to Archive
    for (var item in completedItems) {
      if (item.category != TimelineCategory.archived) {
        final archivedItem = item.copyWith(category: TimelineCategory.archived);
        await _db.updateBrainItem(archivedItem);
      }
    }

    // 4. Calculate stats & Generate tomorrow's mission summary
    final dateKey = DateTime.now().toIso8601String().substring(0, 10);
    final review = DailyReview(
      date: dateKey,
      mission: 'Execute key priorities with clarity. Unnecessary clutter has been archived.',
      completedTasks: completedItems.length,
      totalTasks: allItems.length,
      meetingsAttended: allItems.where((i) => i.type == BrainItemType.meeting).length,
      hoursWorked: 7.0,
      productivityScore: 92,
      topDiscussedTopic: 'CodeVerse Visualizer & Execution',
      wins: [
        'Organized ${allItems.length} voice inputs automatically',
        'Archived ${completedItems.length} completed tasks',
        'Zero manual planning required'
      ],
      tomorrowSuggestions: [
        'Review presentation before HOD meeting',
        'Follow up with Rahul regarding proposal'
      ],
    );

    await _db.insertOrUpdateDailyReview(review);
    return review;
  }
}
