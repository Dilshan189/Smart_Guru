// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _db;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDB('repetition.db');
//     return _db!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(
//       path,
//       version: 6,
//       onCreate: _createDB,
//       onUpgrade: _upgradeDB,
//     );
//   }

//   Future<void> _createDB(Database db, int version) async {
//     /// repetitions table
//     await db.execute('''
//       CREATE TABLE repetitions (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         userId TEXT NOT NULL DEFAULT '',
//         title TEXT,
//         category TEXT,
//         score TEXT,
//         question TEXT,
//         time TEXT,
//         imagePath TEXT,
//         answer TEXT,
//         totalCount INTEGER DEFAULT 0,
//         masteredCount INTEGER DEFAULT 0
//       )
//     ''');

//     /// showanswers table
//     await db.execute('''
//       CREATE TABLE reviewQuestion (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         userId TEXT NOT NULL DEFAULT '',
//         title TEXT,
//         category TEXT,
//         score TEXT,
//         question TEXT,
//         time TEXT,
//         imagePath TEXT,
//         answer TEXT,
//         totalCount INTEGER DEFAULT 0,
//         masteredCount INTEGER DEFAULT 0
//       )
//     ''');
//   }

//   // UPGRADE TABLES

//   Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       await db.execute(
//         'ALTER TABLE repetitions ADD COLUMN totalCount INTEGER DEFAULT 0',
//       );
//       await db.execute(
//         'ALTER TABLE repetitions ADD COLUMN masteredCount INTEGER DEFAULT 0',
//       );

//       await db.execute(
//         'ALTER TABLE reviewQuestion ADD COLUMN totalCount INTEGER DEFAULT 0',
//       );
//       await db.execute(
//         'ALTER TABLE reviewQuestion ADD COLUMN masteredCount INTEGER DEFAULT 0',
//       );
//     }

//     if (oldVersion < 3) {
//       try {
//         await db.execute('ALTER TABLE repetitions ADD COLUMN answer TEXT');
//       } catch (_) {}

//       try {
//         await db.execute('ALTER TABLE reviewQuestion ADD COLUMN answer TEXT');
//       } catch (_) {}
//     }

//     if (oldVersion < 5) {
//       try {
//         await db.execute(
//           'ALTER TABLE repetitions ADD COLUMN userId TEXT DEFAULT ""',
//         );
//       } catch (_) {}

//       try {
//         await db.execute(
//           'ALTER TABLE reviewQuestion ADD COLUMN userId TEXT DEFAULT ""',
//         );
//       } catch (_) {}
//     }

//     if (oldVersion < 6) {
//       try {
//         await db.execute(
//           'UPDATE repetitions SET userId = "" WHERE userId IS NULL',
//         );
//         await db.execute(
//           'UPDATE reviewQuestion SET userId = "" WHERE userId IS NULL',
//         );
//       } catch (_) {}
//     }
//   }

//   // REPETITIONS CRUD METHODS

//   Future<int> insertRepetition(Repetition repetition) async {
//     final db = await instance.database;
//     return await db.insert(
//       'repetitions',
//       repetition.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<int> updateRepetition(Repetition repetition) async {
//     final db = await instance.database;
//     return await db.update(
//       'repetitions',
//       repetition.toMap(),
//       where: 'id = ?',
//       whereArgs: [repetition.id],
//     );
//   }

//   Future<int> deleteRepetition(String userId, String title) async {
//     final db = await instance.database;
//     return await db.delete(
//       'repetitions',
//       where: 'userId = ? AND title = ?',
//       whereArgs: [userId, title],
//     );
//   }

//   Future<int> deleteRepetitionByTitleAndQuestion(
//     String userId,
//     String title,
//     String question,
//   ) async {
//     final db = await instance.database;
//     return await db.delete(
//       'repetitions',
//       where: 'userId = ? AND title = ? AND question = ?',
//       whereArgs: [userId, title, question],
//     );
//   }

//   Future<List<Repetition>> getAllRepetitions(String userId) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'repetitions',
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return result.map((map) => Repetition.fromMap(map)).toList();
//   }

//   Future<Repetition?> getRepetitionByTitle(String userId, String title) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'repetitions',
//       where: 'userId = ? AND title = ?',
//       whereArgs: [userId, title],
//     );
//     return result.isNotEmpty ? Repetition.fromMap(result.first) : null;
//   }

//   Future<Repetition?> getRepetitionByTitleAndQuestion(
//     String userId,
//     String title,
//     String question,
//   ) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'repetitions',
//       where: 'userId = ? AND title = ? AND question = ?',
//       whereArgs: [userId, title, question],
//     );
//     return result.isNotEmpty ? Repetition.fromMap(result.first) : null;
//   }

//   Future<bool> isRepetitionSaved(String userId, String title) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'repetitions',
//       where: 'userId = ? AND title = ?',
//       whereArgs: [userId, title],
//     );
//     return result.isNotEmpty;
//   }

//   // SHOWANSWERS CRUD METHODS

//   Future<int> insertReviewAnswer(ReviewAnswer reviewAnswer) async {
//     final db = await instance.database;
//     return await db.insert(
//       'reviewQuestion',
//       reviewAnswer.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<int> updateReviewAnswer(ReviewAnswer reviewAnswer) async {
//     if (reviewAnswer.id == null) return 0; // prevent crash
//     final db = await instance.database;
//     return await db.update(
//       'reviewQuestion',
//       reviewAnswer.toMap(),
//       where: 'id = ?',
//       whereArgs: [reviewAnswer.id],
//     );
//   }

//   Future<int> deleteReviewAnswerByTitleAndQuestion(
//     String userId,
//     String title,
//     String question,
//   ) async {
//     final db = await instance.database;
//     return await db.delete(
//       'reviewQuestion',
//       where: 'userId = ? AND title = ? AND question = ?',
//       whereArgs: [userId, title, question],
//     );
//   }

//   Future<int> deleteReviewAnswerById(int id) async {
//     final db = await instance.database;
//     return await db.delete('reviewQuestion', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<List<ReviewAnswer>> getAllReviewAnswer(String userId) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'reviewQuestion',
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return result.map((map) => ReviewAnswer.fromMap(map)).toList();
//   }

//   Future<ReviewAnswer?> getReviewAnswerByTitleAndQuestion(
//     String userId,
//     String title,
//     String question,
//   ) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'reviewQuestion',
//       where: 'userId = ? AND title = ? AND question = ?',
//       whereArgs: [userId, title, question],
//     );
//     return result.isNotEmpty ? ReviewAnswer.fromMap(result.first) : null;
//   }

//   Future<bool> isReviewAnswerSaved(
//     String userId,
//     String title,
//     String question,
//   ) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'reviewQuestion',
//       where: 'userId = ? AND title = ? AND question = ?',
//       whereArgs: [userId, title, question],
//     );
//     return result.isNotEmpty;
//   }
// }
