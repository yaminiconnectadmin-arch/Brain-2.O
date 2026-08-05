import 'package:flutter_test/flutter_test.dart';
import 'package:second_brain_ai/core/models/brain_item.dart';
import 'package:second_brain_ai/services/ai_service.dart';

void main() {
  group('BrainItem Model Tests', () {
    test('BrainItem converts to map and back accurately', () {
      final now = DateTime.now();
      final item = BrainItem(
        id: 'test-123',
        title: 'Meeting regarding CodeVerse',
        type: BrainItemType.meeting,
        priority: PriorityLevel.high,
        category: TimelineCategory.tomorrow,
        createdAt: now,
        people: ['Rahul', 'HOD'],
        tags: ['CodeVerse'],
      );

      final map = item.toMap();
      expect(map['id'], 'test-123');
      expect(map['type'], 'meeting');
      expect(map['priority'], 'high');

      final reconstructed = BrainItem.fromMap(map);
      expect(reconstructed.id, 'test-123');
      expect(reconstructed.title, 'Meeting regarding CodeVerse');
      expect(reconstructed.people, contains('Rahul'));
    });
  });

  group('LocalRuleAIService Tests', () {
    test('Extracts tasks and meetings from natural spoken input', () async {
      final ai = LocalRuleAIService();
      const sample =
          'Tomorrow morning I have a meeting with my HOD regarding the CodeVerse Visualizer. Before that I need to finish my presentation, call Rahul, and send the proposal.';

      final items = await ai.processTranscript(sample);
      expect(items.isNotEmpty, isTrue);

      final meeting = items.firstWhere((i) => i.type == BrainItemType.meeting);
      expect(meeting.title, contains('CodeVerse'));
      expect(meeting.category, TimelineCategory.tomorrow);

      final presentationTask = items.firstWhere((i) => i.title.contains('presentation'));
      expect(presentationTask.priority, PriorityLevel.high);
    });

    test('Omits temporal/urgency words from title and assigns high priority for urgent items', () async {
      final ai = LocalRuleAIService();
      const sample = 'Tomorrow at 8 AM I need to prepare financial report and it is urgent';

      final items = await ai.processTranscript(sample);
      expect(items.isNotEmpty, isTrue);

      final task = items.first;
      expect(task.priority, PriorityLevel.high);
      expect(task.category, TimelineCategory.tomorrow);
      expect(task.scheduledAt, isNotNull);
      expect(task.title.contains('urgent'), isFalse);
      expect(task.title.contains('tomorrow'), isFalse);
      expect(task.title.contains('8 AM'), isFalse);
    });
  });
}
