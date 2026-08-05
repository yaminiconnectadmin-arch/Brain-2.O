import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/brain_item.dart';
import '../../core/models/daily_review.dart';
import '../../services/ai_service.dart';
import '../../services/database_service.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());
final aiServiceProvider = Provider<AIService>((ref) => GeminiAIService());

final dashboardViewModelProvider = StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
  return DashboardViewModel(
    ref.read(databaseServiceProvider),
    ref.read(aiServiceProvider),
  );
});

class DashboardState {
  final bool isLoading;
  final String greeting;
  final String mission;
  final List<BrainItem> todayItems;
  final List<BrainItem> upcomingMeetings;
  final DailyReview? review;

  DashboardState({
    this.isLoading = false,
    this.greeting = 'Good Morning.',
    this.mission = 'Focus on high-leverage execution today.',
    this.todayItems = const [],
    this.upcomingMeetings = const [],
    this.review,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? greeting,
    String? mission,
    List<BrainItem>? todayItems,
    List<BrainItem>? upcomingMeetings,
    DailyReview? review,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      greeting: greeting ?? this.greeting,
      mission: mission ?? this.mission,
      todayItems: todayItems ?? this.todayItems,
      upcomingMeetings: upcomingMeetings ?? this.upcomingMeetings,
      review: review ?? this.review,
    );
  }
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  final DatabaseService _db;
  final AIService _ai;

  DashboardViewModel(this._db, this._ai) : super(DashboardState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true);

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning.' : (hour < 17 ? 'Good Afternoon.' : 'Good Evening.');

    final items = await _db.getAllBrainItems();
    final today = items.where((i) => i.category == TimelineCategory.today).toList();
    final meetings = items.where((i) => i.type == BrainItemType.meeting && !i.isCompleted).toList();

    state = state.copyWith(
      isLoading: false,
      greeting: greeting,
      todayItems: today,
      upcomingMeetings: meetings,
    );
  }

  Future<void> processNewVoiceInput(String transcript) async {
    state = state.copyWith(isLoading: true);

    final extractedItems = await _ai.processTranscript(transcript);
    for (var item in extractedItems) {
      await _db.insertBrainItem(item);
    }

    await loadDashboardData();
  }

  Future<void> toggleItemCompletion(BrainItem item) async {
    final updated = item.copyWith(isCompleted: !item.isCompleted);
    await _db.updateBrainItem(updated);
    await loadDashboardData();
  }
}
