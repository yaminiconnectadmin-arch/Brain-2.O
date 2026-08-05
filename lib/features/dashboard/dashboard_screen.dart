import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/primary_record_button.dart';
import '../../core/widgets/priority_badge.dart';
import '../night_review/night_review_screen.dart';
import '../recording/recording_modal.dart';
import '../search/ai_search_screen.dart';
import '../timeline/timeline_screen.dart';
import 'dashboard_viewmodel.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _openRecordingModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordingModal(
        onTranscriptProcessed: (transcript) {
          ref.read(dashboardViewModelProvider.notifier).processNewVoiceInput(transcript);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primaryAccent,
              onRefresh: () => viewModel.loadDashboardData(),
              child: CustomScrollView(
                slivers: [
                  // App Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Text(
                                state.greeting,
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Second Brain AI Operating System',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search_rounded, color: AppColors.textPrimaryDark),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AISearchScreen()),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.nightlight_round, color: AppColors.primaryGlow),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const NightReviewScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Today's Mission Hero Card
                  SliverToBoxAdapter(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: AppColors.primaryGlow, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'TODAY\'S MISSION',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.primaryGlow,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.mission,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                  ),

                  // Quick Action Tabs bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.darkGlassBorder),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              icon: const Icon(Icons.timeline_rounded, color: AppColors.primaryAccent),
                              label: const Text('Smart Timeline', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Upcoming Meetings Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        'Upcoming Meetings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  if (state.upcomingMeetings.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'No meetings scheduled. Clear focus time ahead.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final meeting = state.upcomingMeetings[index];
                          return GlassCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.categoryMeeting.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.calendar_today_rounded, color: AppColors.categoryMeeting),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAlignment.start,
                                    children: [
                                      Text(
                                        meeting.title,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        meeting.people.isNotEmpty ? 'With ${meeting.people.join(", ")}' : 'Scheduled event',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: state.upcomingMeetings.length,
                      ),
                    ),

                  // Today's Priority Action Items Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Priorities',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${state.todayItems.where((i) => i.isCompleted).length}/${state.todayItems.length}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.todayItems.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          'No active tasks today. Tap Record to speak natural thoughts.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.todayItems[index];
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
                                                    fontSize: 15,
                                                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                                  ),
                                            ),
                                          ),
                                          PriorityBadge(priority: item.priority),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: state.todayItems.length,
                      ),
                    ),

                  const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
                ],
              ),
            ),

            // One Large Record Button Floating at Bottom
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    PrimaryRecordButton(
                      isRecording: false,
                      onTap: () => _openRecordingModal(context, ref),
                      size: 76,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to Speak',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
