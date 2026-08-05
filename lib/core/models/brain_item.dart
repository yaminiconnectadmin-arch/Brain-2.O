import 'dart:convert';

enum BrainItemType { task, meeting, idea, decision, question }

enum PriorityLevel { high, medium, low }

enum TimelineCategory { today, tomorrow, thisWeek, upcoming, completed, archived }

class BrainItem {
  final String id;
  final String title;
  final String description;
  final BrainItemType type;
  final PriorityLevel priority;
  final TimelineCategory category;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final DateTime? deadline;
  final String? location;
  final List<String> people;
  final List<String> tags;
  final bool isCompleted;
  final String? audioPath;

  BrainItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    this.priority = PriorityLevel.medium,
    this.category = TimelineCategory.today,
    required this.createdAt,
    this.scheduledAt,
    this.deadline,
    this.location,
    this.people = const [],
    this.tags = const [],
    this.isCompleted = false,
    this.audioPath,
  });

  BrainItem copyWith({
    String? id,
    String? title,
    String? description,
    BrainItemType? type,
    PriorityLevel? priority,
    TimelineCategory? category,
    DateTime? createdAt,
    DateTime? scheduledAt,
    DateTime? deadline,
    String? location,
    List<String>? people,
    List<String>? tags,
    bool? isCompleted,
    String? audioPath,
  }) {
    return BrainItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      deadline: deadline ?? this.deadline,
      location: location ?? this.location,
      people: people ?? this.people,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'priority': priority.name,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'location': location,
      'people': jsonEncode(people),
      'tags': jsonEncode(tags),
      'isCompleted': isCompleted ? 1 : 0,
      'audioPath': audioPath,
    };
  }

  factory BrainItem.fromMap(Map<String, dynamic> map) {
    return BrainItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      type: BrainItemType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => BrainItemType.task,
      ),
      priority: PriorityLevel.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => PriorityLevel.medium,
      ),
      category: TimelineCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TimelineCategory.today,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      scheduledAt: map['scheduledAt'] != null
          ? DateTime.parse(map['scheduledAt'] as String)
          : null,
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
      location: map['location'] as String?,
      people: map['people'] != null
          ? List<String>.from(jsonDecode(map['people'] as String))
          : [],
      tags: map['tags'] != null
          ? List<String>.from(jsonDecode(map['tags'] as String))
          : [],
      isCompleted: (map['isCompleted'] as int) == 1,
      audioPath: map['audioPath'] as String?,
    );
  }
}
