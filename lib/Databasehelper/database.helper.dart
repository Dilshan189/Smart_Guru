import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/saved_question.model.dart';
import '../models/quiz.history.model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_guru.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createQuizHistoryTable(db);
    }
    if (oldVersion < 3) {
      // Add timestamp column if upgrading to v3
      try {
        await db.execute("ALTER TABLE quiz_history ADD COLUMN timestamp TEXT");
      } catch (e) {
        debugPrint("Timestamp column update failed or already exists: $e");
      }
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const intNullableType = 'INTEGER';

    await db.execute('''
CREATE TABLE saved_questions (
  id $idType,
  question $textType,
  questionImage $textNullableType,
  options $textType, 
  correctAnswerIndex $intNullableType,
  explanation $textNullableType,
  explanationImage $textNullableType,
  exampleAudio $textNullableType,
  paragraphText $textNullableType,
  raw_item $textNullableType
)
''');

    await db.execute('''
CREATE TABLE incorrect_answers (
  id $idType,
  question $textType,
  questionImage $textNullableType,
  options $textType, 
  correctAnswerIndex $intNullableType,
  explanation $textNullableType,
  explanationImage $textNullableType,
  exampleAudio $textNullableType,
  paragraphText $textNullableType,
  raw_item $textNullableType
)
''');

    await _createQuizHistoryTable(db);
  }

  Future<void> _createQuizHistoryTable(Database db) async {
    await db.execute('''
CREATE TABLE quiz_history (
  id TEXT PRIMARY KEY,
  question TEXT NOT NULL,
  questionImage TEXT,
  options TEXT, 
  correctAnswerIndex INTEGER,
  explanation TEXT,
  explanationImage TEXT,
  exampleAudio TEXT,
  paragraphText TEXT,
  raw_item TEXT,
  categoryName TEXT,
  isCorrect INTEGER,
  timestamp TEXT
)
''');
  }

  Future<void> insertSavedQuestion(SavedQuestionModel questionModel) async {
    final db = await instance.database;
    await db.insert(
      'saved_questions',
      questionModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertIncorrectQuestion(SavedQuestionModel questionModel) async {
    final db = await instance.database;
    await db.insert(
      'incorrect_answers',
      questionModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteSavedQuestion(String id) async {
    final db = await instance.database;
    return await db.delete('saved_questions', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isQuestionSaved(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'saved_questions',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<SavedQuestionModel>> getAllSavedQuestions() async {
    return await _getAllFromTable('saved_questions');
  }

  Future<List<SavedQuestionModel>> getAllIncorrectQuestions() async {
    return await _getAllFromTable('incorrect_answers');
  }

  Future<void> insertQuizHistory(QuizHistoryModel questionModel) async {
    try {
      final db = await instance.database;
      await db.insert(
        'quiz_history',
        questionModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("Quiz History Saved: ${questionModel.id}");
    } catch (e) {
      debugPrint("Error inserting quiz history: $e");
      final db = await instance.database;
      if (e.toString().contains("no such table")) {
        await _createQuizHistoryTable(db);
        await db.insert(
          'quiz_history',
          questionModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else if (e.toString().contains("timestamp")) {
        try {
          await db.execute(
            "ALTER TABLE quiz_history ADD COLUMN timestamp TEXT",
          );
          await db.insert(
            'quiz_history',
            questionModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e2) {
          debugPrint("Fallback column addition failed: $e2");
        }
      }
    }
  }

  Future<List<QuizHistoryModel>> getAllQuizHistory() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_history');
    return maps.map((row) => QuizHistoryModel.fromMap(row)).toList();
  }

  Future<List<SavedQuestionModel>> _getAllFromTable(String tableName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((row) => SavedQuestionModel.fromMap(row)).toList();
  }

  Future<int> getSavedQuestionsCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM saved_questions'),
    );
    return count ?? 0;
  }

  Future<int> getIncorrectQuestionsCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM incorrect_answers'),
    );
    return count ?? 0;
  }
}
