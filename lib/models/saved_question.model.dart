import 'dart:convert';

class SavedQuestionModel {
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

  SavedQuestionModel({
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
  });

  factory SavedQuestionModel.fromMap(Map<String, dynamic> map) {
    return SavedQuestionModel(
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
    };
  }
}
