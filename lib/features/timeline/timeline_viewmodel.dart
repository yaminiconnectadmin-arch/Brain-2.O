import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/brain_item.dart';
import '../../services/database_service.dart';
import '../dashboard/dashboard_viewmodel.dart';

final timelineViewModelProvider = StateNotifierProvider<TimelineViewModel, TimelineState>((ref) {
  return TimelineViewModel(ref.read(databaseServiceProvider));
});

class TimelineState {
  final bool isLoading;
  final TimelineCategory selectedCategory;
  final List<BrainItem> items;

  TimelineState({
    this.isLoading = false,
    this.selectedCategory = TimelineCategory.today,
    this.items = const [],
  });

  TimelineState copyWith({
    bool? isLoading,
    TimelineCategory? selectedCategory,
    List<BrainItem>? items,
  }) {
    return TimelineState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      items: items ?? this.items,
    );
  }
}

class TimelineViewModel extends StateNotifier<TimelineState> {
  final DatabaseService _db;

  TimelineViewModel(this._db) : super(TimelineState()) {
    loadCategory(TimelineCategory.today);
  }

  Future<void> loadCategory(TimelineCategory category) async {
    state = state.copyWith(isLoading: true, selectedCategory: category);

    final allItems = await _db.getAllBrainItems();
    List<BrainItem> filtered = [];

    switch (category) {
      case TimelineCategory.today:
        filtered = allItems.where((i) => i.category == TimelineCategory.today && !i.isCompleted).toList();
        break;
      case TimelineCategory.tomorrow:
        filtered = allItems.where((i) => i.category == TimelineCategory.tomorrow && !i.isCompleted).toList();
        break;
      case TimelineCategory.thisWeek:
        filtered = allItems.where((i) => !i.isCompleted && 
          (i.category == TimelineCategory.today || 
           i.category == TimelineCategory.tomorrow || 
           i.category == TimelineCategory.thisWeek)).toList();
        break;
      case TimelineCategory.upcoming:
        filtered = allItems.where((i) => i.category == TimelineCategory.upcoming && !i.isCompleted).toList();
        break;
      case TimelineCategory.completed:
        filtered = allItems.where((i) => i.isCompleted).toList();
        break;
      case TimelineCategory.archived:
        filtered = allItems.where((i) => i.category == TimelineCategory.archived).toList();
        break;
    }

    state = state.copyWith(isLoading: false, items: filtered);
  }

  Future<void> toggleItemCompletion(BrainItem item) async {
    final updated = item.copyWith(isCompleted: !item.isCompleted);
    await _db.updateBrainItem(updated);
    await loadCategory(state.selectedCategory);
  }
}
