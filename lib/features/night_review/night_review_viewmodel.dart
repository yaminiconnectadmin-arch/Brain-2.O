import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/daily_review.dart';
import '../../services/database_service.dart';
import '../../services/midnight_routine_service.dart';
import '../dashboard/dashboard_viewmodel.dart';

final midnightServiceProvider = Provider((ref) => MidnightRoutineService());

final nightReviewViewModelProvider = StateNotifierProvider<NightReviewViewModel, NightReviewState>((ref) {
  return NightReviewViewModel(
    ref.read(databaseServiceProvider),
    ref.read(midnightServiceProvider),
  );
});

class NightReviewState {
  final bool isLoading;
  final DailyReview? review;

  NightReviewState({this.isLoading = false, this.review});

  NightReviewState copyWith({bool? isLoading, DailyReview? review}) {
    return NightReviewState(
      isLoading: isLoading ?? this.isLoading,
      review: review ?? this.review,
    );
  }
}

class NightReviewViewModel extends StateNotifier<NightReviewState> {
  final DatabaseService _db;
  final MidnightRoutineService _midnight;

  NightReviewViewModel(this._db, this._midnight) : super(NightReviewState()) {
    loadNightReview();
  }

  Future<void> loadNightReview() async {
    state = state.copyWith(isLoading: true);
    final dateKey = DateTime.now().toIso8601String().substring(0, 10);
    var review = await _db.getDailyReview(dateKey);

    if (review == null) {
      review = await _midnight.executeMidnightRoutine();
    }

    state = state.copyWith(isLoading: false, review: review);
  }

  Future<void> triggerMidnightRoutine() async {
    state = state.copyWith(isLoading: true);
    final review = await _midnight.executeMidnightRoutine();
    state = state.copyWith(isLoading: false, review: review);
  }
}
