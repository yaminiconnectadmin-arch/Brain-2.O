import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import 'night_review_viewmodel.dart';

class NightReviewScreen extends ConsumerWidget {
  const NightReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nightReviewViewModelProvider);
    final viewModel = ref.read(nightReviewViewModelProvider.notifier);
    final review = state.review;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Night Review',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round, color: AppColors.primaryGlow),
            onPressed: () => viewModel.triggerMidnightRoutine(),
            tooltip: 'Run Midnight Routine',
          ),
        ],
      ),
      body: state.isLoading || review == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  // Productivity Score Hero Card
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(
                              'Productivity Score',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${review.productivityScore} / 100',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: AppColors.primaryGlow,
                                    fontSize: 36,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                          ),
                          child: const Icon(Icons.insights, color: Colors.white, size: 32),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale(),

                  // Stats Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            title: 'Completed',
                            value: '${review.completedTasks}/${review.totalTasks}',
                            icon: Icons.check_circle_outline,
                            color: AppColors.priorityLow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            title: 'Meetings',
                            value: '${review.meetingsAttended}',
                            icon: Icons.groups_outlined,
                            color: AppColors.categoryMeeting,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            title: 'Hours',
                            value: '${review.hoursWorked}h',
                            icon: Icons.access_time,
                            color: AppColors.priorityMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Today's Wins Section
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                    child: Text(
                      'Today\'s Wins',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...review.wins.map((win) => GlassCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.priorityMedium, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                win,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      )),

                  // Tomorrow Suggestions
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 8),
                    child: Text(
                      'AI Tomorrow Planning',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...review.tomorrowSuggestions.map((sug) => GlassCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.primaryGlow, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                sug,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 2),
          Text(title, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
