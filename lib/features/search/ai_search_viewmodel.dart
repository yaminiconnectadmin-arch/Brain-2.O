import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/brain_item.dart';
import '../../services/ai_service.dart';
import '../../services/database_service.dart';
import '../dashboard/dashboard_viewmodel.dart';

final aiSearchViewModelProvider = StateNotifierProvider<AISearchViewModel, AISearchState>((ref) {
  return AISearchViewModel(
    ref.read(databaseServiceProvider),
    ref.read(aiServiceProvider),
  );
});

class AISearchState {
  final bool isSearching;
  final String query;
  final List<BrainItem> results;

  AISearchState({
    this.isSearching = false,
    this.query = '',
    this.results = const [],
  });

  AISearchState copyWith({
    bool? isSearching,
    String? query,
    List<BrainItem>? results,
  }) {
    return AISearchState(
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

class AISearchViewModel extends StateNotifier<AISearchState> {
  final DatabaseService _db;
  final AIService _ai;

  AISearchViewModel(this._db, this._ai) : super(AISearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: '', results: []);
      return;
    }

    state = state.copyWith(isSearching: true, query: query);

    final allItems = await _db.getAllBrainItems();
    final results = await _ai.searchSemantic(query, allItems);

    state = state.copyWith(isSearching: false, results: results);
  }
}
