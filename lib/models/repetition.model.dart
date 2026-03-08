class Repetition {
  final int? id;
  final String userId;
  final String title;
  final String category;
  final String score;
  final String question;
  final String time;
  final String answer;
  final int totalCount;
  final int masteredCount;

  Repetition({
    this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.score,
    required this.question,
    required this.time,
    required this.answer,
    this.totalCount = 0,
    this.masteredCount = 0,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'title': title,
      'category': category,
      'score': score,
      'question': question,
      'time': time,
      'answer': answer,
      'totalCount': totalCount,
      'masteredCount': masteredCount,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Repetition.fromMap(Map<String, dynamic> map) {
    return Repetition(
      id: map['id'] as int?,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? '',
      score: map['score'] as String? ?? '',
      question: map['question'] as String? ?? '',
      time: map['time'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      totalCount: map['totalCount'] as int? ?? 0,
      masteredCount: map['masteredCount'] as int? ?? 0,
    );
  }
}
