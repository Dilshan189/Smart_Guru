class ReviewAnswer {
  final int? id;
  final String userId;
  final String title;
  final String category;
  final String score;
  final String question;
  final String time;
  final String imagePath;
  final String answer;
  final int masteredCount;

  ReviewAnswer({
    this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.score,
    required this.question,
    required this.time,
    required this.imagePath,
    required this.answer,
    this.masteredCount = 0,
  });

  // Convert object  Map (for inserting into DB)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'title': title,
      'category': category,
      'score': score,
      'question': question,
      'time': time,
      'imagePath': imagePath,
      'answer': answer,
      'masteredCount': masteredCount,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Convert Map object (for reading from DB)
  factory ReviewAnswer.fromMap(Map<String, dynamic> map) {
    return ReviewAnswer(
      id: map['id'] as int?,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? '',
      score: map['score'] as String? ?? '',
      question: map['question'] as String? ?? '',
      time: map['time'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      masteredCount: map['masteredCount'] as int? ?? 0,
    );
  }
}
