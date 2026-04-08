import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/saved_question.model.dart';

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
      version: 1,
      onCreate: _createDB,
    );
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
  }

  Future<void> insertSavedQuestion(SavedQuestionModel questionModel) async {
    final db = await instance.database;
    await db.insert('saved_questions', questionModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertIncorrectQuestion(SavedQuestionModel questionModel) async {
    final db = await instance.database;
    await db.insert('incorrect_answers', questionModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteSavedQuestion(String id) async {
    final db = await instance.database;
    return await db.delete('saved_questions', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isQuestionSaved(String id) async {
    final db = await instance.database;
    final maps = await db.query('saved_questions', columns: ['id'], where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }

  Future<List<SavedQuestionModel>> getAllSavedQuestions() async {
    return await _getAllFromTable('saved_questions');
  }

  Future<List<SavedQuestionModel>> getAllIncorrectQuestions() async {
    return await _getAllFromTable('incorrect_answers');
  }

  Future<List<SavedQuestionModel>> _getAllFromTable(String tableName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((row) => SavedQuestionModel.fromMap(row)).toList();
  }

  Future<int> getSavedQuestionsCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM saved_questions'));
    return count ?? 0;
  }

  Future<int> getIncorrectQuestionsCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM incorrect_answers'));
    return count ?? 0;
  }
}
