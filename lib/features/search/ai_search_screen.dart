import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/priority_badge.dart';
import 'ai_search_viewmodel.dart';

class AISearchScreen extends ConsumerWidget {
  const AISearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiSearchViewModelProvider);
    final viewModel = ref.read(aiSearchViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Search & Memory',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Column(
        children: [
          // Search Field Card
          GlassCard(
            child: TextField(
              autofocus: true,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Ask: "When did I discuss CodeVerse?" or "Rahul tasks"...',
                hintStyle: TextStyle(color: AppColors.textMutedDark, fontSize: 14),
                border: InputBorder.none,
                icon: const Icon(Icons.search_rounded, color: AppColors.primaryGlow),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMutedDark),
                        onPressed: () => viewModel.search(''),
                      )
                    : null,
              ),
              onChanged: (val) => viewModel.search(val),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: state.isSearching
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent))
                : state.query.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.psychology_outlined, size: 64, color: AppColors.textMutedDark),
                            const SizedBox(height: 12),
                            Text(
                              'Search understands intent & meaning',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : state.results.isEmpty
                        ? Center(
                            child: Text(
                              'No matching memories found.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: state.results.length,
                            itemBuilder: (context, index) {
                              final item = state.results[index];
                              return GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                        ),
                                        PriorityBadge(priority: item.priority),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.description,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    if (item.people.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 14, color: AppColors.primaryGlow),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.people.join(', '),
                                            style: Theme.of(context).textTheme.labelSmall,
                                          ),
                                        ],
                                      ),
                                    ]
                                  ],
                                ),
                              ).animate().fadeIn(duration: 200.ms, delay: (index * 40).ms);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
