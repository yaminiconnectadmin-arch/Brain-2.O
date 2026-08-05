/// DailyReview holds the metrics for Night Review and Morning Routine
class DailyReview {
  final String date; // YYYY-MM-DD
  final String mission;
  final int completedTasks;
  final int totalTasks;
  final int meetingsAttended;
  final double hoursWorked;
  final int productivityScore; // 0 to 100
  final String topDiscussedTopic;
  final List<String> tomorrowSuggestions;
  final List<String> wins;

  DailyReview({
    required this.date,
    required this.mission,
    this.completedTasks = 0,
    this.totalTasks = 0,
    this.meetingsAttended = 0,
    this.hoursWorked = 0.0,
    this.productivityScore = 85,
    this.topDiscussedTopic = 'Core Architecture & AI',
    this.tomorrowSuggestions = const [],
    this.wins = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'mission': mission,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'meetingsAttended': meetingsAttended,
      'hoursWorked': hoursWorked,
      'productivityScore': productivityScore,
      'topDiscussedTopic': topDiscussedTopic,
      'tomorrowSuggestions': tomorrowSuggestions.join('||'),
      'wins': wins.join('||'),
    };
  }

  factory DailyReview.fromMap(Map<String, dynamic> map) {
    return DailyReview(
      date: map['date'] as String,
      mission: map['mission'] as String,
      completedTasks: map['completedTasks'] as int,
      totalTasks: map['totalTasks'] as int,
      meetingsAttended: map['meetingsAttended'] as int,
      hoursWorked: (map['hoursWorked'] as num).toDouble(),
      productivityScore: map['productivityScore'] as int,
      topDiscussedTopic: map['topDiscussedTopic'] as String,
      tomorrowSuggestions: map['tomorrowSuggestions'] != null && (map['tomorrowSuggestions'] as String).isNotEmpty
          ? (map['tomorrowSuggestions'] as String).split('||')
          : [],
      wins: map['wins'] != null && (map['wins'] as String).isNotEmpty
          ? (map['wins'] as String).split('||')
          : [],
    );
  }
}
