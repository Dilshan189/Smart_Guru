// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iqapp/Databasehelper/database.helper.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../model/repetition.model.dart';
// import '../../model/ReviewQuz.dart';
// import '../../provider/user.provider.dart';
// import '../../service/api.service.dart';
// import 'level.complete.file.screen.dart';
// import 'package:vibration/vibration.dart';
// import 'package:audioplayers/audioplayers.dart';

// class QuizScreen extends StatefulWidget {
//   final String levelName;
//   final String? pQuestion;
//   final String? pParagraph;
//   final String? categoryId;
//   final String? rootCategoryId;
//   final String? levelId;
//   final String? categoryTitle;
//   final String? repetitionTitle;
//   final List<Repetition> data;
//   final List<dynamic> questions;
//   final bool isReviewQuiz;

//   const QuizScreen({
//     super.key,
//     required this.levelName,
//     this.categoryTitle,
//     this.repetitionTitle,
//     required this.questions,
//     required this.data,
//     this.pQuestion,
//     this.pParagraph,
//     this.categoryId,
//     this.rootCategoryId,
//     this.levelId,
//     this.allLevels,
//     this.currentLevelIndex,
//     this.isReviewQuiz = false,
//   });

//   final List<Map<String, dynamic>>? allLevels;
//   final int? currentLevelIndex;

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   int currentIndex = 0;
//   int? selectedAnswer;
//   bool isAnswered = false;

//   bool isSaved = false;
//   bool isEssaySaved = false;
//   int score = 0;
//   List<bool> savedStates = [];
//   final Stopwatch _stopwatch = Stopwatch();
//   final ScrollController _scrollController = ScrollController();
//   final ScrollController _numberScrollController = ScrollController();
//   final TextEditingController _reportController = TextEditingController();

//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final AudioPlayer _networkAudioPlayer = AudioPlayer();

//   final FlutterTts flutterTts = FlutterTts();
//   bool isPlayingTTS = false;
//   double ttsProgress = 0.0;
//   bool isPlayingNetworkAudio = false;
//   double networkAudioProgress = 0.0;
//   String? _currentAudioUrl;

//   Duration _audioDuration = Duration.zero;
//   Duration _audioPosition = Duration.zero;
//   StreamSubscription? _audioDurationSub;
//   StreamSubscription? _audioPositionSub;
//   StreamSubscription? _audioCompleteSub;

//   bool showParagraphMode = false;

//   /// API-loaded questions and paragraph

//   List<Map<String, dynamic>> _apiQuestions = [];
//   String? _fetchedPQuestion;
//   bool _isFetching = false;
//   bool _hasParagraph = false;

//   List<Map<String, dynamic>> get _questions => widget.questions.isNotEmpty
//       ? widget.questions.cast<Map<String, dynamic>>()
//       : _apiQuestions;

//   /// api service fetch

//   List<dynamic> questions = [];
//   bool isLoading = true;

//   /// Time add------------------------------------------------------------------

//   Timer? _timer;
//   int remainingSeconds = 30;
//   int elapsedSeconds = 0;
//   List<int?> selectedAnswers = [];

//   /// timer--------------------------------------------------------------------

//   String _getUserId() {
//     try {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       String? id = userProvider.userId?.toString();

//       if (id == null || id.isEmpty) {
//         final storage = GetStorage();
//         id = storage.read("user_id")?.toString();
//       }

//       return id ?? "";
//     } catch (e) {
//       if (kDebugMode) print('[Quiz][getUserId] Error: $e');
//       final storage = GetStorage();
//       return storage.read("user_id")?.toString() ?? "";
//     }
//   }

//   /// get token user register list

//   String _getToken() {
//     try {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       String? token = userProvider.token;

//       if (token == null || token.isEmpty) {
//         final storage = GetStorage();
//         token = storage.read("token")?.toString();
//       }

//       return token ?? "";
//     } catch (e) {
//       if (kDebugMode) print('[Quiz][getToken] Error: $e');
//       final storage = GetStorage();
//       return storage.read("token")?.toString() ?? "";
//     }
//   }

//   String _getSavedKey(int index) {
//     final String userId = _getUserId();
//     final String titleKey = _titleKey();
//     // Include levelId or levelName to ensure uniqueness across levels
//     final String uniqueLevelIdentifier =
//         widget.levelId ?? widget.levelName.replaceAll(' ', '_');

//     if (userId.isEmpty) {
//       return 'quiz_saved_${titleKey}_${uniqueLevelIdentifier}_question_$index';
//     } else {
//       return 'quiz_saved_${userId}_${titleKey}_${uniqueLevelIdentifier}_question_$index';
//     }
//   }

//   String _getEssayKey(int hash) {
//     final String userId = _getUserId();
//     final String titleKey = _titleKey();
//     if (userId.isEmpty) {
//       return 'quiz_saved_essay_${titleKey}_$hash';
//     } else {
//       return 'quiz_saved_essay_${userId}_${titleKey}_$hash';
//     }
//   }

//   /// Helper to get paragraph text

//   String _getParagraphText() {
//     return (widget.pParagraph ?? '').isNotEmpty
//         ? widget.pParagraph!
//         : (_fetchedPQuestion ?? '');
//   }

//   Future<void> _checkEssaySavedState() async {
//     final String paragraph = _getParagraphText();
//     if (paragraph.isEmpty) return;

//     final String userId = _getUserId();
//     final prefs = await SharedPreferences.getInstance();
//     final String key = _getEssayKey(paragraph.hashCode);
//     final bool savedInPrefs = prefs.getBool(key) ?? false;

//     if (kDebugMode) {
//       print('[Quiz][_checkEssay] key=$key savedInPrefs=$savedInPrefs');
//     }

//     if (savedInPrefs) {
//       if (mounted) {
//         setState(() {
//           isEssaySaved = true;
//         });
//       }
//       return;
//     }

//     final String title = _repetitionTitleToUse();
//     final existing = await DatabaseHelper.instance
//         .getRepetitionByTitleAndQuestion(userId, title, paragraph);

//     if (mounted) {
//       setState(() {
//         isEssaySaved = existing != null;
//       });
//       if (isEssaySaved) {
//         await prefs.setBool(key, true);
//       }
//     }
//   }

//   Future<void> _toggleSaveForEssay() async {
//     final String paragraph = _getParagraphText();
//     if (paragraph.isEmpty) return;

//     final String userId = _getUserId();
//     final prefs = await SharedPreferences.getInstance();
//     final String key = _getEssayKey(paragraph.hashCode);

//     final String title = _repetitionTitleToUse();
//     final existing = await DatabaseHelper.instance
//         .getRepetitionByTitleAndQuestion(userId, title, paragraph);

//     if (kDebugMode) {
//       print('[Quiz][_toggleEssay] key=$key existing=${existing != null}');
//     }

//     if (existing != null) {
//       // Remove
//       await DatabaseHelper.instance.deleteRepetitionByTitleAndQuestion(
//         userId,
//         title,
//         paragraph,
//       );
//       await prefs.setBool(key, false);
//       if (mounted) {
//         setState(() {
//           isEssaySaved = false;
//         });
//       }
//     } else {
//       // Add grouped essay
//       final repetition = Repetition(
//         userId: userId,
//         title: title,
//         category: widget.categoryTitle ?? widget.levelName ?? 'Essay',
//         question: paragraph,
//         answer: jsonEncode(_questions),
//         score: '0',
//         time: DateTime.now().toIso8601String(),
//         masteredCount: 0,
//       );

//       await DatabaseHelper.instance.insertRepetition(repetition);
//       await prefs.setBool(key, true);
//       setState(() {
//         isEssaySaved = true;
//       });
//     }
//   }

//   void _startTimer({bool reset = true}) {
//     _timer?.cancel();

//     bool isPaperQuizCategory = _isPaperQuizCategory();
//     bool isIntelligenceTest =
//         widget.repetitionTitle?.contains("බුද්ධි පරීක්ෂණ") ?? false;

//     if (reset) {
//       setState(() {
//         if (isPaperQuizCategory) {
//           remainingSeconds = 6600;
//           elapsedSeconds = 0;
//         } else if (isIntelligenceTest) {
//           elapsedSeconds = 0;
//           remainingSeconds = 0;
//         } else {
//           remainingSeconds = 30;
//           elapsedSeconds = 0;
//         }
//       });
//     }

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       bool isIntelligenceTest =
//           widget.repetitionTitle?.contains("බුද්ධි පරීක්ෂණ") ?? false;
//       bool isPaperQuizCategory = _isPaperQuizCategory();

//       if (isIntelligenceTest) {
//         setState(() {
//           elapsedSeconds++;
//         });
//       } else if (isPaperQuizCategory) {
//         if (remainingSeconds > 0) {
//           setState(() {
//             remainingSeconds--;
//           });
//         } else {
//           timer.cancel();
//           setState(() {
//             isAnswered = true;
//           });

//           await playSound("wrong");
//           if (await Vibration.hasVibrator()) {
//             Vibration.vibrate(duration: 300);
//           }

//           Future.delayed(const Duration(milliseconds: 1000), () {
//             _onCheckOrNext();
//           });
//         }
//       } else {
//         if (remainingSeconds > 0) {
//           setState(() {
//             remainingSeconds--;
//           });
//         } else {
//           timer.cancel();
//           setState(() {
//             isAnswered = true;
//           });

//           await playSound("wrong");
//           if (await Vibration.hasVibrator()) {
//             Vibration.vibrate(duration: 300);
//           }

//           Future.delayed(const Duration(milliseconds: 1000), () {
//             if (widget.repetitionTitle == 'සාමාන්‍ය දැනුම') {
//               _onCheckOrNext();
//             }
//           });
//         }
//       }
//     });
//   }

//   /// Check if the current category is a PaperQuiz category-------------------------------

//   bool _isPaperQuizCategory() {
//     if (_hasParagraph) return true;
//     final String title = (widget.categoryTitle ?? '').toLowerCase().trim();

//     final paperCategories = [
//       'නව',
//       'ග්‍රාම නිලධාරී',
//       'කළමනාකරණ සහකාර',
//       'ගුරු විභාග',
//       'තරකනය',
//     ].map((s) => s.toLowerCase().trim()).toList();

//     final bool isRepetitionPractice =
//         (widget.repetitionTitle ?? '').toLowerCase().trim() == title &&
//         _questions.isNotEmpty;

//     final bool matchesPaperList =
//         title.isNotEmpty &&
//         paperCategories.any((pc) => title.contains(pc) || pc.contains(title));

//     return matchesPaperList || isRepetitionPractice;
//   }

//   /// Checks fetched API flag, category title and level name for the keyword.

//   bool _levelHasParagraph() {
//     final cat = (widget.categoryTitle ?? '').toLowerCase().trim();
//     final lvl = (widget.levelName ?? '').toLowerCase().trim();

//     return _hasParagraph ||
//         cat.contains('paragraph') ||
//         lvl.contains('paragraph') ||
//         cat.contains('තරකනය') ||
//         lvl.contains('තරකනය');
//   }

//   /// check the next button---------------------------------------------------------

//   Future<void> _restartQuiz() async {
//     await _stopAudio();
//     setState(() {
//       currentIndex = 0;
//       score = 0;
//       isAnswered = false;
//       selectedAnswer = null;
//       selectedAnswers = List<int?>.filled(_questions.length, null);
//       _stopwatch.reset();
//       _stopwatch.start();
//     });
//     _startTimer();
//     _loadButtonState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   Future<void> _onCheckOrNext() async {
//     bool isIntelligenceTest =
//         widget.repetitionTitle?.contains("බුද්ධි පරීක්ෂණ") ?? false;

//     if (isIntelligenceTest) {
//       _timer?.cancel();
//     }

//     if (_questions.isEmpty || _isFetching) {
//       _timer?.cancel();

//       if (widget.isReviewQuiz) {
//         Navigator.pop(context, widget.data);
//       } else {
//         final levelsList = widget.allLevels ?? [];
//         final currentLvlIdx = widget.currentLevelIndex ?? 0;

//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LevelComplete(
//               correctAnswers: score,
//               incorrectAnswers: 0,
//               timeTaken: _stopwatch.elapsed,
//               currentLevelIndex: currentLvlIdx,
//               allLevels: levelsList,
//               isReviewQuiz: widget.isReviewQuiz,
//               catrgoryTitle: widget.categoryTitle,
//               categoryId: widget.categoryId,
//               rootCategoryId: widget.rootCategoryId,
//               levelId: widget.levelId,
//             ),
//           ),
//         );

//         if (result == 'restart') {
//           _restartQuiz();
//         } else if (result == 'next_level') {
//           if ((currentLvlIdx + 1) < levelsList.length) {
//             final nextIndex = currentLvlIdx + 1;
//             final nextLevel = levelsList[nextIndex];

//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => QuizScreen(
//                   levelName: nextLevel["level"] ?? "",
//                   categoryTitle: widget.categoryTitle,
//                   repetitionTitle: widget.repetitionTitle,
//                   questions: nextLevel["questions"] ?? [],
//                   data: [],
//                   pQuestion: nextLevel["pQuestion"],
//                   pParagraph: nextLevel["pParagraph"],
//                   categoryId:
//                       nextLevel["cat_id"]?.toString() ?? widget.categoryId,
//                   rootCategoryId: widget.rootCategoryId,
//                   levelId: nextLevel["level_id"]?.toString(),
//                   allLevels: levelsList,
//                   currentLevelIndex: nextIndex,
//                   isReviewQuiz: false,
//                 ),
//               ),
//             );
//           } else {
//             Navigator.pop(context, result);
//           }
//         } else if (result == 'exit') {
//           Navigator.pop(context, result);
//         }
//       }
//       return;
//     }

//     final question = _questions[currentIndex];
//     final int correctAnswerIndex = question['correctAnswerIndex'] ?? -1;

//     if (!isAnswered) {
//       /// Check pressed --------------------
//       setState(() {
//         isAnswered = true;
//         selectedAnswers[currentIndex] = selectedAnswer;
//         if (selectedAnswer == correctAnswerIndex) {
//           score++;
//           _insertShowAnswerData();
//         } else {
//           _removeFromMasteredList();
//         }
//       });

//       Future.delayed(const Duration(milliseconds: 500), () {
//         final explanation = question['explanation']?.toString() ?? '';
//         final explanationImage = question['explanationImage']?.toString() ?? '';
//         final exampleAudio = question['exampleAudio']?.toString() ?? '';

//         if (explanation.isNotEmpty ||
//             explanationImage.isNotEmpty ||
//             exampleAudio.isNotEmpty) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//       });

//       if (selectedAnswer == correctAnswerIndex) {
//         await playSound("correctAnswer");
//       } else {
//         await playSound("wrong");
//         if (await Vibration.hasVibrator()) {
//           Vibration.vibrate(duration: 300);
//         }
//       }
//     } else {
//       /// Next pressed -------------------------
//       if (currentIndex < _questions.length - 1) {
//         await _stopAudio();
//         setState(() {
//           currentIndex++;
//           selectedAnswer = null;
//           isAnswered = false;
//           showParagraphMode = false;
//         });
//         _loadButtonState();
//         _startTimer();
//         _scrollToCurrentNumber();
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollController.animateTo(
//             0,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         });
//       } else {
//         /// Quiz finished --------------------------
//         _timer?.cancel();

//         final levelsList = widget.allLevels ?? [];
//         final currentLvlIdx = widget.currentLevelIndex ?? 0;

//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LevelComplete(
//               correctAnswers: score,
//               incorrectAnswers: _questions.length - score,
//               timeTaken: _stopwatch.elapsed,
//               currentLevelIndex: currentLvlIdx,
//               allLevels: levelsList,
//               isReviewQuiz: widget.isReviewQuiz,
//               catrgoryTitle: widget.categoryTitle,
//               categoryId: widget.categoryId,
//               rootCategoryId: widget.rootCategoryId,
//               levelId: widget.levelId,
//             ),
//           ),
//         );

//         if (result == 'restart') {
//           _restartQuiz();
//         } else if (result == 'next_level') {
//           if ((currentLvlIdx + 1) < levelsList.length) {
//             final nextIndex = currentLvlIdx + 1;
//             final nextLevel = levelsList[nextIndex];

//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => QuizScreen(
//                   levelName: nextLevel["level"] ?? "",
//                   categoryTitle: widget.categoryTitle,
//                   repetitionTitle: widget.repetitionTitle,
//                   questions: nextLevel["questions"] ?? [],
//                   data: [],
//                   pQuestion: nextLevel["pQuestion"],
//                   pParagraph: nextLevel["pParagraph"],
//                   categoryId:
//                       nextLevel["cat_id"]?.toString() ?? widget.categoryId,
//                   rootCategoryId: widget.rootCategoryId,
//                   levelId: nextLevel["level_id"]?.toString(),
//                   allLevels: levelsList,
//                   currentLevelIndex: nextIndex,
//                   isReviewQuiz: false,
//                 ),
//               ),
//             );
//           } else {
//             Navigator.pop(context, result);
//           }
//         } else if (result == 'exit' || result == 'review_complete') {
//           Navigator.pop(context, result);
//         }
//       }
//     }
//   }

//   /// sound track add-------------------------------------------------------------------------------

//   Future<void> playSound(String type) async {
//     try {
//       if (type == "correctAnswer") {
//         await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
//       } else {
//         await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error playing sound: $e');
//       }
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   /// Stop audio and reset state

//   Future<void> _stopAudio() async {
//     await _networkAudioPlayer.stop();
//     _audioDurationSub?.cancel();
//     _audioPositionSub?.cancel();
//     _audioCompleteSub?.cancel();

//     if (mounted) {
//       setState(() {
//         isPlayingNetworkAudio = false;
//         networkAudioProgress = 0.0;
//         _audioPosition = Duration.zero;
//       });
//     }
//   }

//   /// Play or stop network audio for the question explanation

//   Future<void> _toggleNetworkAudio(String? audioPath) async {
//     if (audioPath == null || audioPath.trim().isEmpty) return;

//     final String a = audioPath.trim();
//     final String url = a.toLowerCase().startsWith('https')
//         ? a
//         : 'https://smartiq.ideacipher.com/upload/audio/${a.startsWith('/') ? a.substring(1) : a}';

//     /// Stop TTS if running

//     if (isPlayingTTS) {
//       await flutterTts.stop();
//       setState(() {
//         isPlayingTTS = false;
//         ttsProgress = 0.0;
//       });
//     }

//     /// Check if we are interacting with the same URL

//     if (_currentAudioUrl == url) {
//       if (isPlayingNetworkAudio) {
//         await _networkAudioPlayer.pause();
//         setState(() {
//           isPlayingNetworkAudio = false;
//         });
//       } else {
//         if ((_audioPosition >= _audioDuration ||
//                 _audioPosition == Duration.zero) &&
//             _audioDuration != Duration.zero) {
//           await _networkAudioPlayer.play(UrlSource(url));
//         } else {
//           await _networkAudioPlayer.resume();
//         }

//         setState(() {
//           isPlayingNetworkAudio = true;
//         });
//       }
//       return;
//     }

//     await _stopAudio();
//     _currentAudioUrl = url;

//     try {
//       _audioCompleteSub = _networkAudioPlayer.onPlayerComplete.listen((_) {
//         if (mounted) {
//           setState(() {
//             isPlayingNetworkAudio = false;
//             networkAudioProgress = 0.0;
//             _audioPosition = Duration.zero;
//           });
//         }
//       });

//       _audioDurationSub = _networkAudioPlayer.onDurationChanged.listen((d) {
//         if (mounted) {
//           setState(() {
//             _audioDuration = d;
//           });
//         }
//       });

//       _audioPositionSub = _networkAudioPlayer.onPositionChanged.listen((p) {
//         if (mounted) {
//           setState(() {
//             _audioPosition = p;
//             networkAudioProgress = (_audioDuration.inMilliseconds > 0)
//                 ? p.inMilliseconds / _audioDuration.inMilliseconds
//                 : 0.0;
//           });
//         }
//       });

//       /// Start playing
//       await _networkAudioPlayer.play(UrlSource(url));
//       setState(() {
//         isPlayingNetworkAudio = true;
//       });
//     } catch (e) {
//       if (kDebugMode) print('Failed to play network audio $url: $e');
//       await _stopAudio();
//     }
//   }

//   /// check button , next and next question---------------------------------------------------------------

//   String _getButtonText() {
//     final bool isParagraphCategory = _levelHasParagraph();

//     if (showParagraphMode) {
//       return "Go to Question";
//     }

//     if (widget.isReviewQuiz) {
//       return "Check";
//     }

//     if (isParagraphCategory) {
//       return "Next";
//     }

//     if (widget.repetitionTitle == 'සාමාන්‍ය දැනුම') {
//       return "Next Question";
//     }

//     if (!isAnswered) {
//       return "Check";
//     } else {
//       return "Next";
//     }
//   }

//   /// Load the state of the save button from SharedPreferences---------------------------------------------------

//   Future<void> _loadButtonState() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String userId = _getUserId();
//     final String key = _getSavedKey(currentIndex);
//     final savedState = prefs.getBool(key) ?? false;

//     final String titleToUse = _repetitionTitleToUse();
//     final String questionText = _questions[currentIndex]['question'] ?? '';

//     final existingRepetition = await DatabaseHelper.instance
//         .getRepetitionByTitleAndQuestion(userId, titleToUse, questionText);

//     final resolvedSaved = savedState || (existingRepetition != null);

//     if (kDebugMode) {
//       print(
//         '[Quiz][_loadState] key=$key savedState=$savedState inDB=${existingRepetition != null}',
//       );
//     }

//     if (currentIndex >= 0 && currentIndex < savedStates.length) {
//       savedStates[currentIndex] = resolvedSaved;
//     }

//     setState(() {
//       isSaved = resolvedSaved;
//     });
//   }

//   /// via the title fallback logic------------------------------------------------------------------------

//   Future<void> _loadAllButtonStates() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String userId = _getUserId();

//     for (int i = 0; i < _questions.length; i++) {
//       final String key = _getSavedKey(i);
//       final savedState = prefs.getBool(key) ?? false;

//       final String titleToUse = _repetitionTitleToUse();
//       final String questionText = _questions[i]['question'] ?? '';

//       final existingRepetition = await DatabaseHelper.instance
//           .getRepetitionByTitleAndQuestion(userId, titleToUse, questionText);

//       final resolvedSaved = savedState || (existingRepetition != null);

//       if (i >= 0 && i < savedStates.length) {
//         savedStates[i] = resolvedSaved;
//       }
//     }

//     setState(() {
//       if (currentIndex >= 0 && currentIndex < savedStates.length) {
//         isSaved = savedStates[currentIndex];
//       }
//     });

//     if (kDebugMode) {
//       print('[Quiz][_loadAllStates] count=${_questions.length} userId=$userId');
//     }
//   }

//   /// Returns a normalized title key used for SharedPreferences keys

//   String _titleKey() {
//     return _repetitionTitleToUse().replaceAll(' ', '_');
//   }

//   String _repetitionTitleToUse() {
//     return (widget.repetitionTitle?.isNotEmpty == true
//             ? widget.repetitionTitle!
//             : (widget.categoryTitle ?? widget.levelName ?? ''))
//         .trim();
//   }

//   int _firstUnansweredIndex() {
//     if (selectedAnswers.isEmpty) return 0;
//     final int idx = selectedAnswers.indexWhere((a) => a == null);
//     return idx != -1 ? idx : 0;
//   }

//   /// Toggle save for the current question and persist to SharedPreferences + DB

//   Future<void> _toggleSaveForCurrentQuestion() async {
//     final String userId = _getUserId();
//     final prefs = await SharedPreferences.getInstance();

//     // Ensure savedStates is large enough
//     if (currentIndex < 0) return;
//     if (currentIndex >= savedStates.length) {
//       final needed = currentIndex - savedStates.length + 1;
//       savedStates.addAll(List<bool>.filled(needed, false));
//     }

//     setState(() {
//       savedStates[currentIndex] = !savedStates[currentIndex];
//       isSaved = savedStates[currentIndex];
//     });

//     final key = _getSavedKey(currentIndex);
//     if (kDebugMode) {
//       print(
//         '[Quiz][_toggleSave] prefsKey=$key saved=${savedStates[currentIndex]} index=$currentIndex userId=$userId',
//       );
//     }
//     await prefs.setBool(key, savedStates[currentIndex]);

//     final question = _questions[currentIndex];
//     final String questionText = question['question'] ?? '';
//     final String correctAnswer = question['correctAnswer'] ?? '';
//     final List options = List.from(question['options'] ?? []);

//     /// Create a JSON string containing both options and correct answer

//     final Map<String, dynamic> answerData = {
//       'options': options,
//       'correctAnswer': correctAnswer,
//       'explanation': question['explanation'] ?? '',
//       'exampleAudio': question['exampleAudio'] ?? '',
//       'exampleImage': question['explanationImage'] ?? '',
//       'questionImage': question['questionImage'] ?? '',
//     };
//     final String answerJson = jsonEncode(answerData);

//     final String repetitionTitle = _repetitionTitleToUse();

//     final existing = await DatabaseHelper.instance
//         .getRepetitionByTitleAndQuestion(userId, repetitionTitle, questionText);

//     if (savedStates[currentIndex]) {
//       final repetition = Repetition(
//         id: existing?.id,
//         userId: userId,
//         title: repetitionTitle,
//         category: "Quiz",
//         question: questionText,
//         answer: answerJson,
//         score: score.toString(),
//         time: DateTime.now().toIso8601String(),
//         totalCount: _questions.length,
//         masteredCount: score,
//       );

//       if (existing != null) {
//         await DatabaseHelper.instance.updateRepetition(repetition);
//       } else {
//         await DatabaseHelper.instance.insertRepetition(repetition);
//       }
//     } else {
//       await DatabaseHelper.instance.deleteRepetitionByTitleAndQuestion(
//         userId,
//         repetitionTitle,
//         questionText,
//       );
//     }

//     setState(() {});
//   }

//   /// Insert data to showanswers table when correct answer is clicked in review quiz

//   Future<void> _insertShowAnswerData() async {
//     if (!widget.isReviewQuiz) return;

//     final String userId = _getUserId();
//     final question = _questions[currentIndex];
//     final String questionText = question['question'] ?? '';
//     final String correctAnswer = question['correctAnswer'] ?? '';
//     final List options = List.from(question['options'] ?? []);

//     final Map<String, dynamic> answerData = {
//       'options': options,
//       'correctAnswer': correctAnswer,
//       'explanation': question['explanation'] ?? '',
//       'exampleAudio': question['exampleAudio'] ?? '',
//       'exampleImage': question['explanationImage'] ?? '',
//       'questionImage': question['questionImage'] ?? '',
//     };
//     final String answerJson = jsonEncode(answerData);

//     final String repetitionTitle = _repetitionTitleToUse();
//     if (kDebugMode) {
//       print(
//         '[Quiz][_insertShowAnswerData] repetitionTitle=$repetitionTitle question=$questionText',
//       );
//     }

//     final existing = await DatabaseHelper.instance
//         .getReviewAnswerByTitleAndQuestion(
//           userId,
//           repetitionTitle,
//           questionText,
//         );

//     final reviewAnswer = ReviewAnswer(
//       id: existing?.id,
//       userId: userId,
//       title: repetitionTitle,
//       category: "ReviewQuiz",
//       question: questionText,
//       answer: answerJson,
//       imagePath: question['questionImage'] ?? '',
//       score: "1",
//       time: DateTime.now().toIso8601String(),
//       masteredCount: 1,
//     );

//     if (existing != null) {
//       await DatabaseHelper.instance.updateReviewAnswer(reviewAnswer);
//     } else {
//       if (kDebugMode) {
//         print("object: $answerData");
//       }
//       await DatabaseHelper.instance.insertReviewAnswer(reviewAnswer);
//     }
//   }

//   /// Remove the current question from the mastered list

//   Future<void> _removeFromMasteredList() async {
//     if (!widget.isReviewQuiz) return;

//     final question = _questions[currentIndex];
//     final String questionText = question['question'] ?? '';

//     try {
//       widget.data.removeWhere((r) => r.question == questionText);
//     } catch (e) {
//       if (kDebugMode) print('Error removing from in-memory mastered list: $e');
//     }

//     final String userId = _getUserId();
//     final String repetitionTitle = _repetitionTitleToUse();
//     if (kDebugMode) {
//       print(
//         '[Quiz][_removeFromMasteredList] repetitionTitle=$repetitionTitle question=$questionText',
//       );
//     }

//     try {
//       await DatabaseHelper.instance.deleteReviewAnswerByTitleAndQuestion(
//         userId,
//         repetitionTitle,
//         questionText,
//       );
//     } catch (e) {
//       if (kDebugMode) print('Error deleting mastered entry from DB: $e');
//     }

//     /// Refresh UI
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   /// Dialog msg app bar in  stop icon---------------------------------------------------------------

//   Future<void> _showReportDialog() async {
//     _timer?.cancel();
//     String? reportError;

//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         final screenWidth = MediaQuery.of(context).size.width;

//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               insetPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 24,
//               ),
//               child: SingleChildScrollView(
//                 child: Container(
//                   padding: const EdgeInsets.all(25),
//                   width: screenWidth * 0.9,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Report Question",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Poppins',
//                           fontSize: 20.01,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       const Text(
//                         "m%Yakfha jrola we;skï tA nj wmsg oekqj;a lrkak'",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontFamily: 'Malithi',
//                           fontSize: 10.84,
//                         ),
//                       ),
//                       const SizedBox(height: 15),

//                       TextField(
//                         controller: _reportController,
//                         maxLines: 5,
//                         textAlignVertical: TextAlignVertical.top,
//                         onChanged: (value) {
//                           if (reportError != null) {
//                             setState(() {
//                               reportError = null;
//                             });
//                           }
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Type your message here',
//                           hintStyle: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.grey,
//                           ),
//                           errorText: reportError,
//                           errorStyle: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 12,
//                           ),
//                           filled: true,
//                           fillColor: const Color(0xFFF5F5F5),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.84),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.84),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.84),
//                             borderSide: BorderSide.none,
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.84),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.84),
//                             borderSide: const BorderSide(color: Colors.red),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: const Color(0xFFF46934),
//                                 minimumSize: const Size(0, 45),
//                                 side: const BorderSide(
//                                   color: Color(0xFFF46934),
//                                   width: 0.5,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontSize: 14.39,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFFF25A0A),
//                                 foregroundColor: Colors.white,
//                                 minimumSize: const Size(0, 45),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 final String reason = _reportController.text
//                                     .trim();
//                                 if (reason.isEmpty) {
//                                   setState(() {
//                                     reportError = "Please enter a message";
//                                   });
//                                   return;
//                                 }

//                                 final String qId =
//                                     _questions[currentIndex]['id']
//                                         ?.toString() ??
//                                     "";
//                                 final String token = _getToken();

//                                 if (qId.isEmpty) {
//                                   setState(() {
//                                     reportError = "Question ID not found";
//                                   });
//                                   return;
//                                 }

//                                 // Show loading or just proceed
//                                 final result = await IQService.reportQuestion(
//                                   questionId: qId,
//                                   reason: reason,
//                                   token: token,
//                                 );

//                                 if (mounted) {
//                                   Navigator.pop(context);
//                                   if (result["success"] == true) {
//                                     _reportController.clear();
//                                     Fluttertoast.showToast(
//                                       msg: "Report submitted successfully.",
//                                       toastLength: Toast.LENGTH_LONG,
//                                       gravity: ToastGravity.SNACKBAR,
//                                       backgroundColor: Colors.black87,
//                                       textColor: Colors.white,
//                                       fontSize: 14,
//                                     );
//                                   } else {
//                                     Fluttertoast.showToast(
//                                       msg:
//                                           result["message"] ??
//                                           "Failed to submit report.",
//                                       toastLength: Toast.LENGTH_LONG,
//                                       gravity: ToastGravity.SNACKBAR,
//                                       backgroundColor: Colors.redAccent,
//                                       textColor: Colors.white,
//                                       fontSize: 14,
//                                     );
//                                   }
//                                 }
//                               },
//                               child: const Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontSize: 14.39,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//     _startTimer(reset: false);
//   }

//   ///  model bottom sheet--------------------------------------------------------------------

//   void _modalBottomSheetMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: Container(
//             height: 553,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 40),

//                 Stack(
//                   alignment: Alignment.center,
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       width: 138,
//                       height: 196,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Color(0xFFFF7E00), Color(0xFFF54A01)],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: -1,
//                       bottom: -1,
//                       child: Image.asset(
//                         'assets/images/Image.png',
//                         width: 207,
//                         height: 210,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 Text(
//                   "Are you sure want\n to quit?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFFFF6901),
//                   ),
//                 ),

//                 const SizedBox(height: 35),

//                 SizedBox(
//                   width: 280,
//                   height: 59,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF6901),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       "Yes",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 15),

//                 SizedBox(
//                   width: 280,
//                   height: 59,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(
//                         color: Color(0xFFFF6901),
//                         width: 1,
//                       ),
//                       foregroundColor: const Color(0xFFFF6901),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       "No",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Navigate to the previous question--------------------------------------------------------------

//   Future<void> _goToPreviousQuestion() async {
//     if (currentIndex > 0) {
//       await _stopAudio();
//       setState(() {
//         currentIndex--;
//         selectedAnswer = selectedAnswers[currentIndex];
//         isAnswered = selectedAnswer != null;
//         showParagraphMode = false;
//       });
//       _loadButtonState();

//       _scrollToCurrentNumber();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       });
//     }
//   }

//   /// Navigate to the next question--------------------------------------------------------------------

//   Future<void> _goToNextQuestion() async {
//     if (currentIndex < _questions.length - 1) {
//       await _stopAudio();
//       setState(() {
//         currentIndex++;
//         selectedAnswer = selectedAnswers[currentIndex];
//         isAnswered = selectedAnswer != null;
//         showParagraphMode = false;
//       });
//       _loadButtonState();
//       _scrollToCurrentNumber();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       });
//       _scrollToCurrentNumber();
//     }
//   }

//   void _scrollToCurrentNumber() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_numberScrollController.hasClients) {
//         double itemWidth = 57.41;
//         int indexToScroll = currentIndex;

//         if (_levelHasParagraph()) {
//           indexToScroll += 1;
//         }

//         double targetOffset = (indexToScroll * itemWidth);
//         double currentOffset = _numberScrollController.offset;
//         double viewportWidth =
//             _numberScrollController.position.viewportDimension;

//         // Only scroll if the target is outside the visible area
//         if (targetOffset < currentOffset ||
//             targetOffset > (currentOffset + viewportWidth - itemWidth)) {
//           _numberScrollController.animateTo(
//             (targetOffset - (viewportWidth / 2) + (itemWidth / 2)).clamp(
//               0,
//               _numberScrollController.position.maxScrollExtent,
//             ),
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     /// Debug print to see what categoryTitle is received
//     if (kDebugMode) {
//       print(
//         "QuizScreen initState - repetitionTitle: ${widget.repetitionTitle}, categoryId: ${widget.categoryId}, providedQuestions: ${widget.questions.length}",
//       );
//     }

//     /// Initialize the selectedAnswers list
//     selectedAnswers = List<int?>.filled(
//       _questions.isNotEmpty ? _questions.length : 1,
//       null,
//     );

//     /// Initialize savedStates list first, then load their real values
//     savedStates = List<bool>.filled(
//       _questions.isNotEmpty ? _questions.length : 1,
//       false,
//     );

//     /// Load saved states for all questions
//     _loadAllButtonStates();
//     _startTimer();
//     _stopwatch.start();

//     /// text to speech
//     flutterTts.setLanguage("en-US");
//     flutterTts.setSpeechRate(0.9);
//     flutterTts.setPitch(1.0);
//     flutterTts.setVolume(1.0);

//     if ((widget.pQuestion != null && widget.pQuestion!.isNotEmpty) ||
//         (widget.pParagraph != null && widget.pParagraph!.isNotEmpty)) {
//       showParagraphMode = true;
//       _hasParagraph = true;
//       _checkEssaySavedState();
//     }

//     fetchQuestion();
//   }

//   ///  fetch Question -----------------------------------------------------------------------

//   Future<void> fetchQuestion() async {
//     if (widget.questions.isNotEmpty) {
//       await _loadAllButtonStates();
//       return;
//     }

//     final catId = widget.categoryId;
//     final levelId = widget.levelId ?? "";

//     if (catId == null || catId.isEmpty) return;

//     setState(() {
//       _isFetching = true;
//     });

//     /// fetch question in api ----------------------------------------------------------------------------

//     final token = _getToken();
//     final payload = await IQService.fetchQuestion(catId, levelId, token);

//     if (kDebugMode) {
//       print('fetchQuestion: received payload type=${payload.runtimeType}');
//       print('fetchQuestion: payload=\n$payload');
//     }

//     List<dynamic> rawQuestions = [];
//     String? fetchedParagraph;
//     bool hasParagraph = false;

//     if (payload is Map) {
//       if (payload['questions'] is List) rawQuestions = payload['questions'];
//       if (payload['paragraphs'] is List && payload['paragraphs'].isNotEmpty) {
//         String longestPara = '';
//         for (var p in payload['paragraphs']) {
//           if (p is Map) {
//             final text = p['paragraph_text']?.toString() ?? '';
//             if (text.length > longestPara.length) {
//               longestPara = text;
//             }
//           }
//         }
//         fetchedParagraph = longestPara;
//       } else if (payload['paragraph_text'] != null) {
//         fetchedParagraph = payload['paragraph_text']?.toString() ?? '';
//       }

//       /// Treat any common truthy value as indicating a paragraph exists

//       final dynamic hp = payload['has_paragraph'];
//       if (hp == true ||
//           hp == 1 ||
//           hp == '1' ||
//           (hp is String && hp.toLowerCase() == 'true')) {
//         hasParagraph = true;
//       }
//     } else if (payload is List) {
//       rawQuestions = payload;
//       if (payload.isNotEmpty && payload[0] is Map) {
//         if (payload[0]['paragraph_text'] != null) {
//           fetchedParagraph = payload[0]['paragraph_text']?.toString() ?? '';
//         }

//         final dynamic hp = payload[0]['has_paragraph'];
//         if (hp == true ||
//             hp == 1 ||
//             hp == '1' ||
//             (hp is String && hp.toLowerCase() == 'true')) {
//           hasParagraph = true;
//         }
//       }
//     }

//     if (kDebugMode) {
//       print('fetchQuestion: rawQuestions.length=${rawQuestions.length}');
//     }

//     final List<Map<String, dynamic>> mapped = [];

//     for (final q in rawQuestions) {
//       if (q is Map) {
//         final List<Map<String, String>> options = [];

//         for (int i = 1; i <= 5; i++) {
//           String ans = q['ans_0$i']?.toString().trim() ?? '';
//           String img = q['ans_0${i}_img']?.toString().trim() ?? '';

//           // Logic to handle cases where image filename is in the text field (ans_0x)
//           if (img.isEmpty && ans.isNotEmpty) {
//             final lowerAns = ans.toLowerCase();
//             if (lowerAns.endsWith('.png') ||
//                 lowerAns.endsWith('.jpg') ||
//                 lowerAns.endsWith('.jpeg') ||
//                 lowerAns.endsWith('.gif')) {
//               img = ans;
//               ans = ''; // Clear text so it doesn't show "img1.png" as a label
//             }
//           }

//           if (ans.isNotEmpty || img.isNotEmpty) {
//             options.add({'text': ans, 'image': img});
//           }
//         }

//         /// Determine correct answer text---------------------------------------------------

//         String correctAnswer = '';
//         final cur = q['current_ans']?.toString() ?? '';
//         final curIdx = int.tryParse(cur);
//         if (curIdx != null && curIdx >= 1 && curIdx <= options.length) {
//           correctAnswer = options[curIdx - 1]['text'] ?? '';
//         }

//         mapped.add({
//           'id': q['id'],
//           'question': q['question'] ?? '',
//           'questionImage': q['question_img'] ?? '',
//           'options': options,
//           'correctAnswer': correctAnswer,
//           'correctAnswerIndex': (curIdx != null && curIdx >= 1)
//               ? curIdx - 1
//               : -1,
//           'explanation': q['example_text'] ?? '',
//           'explanationImage': q['example_img'] ?? '',
//           'exampleAudio': q['example_audio'] ?? '',
//           'paragraphText': q['paragraph_text'] ?? '',
//         });
//       }
//     }

//     setState(() {
//       _apiQuestions = mapped;
//       _fetchedPQuestion = fetchedParagraph;
//       _isFetching = false;
//       _hasParagraph = hasParagraph;

//       selectedAnswers = List<int?>.filled(mapped.length, null);
//       savedStates = List<bool>.filled(mapped.length, false);
//     });

//     if (_hasParagraph) {
//       _startTimer();
//       showParagraphMode = true;
//       _checkEssaySavedState();
//     }

//     await _loadAllButtonStates();
//   }

//   ///  ------------------------------------------------------------------------------------------------------------------

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _stopwatch.stop();
//     _scrollController.dispose();
//     flutterTts.stop();
//     _audioPlayer.dispose();
//     _networkAudioPlayer.dispose();
//     _audioDurationSub?.cancel();
//     _audioPositionSub?.cancel();
//     _audioCompleteSub?.cancel();
//     _reportController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Handle case where there are no questions
//     if (_questions.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           leadingWidth: 120.24,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back_ios, size: 18),
//           ),
//           title: Container(
//             width: 112.44,
//             height: 31.2,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF46934),
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Center(
//               child: Text(
//                 widget.repetitionTitle?.contains("බුද්ධි පරීක්ෂණ") ?? false
//                     ? '$elapsedSeconds Seconds'
//                     : '$remainingSeconds Seconds',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12.48,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             InkWell(
//               onTap: () {
//                 _showReportDialog();
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 25),
//                 child: SvgPicture.asset(
//                   "assets/images/stop.svg",
//                   width: 24,
//                   height: 24,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         body: SafeArea(
//           child: Center(
//             child: _isFetching
//                 ? const CircularProgressIndicator(color: Color(0xFFFE7E00))
//                 : Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'No questions found for this level',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       );
//     }

//     final Map<String, dynamic> question = _questions[currentIndex];
//     final List options = List.from(question['options'] ?? []);

//     final String displayParagraph = (widget.pParagraph ?? '').isNotEmpty
//         ? widget.pParagraph!
//         : (_fetchedPQuestion ?? '');
//     final String _ = question['correctAnswer'] ?? '';
//     final int correctAnswerIndex = question['correctAnswerIndex'] ?? -1;
//     final String explanation = question['explanation']?.toString() ?? '';

//     /// Generate question numbers for navigation (from PaperQuiz)-----------------------------------------

//     List<int> questionNumbers = List.generate(
//       _questions.length,
//       (index) => index + 1,
//     );

//     /// time format in paper screen-------------------------------------------------------------------

//     String formatTime(int seconds) {
//       final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
//       final secs = (seconds % 60).toString().padLeft(2, '0');
//       return "$minutes:$secs";
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _isPaperQuizCategory()
//           ? AppBar(
//               /// paper screen question  app bar-----------------------------------------------------
//               backgroundColor: Colors.white,
//               automaticallyImplyLeading: false,
//               elevation: 0,
//               titleSpacing: 0,
//               title: Padding(
//                 padding: const EdgeInsets.only(left: 22, right: 22, top: 5),
//                 child: Row(
//                   children: [
//                     ///  Back button
//                     InkWell(
//                       onTap: () => _modalBottomSheetMenu(context),
//                       borderRadius: BorderRadius.circular(30),
//                       child: Container(
//                         width: 45,
//                         height: 45,
//                         decoration: const BoxDecoration(
//                           color: Colors.black,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back_ios_new,
//                           size: 13,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),

//                     /// Title and Timer
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.categoryTitle ?? "",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.black,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),

//                               ///  Timer box (aligned with title)
//                               Container(
//                                 width: 85,
//                                 height: 32,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 5,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.timer_outlined,
//                                       size: 16,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       formatTime(remainingSeconds),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             _levelHasParagraph()
//                                 ? widget.levelName
//                                 : 'Mock Test',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: _levelHasParagraph()
//                                   ? Colors.grey
//                                   : const Color(0xFF595857),
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           /// default app bar  learn screen question appbar----------------------------------------------
//           : AppBar(
//               backgroundColor: Colors.white,
//               automaticallyImplyLeading: false,
//               leading: IconButton(
//                 onPressed: () {
//                   _modalBottomSheetMenu(context);
//                 },
//                 icon: Padding(
//                   padding: EdgeInsets.only(left: 15),
//                   child: const Icon(Icons.arrow_back_ios, size: 18),
//                 ),
//               ),
//               title: Center(
//                 child: Container(
//                   width: 112.44,
//                   height: 31.2,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF46934),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.repetitionTitle?.contains("බුද්ධි පරීක්ෂණ") ??
//                               false
//                           ? '$elapsedSeconds Seconds'
//                           : '$remainingSeconds Seconds',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12.48,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 InkWell(
//                   onTap: () {
//                     _showReportDialog();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 25),
//                     child: SvgPicture.asset(
//                       "assets/images/report.svg",
//                       width: 24,
//                       height: 24,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//       body: GestureDetector(
//         onHorizontalDragEnd: (details) {
//           if (showParagraphMode) return;
//           // Only enable swipe for PaperQuiz categories
//           if (_isPaperQuizCategory()) {
//             if (details.velocity.pixelsPerSecond.dx > 0) {
//               _goToPreviousQuestion();
//             } else if (details.velocity.pixelsPerSecond.dx < 0) {
//               _goToNextQuestion();
//             }
//           }
//         },

//         child: SingleChildScrollView(
//           controller: _scrollController,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),

//               /// Question numbers navigation  only show for PaperQuiz categories reputation screen---------------------------------
//               if (_isPaperQuizCategory())
//                 Container(
//                   height: 60,
//                   margin: const EdgeInsets.only(top: 8),
//                   child: SingleChildScrollView(
//                     controller: _numberScrollController,
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.symmetric(horizontal: 16),

//                     child: Row(
//                       children: (() {
//                         final List<Widget> items = [];

//                         if (_levelHasParagraph()) {
//                           items.add(
//                             InkWell(
//                               onTap: () {
//                                 final pText =
//                                     widget.pQuestion ?? _fetchedPQuestion;
//                                 if (pText != null && pText.isNotEmpty) {
//                                   setState(() {
//                                     showParagraphMode = true;
//                                     currentIndex = 0;
//                                     selectedAnswer = selectedAnswers[0];
//                                     isAnswered = selectedAnswer != null;
//                                   });
//                                   _checkEssaySavedState();
//                                 }
//                               },
//                               child: Container(
//                                 width: 56,
//                                 height: 56,
//                                 margin: const EdgeInsets.only(right: 8),
//                                 child: Center(
//                                   child: SvgPicture.asset(
//                                     'assets/images/Number.svg',
//                                     width: 47.41,
//                                     height: 47.41,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }

//                         /// Append numbered items
//                         items.addAll(
//                           questionNumbers.map((num) {
//                             final int idx = num - 1;
//                             Color borderColor;
//                             Color bgColor;
//                             Color textColor;

//                             final bool isAnsweredTile =
//                                 idx >= 0 && idx < selectedAnswers.length
//                                 ? selectedAnswers[idx] != null
//                                 : false;

//                             if (idx == currentIndex &&
//                                 !(showParagraphMode && isAnsweredTile)) {
//                               bgColor = const Color(0xFF130026);
//                               textColor = Colors.white;
//                               borderColor = bgColor;
//                             } else if (isAnsweredTile) {
//                               // Answered question
//                               final bool isCorrect =
//                                   selectedAnswers[idx] ==
//                                   _questions[idx]['correctAnswerIndex'];
//                               bgColor = Colors.transparent;
//                               textColor = isCorrect ? Colors.green : Colors.red;
//                               borderColor = isCorrect
//                                   ? Colors.green
//                                   : Colors.red;
//                             } else {
//                               // Unanswered question
//                               bgColor = Colors.transparent;
//                               textColor = Colors.grey.withOpacity(0.5);
//                               borderColor = Colors.grey.withOpacity(0.3);
//                             }

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   currentIndex = num - 1;
//                                   selectedAnswer =
//                                       selectedAnswers[currentIndex];
//                                   isAnswered = selectedAnswer != null;
//                                   showParagraphMode = false;
//                                 });
//                                 _scrollToCurrentNumber();
//                                 // Scroll to top so question card is visible
//                                 WidgetsBinding.instance.addPostFrameCallback((
//                                   _,
//                                 ) {
//                                   _scrollController.animateTo(
//                                     0,
//                                     duration: const Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 });
//                               },
//                               child: (() {
//                                 final Widget circle = Container(
//                                   width: 47.41,
//                                   height: 47.41,
//                                   margin: const EdgeInsets.only(right: 10),
//                                   decoration: BoxDecoration(
//                                     color:
//                                         (showParagraphMode && !isAnsweredTile)
//                                         ? Colors.transparent
//                                         : bgColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                     border: Border.all(
//                                       color:
//                                           (showParagraphMode && !isAnsweredTile)
//                                           ? Colors.grey.withOpacity(0.3)
//                                           : borderColor,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       '$num',
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16,
//                                         color:
//                                             (showParagraphMode &&
//                                                 !isAnsweredTile)
//                                             ? Colors.grey.withOpacity(0.5)
//                                             : textColor,
//                                       ),
//                                     ),
//                                   ),
//                                 );

//                                 return Stack(
//                                   clipBehavior: Clip.none,
//                                   alignment: Alignment.center,
//                                   children: [
//                                     circle,
//                                     // saved indicator removed as requested
//                                   ],
//                                 );
//                               }()),
//                             );
//                           }).toList(),
//                         );

//                         return items;
//                       }()),
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 15),

//               !_isPaperQuizCategory()
//                   ? Center(
//                       child: Text(
//                         '${currentIndex + 1}/${_questions.length}',
//                         style: const TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                   : const SizedBox.shrink(),

//               const SizedBox(height: 10),

//               /// Question card ------------------------------------------------
//               Center(
//                 child: Container(
//                   width: 359,
//                   height: showParagraphMode ? 509 : 240,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     border: Border.all(color: Colors.black12, width: 1),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (showParagraphMode &&
//                             (_hasParagraph ||
//                                 (widget.pQuestion ?? '').isNotEmpty ||
//                                 (widget.pParagraph ?? '').isNotEmpty) &&
//                             ((widget.pQuestion ?? '').isNotEmpty ||
//                                 displayParagraph.isNotEmpty)) ...[
//                           /// --- Show Paragraph Mode ---
//                           if ((widget.pQuestion ?? '').isNotEmpty &&
//                               widget.pQuestion!.trim() !=
//                                   displayParagraph.trim())
//                             Text(
//                               widget.pQuestion!,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           if ((widget.pQuestion ?? '').isNotEmpty &&
//                               displayParagraph.isNotEmpty)
//                             const SizedBox(height: 10),

//                           if (displayParagraph.isNotEmpty)
//                             Text(
//                               displayParagraph,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                         ] else ...[
//                           /// --- Show Normal Question Mode ---
//                           Text(
//                             question['question'] ?? '',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontFamily: "Poppins",
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),

//                           SizedBox(height: 15),

//                           Builder(
//                             builder: (_) {
//                               final String qImg =
//                                   (question['questionImage'] ?? '').toString();
//                               if (qImg.isEmpty) return const SizedBox.shrink();

//                               return Center(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     "https://smartiq.ideacipher.com/upload/images/$qImg",

//                                     loadingBuilder: (context, child, progress) {
//                                       if (progress == null) return child;
//                                       return SizedBox(
//                                         height: 120,
//                                         child: Center(
//                                           child: CircularProgressIndicator(
//                                             value:
//                                                 progress.expectedTotalBytes !=
//                                                     null
//                                                 ? progress.cumulativeBytesLoaded /
//                                                       (progress
//                                                               .expectedTotalBytes ??
//                                                           1)
//                                                 : null,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return const SizedBox.shrink();
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               /// Options
//               if (!showParagraphMode)
//                 // Check if any option has an image to decide layout
//                 Builder(
//                   builder: (context) {
//                     bool hasImages = options.any(
//                       (opt) =>
//                           opt is Map &&
//                           (opt['image']?.toString() ?? '').isNotEmpty,
//                     );

//                     if (hasImages) {
//                       // GridView layout for options with images
//                       return LayoutBuilder(
//                         builder: (context, constraints) {
//                           final screenWidth = constraints.maxWidth;
//                           final cardWidth = (screenWidth - 70 - 10) / 2;
//                           final cardHeight = cardWidth * 0.72;

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 35),
//                             child: GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: 20,
//                                     mainAxisSpacing: 15,
//                                     childAspectRatio: cardWidth / cardHeight,
//                                   ),
//                               itemCount: options.length,
//                               itemBuilder: (context, index) {
//                                 final option = options[index];
//                                 final String optionText = (option is Map)
//                                     ? (option['text']?.toString() ?? '')
//                                     : option.toString();
//                                 final String optionImg = (option is Map)
//                                     ? (option['image']?.toString() ?? '')
//                                     : '';

//                                 final bool isCorrect =
//                                     index == correctAnswerIndex;
//                                 final bool isSelected = selectedAnswer == index;

//                                 Color borderColor = Colors.black12;
//                                 Color fillColor = Colors.white;

//                                 ///coloring logic
//                                 if (isAnswered) {
//                                   if (isCorrect) {
//                                     borderColor = Colors.green;
//                                     fillColor = Colors.green.shade50;
//                                   } else if (isSelected && !isCorrect) {
//                                     borderColor = Colors.red;
//                                     fillColor = Colors.red.shade50;
//                                   }
//                                 } else if (isSelected) {
//                                   borderColor = Colors.orange;
//                                   fillColor = Colors.orange.shade50;
//                                 }

//                                 /// icon asset selection
//                                 String iconAsset;
//                                 if (isAnswered) {
//                                   if (isCorrect) {
//                                     iconAsset = 'assets/images/Checlist.svg';
//                                   } else if (isSelected) {
//                                     iconAsset = 'assets/images/Checklist.svg';
//                                   } else {
//                                     iconAsset =
//                                         'assets/images/Checklist_unselected.svg';
//                                   }
//                                 } else {
//                                   iconAsset = isSelected
//                                       ? 'assets/images/Checlist (1).svg'
//                                       : 'assets/images/Checlist (2).svg';
//                                 }

//                                 return GestureDetector(
//                                   onTap: () async {
//                                     if (!isAnswered) {
//                                       _timer?.cancel();
//                                       setState(() {
//                                         selectedAnswer = index;
//                                       });

//                                       if (widget.repetitionTitle ==
//                                               'සාමාන්‍ය දැනුම' &&
//                                           !widget.isReviewQuiz) {
//                                         final int correct = correctAnswerIndex;
//                                         setState(() {
//                                           isAnswered = true;
//                                           selectedAnswers[currentIndex] =
//                                               selectedAnswer;
//                                           if (selectedAnswer == correct) {
//                                             score++;
//                                             _insertShowAnswerData();
//                                           }
//                                         });

//                                         Future.delayed(
//                                           const Duration(milliseconds: 500),
//                                           () {
//                                             final explanationImage =
//                                                 question['explanationImage']
//                                                     ?.toString() ??
//                                                 '';
//                                             final exampleAudio =
//                                                 question['exampleAudio']
//                                                     ?.toString() ??
//                                                 '';

//                                             if (explanation.isNotEmpty ||
//                                                 explanationImage.isNotEmpty ||
//                                                 exampleAudio.isNotEmpty) {
//                                               _scrollController.animateTo(
//                                                 _scrollController
//                                                     .position
//                                                     .maxScrollExtent,
//                                                 duration: const Duration(
//                                                   milliseconds: 500,
//                                                 ),
//                                                 curve: Curves.easeInOut,
//                                               );
//                                             }
//                                           },
//                                         );

//                                         if (selectedAnswer == correct) {
//                                           await playSound("correctAnswer");
//                                         } else {
//                                           await playSound("wrong");
//                                           if (await Vibration.hasVibrator()) {
//                                             Vibration.vibrate(duration: 300);
//                                           }
//                                         }
//                                       }
//                                     }
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(12),
//                                       color: fillColor,
//                                       border: Border.all(
//                                         color: borderColor,
//                                         width: 1,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         // Icon and text at top
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 iconAsset,
//                                                 width: 18,
//                                                 height: 18,
//                                               ),
//                                               const SizedBox(width: 6),
//                                               Expanded(
//                                                 child: Text(
//                                                   optionText,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontFamily: 'Poppins',
//                                                     fontWeight: FontWeight.w400,
//                                                     color: Colors.black87,
//                                                   ),
//                                                   maxLines: 2,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         // Image below
//                                         if (optionImg.isNotEmpty)
//                                           Flexible(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                     8,
//                                                     0,
//                                                     8,
//                                                     8,
//                                                   ),
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 child: Builder(
//                                                   builder: (context) {
//                                                     return Center(
//                                                       child: Image.network(
//                                                         "https://smartiq.ideacipher.com/upload/images/$optionImg",
//                                                         width: cardWidth * 0.56,
//                                                         height:
//                                                             cardHeight * 0.66,
//                                                         fit: BoxFit.cover,
//                                                         loadingBuilder: (c, child, progress) {
//                                                           if (progress ==
//                                                               null) {
//                                                             return child;
//                                                           }
//                                                           return SizedBox(
//                                                             width:
//                                                                 cardWidth *
//                                                                 0.56,
//                                                             height:
//                                                                 cardHeight *
//                                                                 0.66,
//                                                             child: Center(
//                                                               child: CircularProgressIndicator(
//                                                                 strokeWidth: 2,
//                                                                 value:
//                                                                     progress.expectedTotalBytes !=
//                                                                         null
//                                                                     ? progress.cumulativeBytesLoaded /
//                                                                           (progress.expectedTotalBytes ??
//                                                                               1)
//                                                                     : null,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                         errorBuilder:
//                                                             (c, e, s) => Center(
//                                                               child: SizedBox(
//                                                                 width:
//                                                                     cardWidth *
//                                                                     0.56,
//                                                                 height:
//                                                                     cardHeight *
//                                                                     0.66,
//                                                                 child: const Center(
//                                                                   child: Icon(
//                                                                     Icons
//                                                                         .broken_image,
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     size: 24,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return Column(
//                         children: options.asMap().entries.map<Widget>((entry) {
//                           final int index = entry.key;
//                           final dynamic option = entry.value;
//                           final String optionText = (option is Map)
//                               ? (option['text']?.toString() ?? '')
//                               : option.toString();
//                           final String _ = (option is Map)
//                               ? (option['image']?.toString() ?? '')
//                               : '';

//                           final bool isCorrect = index == correctAnswerIndex;
//                           final bool isSelected = selectedAnswer == index;

//                           Color borderColor = Colors.black12;
//                           Color fillColor = Colors.white;

//                           ///coloring logic

//                           if (isAnswered) {
//                             if (isCorrect) {
//                               borderColor = Colors.green;
//                               fillColor = Colors.green.shade50;
//                             } else if (isSelected && !isCorrect) {
//                               borderColor = Colors.red;
//                               fillColor = Colors.red.shade50;
//                             }
//                           } else if (isSelected) {
//                             borderColor = Colors.orange;
//                             fillColor = Colors.orange.shade50;
//                           }

//                           /// icon asset selection

//                           String iconAsset;
//                           if (isAnswered) {
//                             if (isCorrect) {
//                               iconAsset = 'assets/images/Checlist.svg';
//                             } else if (isSelected) {
//                               iconAsset = 'assets/images/Checklist.svg';
//                             } else {
//                               iconAsset =
//                                   'assets/images/Checklist_unselected.svg';
//                             }
//                           } else {
//                             iconAsset = isSelected
//                                 ? 'assets/images/Checlist (1).svg'
//                                 : 'assets/images/Checlist (2).svg';
//                           }

//                           return GestureDetector(
//                             onTap: () async {
//                               if (!isAnswered) {
//                                 _timer?.cancel();
//                                 setState(() {
//                                   selectedAnswer = index;
//                                 });

//                                 if (widget.repetitionTitle ==
//                                         'සාමාන්‍ය දැනුම' &&
//                                     !widget.isReviewQuiz) {
//                                   final int correct = correctAnswerIndex;
//                                   setState(() {
//                                     isAnswered = true;
//                                     selectedAnswers[currentIndex] =
//                                         selectedAnswer;
//                                     if (selectedAnswer == correct) {
//                                       score++;
//                                       _insertShowAnswerData();
//                                     }
//                                   });

//                                   Future.delayed(
//                                     const Duration(milliseconds: 500),
//                                     () {
//                                       final explanationImage =
//                                           question['explanationImage']
//                                               ?.toString() ??
//                                           '';
//                                       final exampleAudio =
//                                           question['exampleAudio']
//                                               ?.toString() ??
//                                           '';

//                                       if (explanation.isNotEmpty ||
//                                           explanationImage.isNotEmpty ||
//                                           exampleAudio.isNotEmpty) {
//                                         _scrollController.animateTo(
//                                           _scrollController
//                                               .position
//                                               .maxScrollExtent,
//                                           duration: const Duration(
//                                             milliseconds: 500,
//                                           ),
//                                           curve: Curves.easeInOut,
//                                         );
//                                       }
//                                     },
//                                   );

//                                   if (selectedAnswer == correct) {
//                                     await playSound("correctAnswer");
//                                   } else {
//                                     await playSound("wrong");
//                                     if (await Vibration.hasVibrator()) {
//                                       Vibration.vibrate(duration: 300);
//                                     }
//                                   }
//                                 }
//                               }
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.symmetric(
//                                 vertical: 6,
//                                 horizontal: 35,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 17,
//                                 horizontal: 15,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(18),
//                                 color: fillColor,
//                                 border: Border.all(
//                                   color: borderColor,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   SvgPicture.asset(
//                                     iconAsset,
//                                     width: 22,
//                                     height: 22,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Expanded(
//                                     child: Text(
//                                       optionText,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     }
//                   },
//                 ),

//               const SizedBox(height: 25),

//               /// Explanation box: only show when there is non-empty explanation
//               if (!showParagraphMode && isAnswered && explanation.isNotEmpty)
//                 Container(
//                   width: 343,
//                   height: 200,
//                   // Allow height to grow if explanation is long
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(7),
//                     color: const Color(0xFFF8EED9),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Explanation :',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           explanation,
//                           style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//               if (isAnswered)
//                 if (question['explanationImage'] != null &&
//                     question['explanationImage'].toString().isNotEmpty)
//                   Builder(
//                     builder: (_) {
//                       final String eImg = question['explanationImage']
//                           .toString();

//                       return ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           "https://smartiq.ideacipher.com/upload/images/$eImg",
//                           width: 343,
//                           fit: BoxFit.contain,
//                           loadingBuilder: (context, child, progress) {
//                             if (progress == null) return child;
//                             return SizedBox(
//                               height: 120,
//                               child: Center(
//                                 child: CircularProgressIndicator(
//                                   value: progress.expectedTotalBytes != null
//                                       ? progress.cumulativeBytesLoaded /
//                                             (progress.expectedTotalBytes ?? 1)
//                                       : null,
//                                 ),
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return const SizedBox.shrink();
//                           },
//                         ),
//                       );
//                     },
//                   ),

//               const SizedBox(height: 2),

//               /// Audio (exampleAudio) - only show when exampleAudio exists and non-empty
//               if (!showParagraphMode &&
//                   isAnswered &&
//                   (question['exampleAudio']?.toString().trim().isNotEmpty ??
//                       false))
//                 Container(
//                   width: 348,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xFFFFC45F),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       // Network audio
//                       Builder(
//                         builder: (_) {
//                           final String exAudio =
//                               question['exampleAudio']?.toString().trim() ?? '';
//                           if (exAudio.isEmpty) return const SizedBox.shrink();

//                           return Expanded(
//                             child: Row(
//                               children: [
//                                 InkWell(
//                                   onTap: () => _toggleNetworkAudio(exAudio),
//                                   child: Icon(
//                                     isPlayingNetworkAudio
//                                         ? Icons.pause
//                                         : Icons.play_arrow,
//                                     color: Colors.white,
//                                     size: 24,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: SliderTheme(
//                                     data: SliderTheme.of(context).copyWith(
//                                       activeTrackColor: Colors.white,
//                                       inactiveTrackColor: Colors.brown
//                                           .withOpacity(0.5),
//                                       thumbColor: Colors.white,
//                                       trackHeight: 4.0,
//                                       thumbShape: const RoundSliderThumbShape(
//                                         enabledThumbRadius: 6.0,
//                                       ),
//                                       overlayShape:
//                                           const RoundSliderOverlayShape(
//                                             overlayRadius: 14.0,
//                                           ),
//                                     ),
//                                     child: Slider(
//                                       value: (_audioDuration.inMilliseconds > 0)
//                                           ? _audioPosition.inMilliseconds
//                                                 .clamp(
//                                                   0,
//                                                   _audioDuration.inMilliseconds,
//                                                 )
//                                                 .toDouble()
//                                           : 0.0,
//                                       min: 0.0,
//                                       max: _audioDuration.inMilliseconds > 0
//                                           ? _audioDuration.inMilliseconds
//                                                 .toDouble()
//                                           : 1.0,
//                                       onChanged: (value) async {
//                                         final position = Duration(
//                                           milliseconds: value.toInt(),
//                                         );
//                                         setState(() {
//                                           _audioPosition = position;
//                                         });
//                                         await _networkAudioPlayer.seek(
//                                           position,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '${_formatDuration(_audioPosition)} / ${_formatDuration(_audioDuration)}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//               SizedBox(height: 80),
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               /// Hide Save Icon when paragraph mode is active
//               if (!showParagraphMode) ...[
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     InkWell(
//                       onTap: () async {
//                         final bool openParagraph = _levelHasParagraph();

//                         if (openParagraph) {
//                           setState(() {
//                             showParagraphMode = true;
//                             currentIndex = 0;
//                             selectedAnswer = selectedAnswers[0];
//                             isAnswered = selectedAnswer != null;
//                           });
//                           _checkEssaySavedState();

//                           _scrollController.animateTo(
//                             0,
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                           return;
//                         }

//                         // Use centralized toggle helper
//                         await _toggleSaveForCurrentQuestion();
//                       },
//                       child: Builder(
//                         builder: (context) {
//                           final bool openParagraph = _levelHasParagraph();

//                           final bool showSaved =
//                               (currentIndex >= 0 &&
//                                   currentIndex < savedStates.length)
//                               ? savedStates[currentIndex]
//                               : isSaved;

//                           final String assetPath = openParagraph
//                               ? 'assets/images/Number.svg'
//                               : (showSaved
//                                     ? 'assets/images/d5.svg'
//                                     : 'assets/images/Vector (3).svg');

//                           return SvgPicture.asset(
//                             assetPath,
//                             width: 24,
//                             height: 38,
//                           );
//                         },
//                       ),
//                     ),
//                     (_levelHasParagraph() ||
//                             (widget.categoryTitle ?? '')
//                                 .toLowerCase()
//                                 .trim()
//                                 .contains('තරකනය'))
//                         ? const SizedBox.shrink()
//                         : const Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey,
//                             ),
//                           ),
//                   ],
//                 ),

//                 const SizedBox(width: 20),
//               ] else ...[
//                 // Paragraph Mode - Save Icon Left Side
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         _toggleSaveForEssay();
//                       },
//                       child: SvgPicture.asset(
//                         isEssaySaved
//                             ? 'assets/images/d5.svg'
//                             : 'assets/images/Vector (3).svg',
//                         width: 24,
//                         height: 38,
//                       ),
//                     ),
//                     const Text(
//                       'Save',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 20),
//               ],

//               /// Check / Next Button
//               ElevatedButton(
//                 onPressed: () {
//                   if (showParagraphMode) {
//                     final int nextIndex = _firstUnansweredIndex();

//                     setState(() {
//                       showParagraphMode = false;
//                       currentIndex = nextIndex;
//                       selectedAnswer =
//                           (currentIndex >= 0 &&
//                               currentIndex < selectedAnswers.length)
//                           ? selectedAnswers[currentIndex]
//                           : null;
//                       isAnswered = selectedAnswer != null;
//                     });

//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       _scrollController.animateTo(
//                         0,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     });
//                   } else {
//                     if (selectedAnswer != null || isAnswered) {
//                       _onCheckOrNext();
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: showParagraphMode
//                       ? const Color(0xFFFF6901)
//                       : (selectedAnswer == null && !isAnswered
//                             ? Colors.grey.shade400
//                             : const Color(0xFFFF6901)),
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(265, 54),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 child: Text(
//                   _getButtonText(),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Poppins',
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
