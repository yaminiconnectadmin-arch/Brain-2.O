import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/brain_item.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/priority_badge.dart';
import 'timeline_viewmodel.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timelineViewModelProvider);
    final viewModel = ref.read(timelineViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Timeline',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Column(
        children: [
          // Category Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: TimelineCategory.values.map((cat) {
                final isSelected = state.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      _categoryLabel(cat),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryAccent,
                    backgroundColor: AppColors.darkSurfaceCard,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGlow : AppColors.darkGlassBorder,
                    ),
                    onSelected: (_) => viewModel.loadCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent))
                : state.items.isEmpty
                    ? Center(
                        child: Text(
                          'No items in ${_categoryLabel(state.selectedCategory)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textMutedDark,
                              ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return GlassCard(
                            onTap: () => viewModel.toggleItemCompletion(item),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item.isCompleted,
                                  activeColor: AppColors.primaryAccent,
                                  onChanged: (_) => viewModel.toggleItemCompletion(item),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    decoration: item.isCompleted
                                                        ? TextDecoration.lineThrough
                                                        : null,
                                                    color: item.isCompleted
                                                        ? AppColors.textMutedDark
                                                        : AppColors.textPrimaryDark,
                                                  ),
                                            ),
                                          ),
                                          PriorityBadge(priority: item.priority),
                                        ],
                                      ),
                                      if (item.description.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          item.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                      if (item.people.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.person_outline, size: 14, color: AppColors.textMutedDark),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.people.join(', '),
                                              style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(TimelineCategory cat) {
    switch (cat) {
      case TimelineCategory.today:
        return 'Today';
      case TimelineCategory.tomorrow:
        return 'Tomorrow';
      case TimelineCategory.thisWeek:
        return 'This Week';
      case TimelineCategory.upcoming:
        return 'Upcoming';
      case TimelineCategory.completed:
        return 'Completed';
      case TimelineCategory.archived:
        return 'Archived';
    }
  }
}
