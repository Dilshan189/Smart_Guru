import 'dart:convert';

class QuizHistoryModel {
  final String id;
  final String question;
  final String questionImage;
  final List<dynamic> options;
  final int? correctAnswerIndex;
  final String explanation;
  final String explanationImage;
  final String exampleAudio;
  final String paragraphText;
  final Map<String, dynamic> rawItem;
  final String? categoryName;
  final bool isCorrect;
  final String? timestamp;

  QuizHistoryModel({
    required this.id,
    required this.question,
    required this.questionImage,
    required this.options,
    this.correctAnswerIndex,
    required this.explanation,
    required this.explanationImage,
    required this.exampleAudio,
    required this.paragraphText,
    required this.rawItem,
    this.categoryName,
    required this.isCorrect,
    this.timestamp,
  });

  factory QuizHistoryModel.fromMap(Map<String, dynamic> map) {
    return QuizHistoryModel(
      id: map['id']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      questionImage: map['questionImage']?.toString() ?? '',
      options: map['options'] is String ? jsonDecode(map['options']) : (map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'],
      explanation: map['explanation']?.toString() ?? '',
      explanationImage: map['explanationImage']?.toString() ?? '',
      exampleAudio: map['exampleAudio']?.toString() ?? '',
      paragraphText: map['paragraphText']?.toString() ?? '',
      rawItem: map['raw_item'] is String ? jsonDecode(map['raw_item']) : (map['raw_item'] ?? {}),
      categoryName: map['categoryName'],
      isCorrect: map['isCorrect'] == 1,
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'questionImage': questionImage,
      'options': jsonEncode(options),
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'explanationImage': explanationImage,
      'exampleAudio': exampleAudio,
      'paragraphText': paragraphText,
      'raw_item': jsonEncode(rawItem),
      'categoryName': categoryName,
      'isCorrect': isCorrect ? 1 : 0,
      'timestamp': timestamp,
    };
  }
}
