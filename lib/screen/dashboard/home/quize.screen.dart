import 'dart:async';
//import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

// import 'package:smart_guru/Databasehelper/database.helper.dart';
import '../../../providers/user.provider.dart';
//import '../../../services/api.service.dart';
// import '../../../models/repetition.model.dart';
// import '../../../models/ReviewQuz.dart';
import '../../result/result.screen.dart';

class QuizScreen extends StatefulWidget {
  final String levelName;
  final String? categoryTitle;
  final String? repetitionTitle;
  final List<dynamic> questions;
  final List<dynamic> data;
  final String? pQuestion;
  final String? pParagraph;
  final String? categoryId;
  final String? rootCategoryId;
  final String? levelId;
  final List<Map<String, dynamic>>? allLevels;
  final int? currentLevelIndex;
  final bool isReviewQuiz;

  const QuizScreen({
    super.key,
    required this.levelName,
    this.categoryTitle,
    this.repetitionTitle,
    required this.questions,
    required this.data,
    this.pQuestion,
    this.pParagraph,
    this.categoryId,
    this.rootCategoryId,
    this.levelId,
    this.allLevels,
    this.currentLevelIndex,
    this.isReviewQuiz = false,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  int score = 0;
  int remainingSeconds = 30;

  bool isSaved = false;
  bool isEssaySaved = false;

  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _numberScrollController = ScrollController();
  final TextEditingController _reportController = TextEditingController();

  List<int?> selectedAnswers = [];
  List<bool> savedStates = [];

  bool showParagraphMode = false;
  bool _hasParagraph = false;

  bool isPlayingTTS = false;
  double ttsProgress = 0.0;
  final FlutterTts flutterTts = FlutterTts();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _networkAudioPlayer = AudioPlayer();
  bool isPlayingNetworkAudio = false;
  double networkAudioProgress = 0.0;
  String? _currentAudioUrl;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  StreamSubscription? _audioDurationSub;
  StreamSubscription? _audioPositionSub;
  StreamSubscription? _audioCompleteSub;

  List<dynamic> _apiQuestions = [];
  String? _fetchedPQuestion;
  bool _isFetching = false;

  List<dynamic> get _questions =>
      widget.questions.isNotEmpty ? widget.questions : _apiQuestions;

  bool _isPaperQuizCategory() {
    final String title = widget.categoryTitle?.trim() ?? "";
    return title.isNotEmpty &&
        (title == "Paper Quiz" || title == "පැරණි ප්‍රශ්න පත්‍ර");
  }

  bool _levelHasParagraph() {
    if (_hasParagraph) return true;
    if (widget.pQuestion != null && widget.pQuestion!.isNotEmpty) return true;
    if (widget.pParagraph != null && widget.pParagraph!.isNotEmpty) return true;
    return false;
  }

  void _startTimer({bool reset = true}) {
    _timer?.cancel();
    if (reset) {
      remainingSeconds = 30;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            _onCheckOrNext();
          }
        });
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      currentIndex = 0;
      selectedAnswer = null;
      isAnswered = false;
      score = 0;
      _startTimer();
      _stopwatch.reset();
      _stopwatch.start();
      selectedAnswers = List<int?>.filled(_questions.length, null);
      showParagraphMode = _levelHasParagraph();
    });
    // _loadButtonState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _onCheckOrNext() async {
    if (_questions.isEmpty || _isFetching) {
      _timer?.cancel();

      if (widget.isReviewQuiz) {
        Navigator.pop(context, widget.data);
      } else {
        final levelsList = widget.allLevels ?? [];
        final currentLvlIdx = widget.currentLevelIndex ?? 0;

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelComplete(
              correctAnswers: score,
              incorrectAnswers: 0,
              timeTaken: _stopwatch.elapsed,
              currentLevelIndex: currentLvlIdx,
              allLevels: levelsList,
              isReviewQuiz: widget.isReviewQuiz,
              catrgoryTitle: widget.categoryTitle,
              categoryId: widget.categoryId,
              rootCategoryId: widget.rootCategoryId,
              levelId: widget.levelId,
            ),
          ),
        );

        if (result == 'restart') {
          _restartQuiz();
        } else if (result == 'next_level') {
          if ((currentLvlIdx + 1) < levelsList.length) {
            final nextIndex = currentLvlIdx + 1;
            final nextLevel = levelsList[nextIndex];

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  levelName: nextLevel["level"] ?? "",
                  categoryTitle: widget.categoryTitle,
                  repetitionTitle: widget.repetitionTitle,
                  questions: nextLevel["questions"] ?? [],
                  data: [],
                  pQuestion: nextLevel["pQuestion"],
                  pParagraph: nextLevel["pParagraph"],
                  categoryId:
                      nextLevel["cat_id"]?.toString() ?? widget.categoryId,
                  rootCategoryId: widget.rootCategoryId,
                  levelId: nextLevel["level_id"]?.toString(),
                  allLevels: levelsList,
                  currentLevelIndex: nextIndex,
                  isReviewQuiz: false,
                ),
              ),
            );
          } else {
            Navigator.pop(context, result);
          }
        } else if (result == 'exit') {
          Navigator.pop(context, result);
        }
      }
      return;
    }

    final question = _questions[currentIndex];
    final int correctAnswerIndex = question['correctAnswerIndex'] ?? -1;

    if (!isAnswered) {
      /// Check pressed
      setState(() {
        isAnswered = true;
        selectedAnswers[currentIndex] = selectedAnswer;
        if (selectedAnswer == correctAnswerIndex) {
          score++;
          // _insertShowAnswerData();
        } else {
          // _removeFromMasteredList();
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        final explanation = question['explanation']?.toString() ?? '';
        final explanationImage = question['explanationImage']?.toString() ?? '';
        final exampleAudio = question['exampleAudio']?.toString() ?? '';

        if (explanation.isNotEmpty ||
            explanationImage.isNotEmpty ||
            exampleAudio.isNotEmpty) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });

      if (selectedAnswer == correctAnswerIndex) {
        await playSound("correctAnswer");
      } else {
        await playSound("wrong");
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 300);
        }
      }
    } else {
      /// Next pressed
      if (currentIndex < _questions.length - 1) {
        await _stopAudio();
        setState(() {
          currentIndex++;
          selectedAnswer = null;
          isAnswered = false;
          showParagraphMode = false;
        });
        // _loadButtonState();
        _startTimer();
        _scrollToCurrentNumber();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      } else {
        /// Quiz finished
        _timer?.cancel();

        final levelsList = widget.allLevels ?? [];
        final currentLvlIdx = widget.currentLevelIndex ?? 0;

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelComplete(
              correctAnswers: score,
              incorrectAnswers: _questions.length - score,
              timeTaken: _stopwatch.elapsed,
              currentLevelIndex: currentLvlIdx,
              allLevels: levelsList,
              isReviewQuiz: widget.isReviewQuiz,
              catrgoryTitle: widget.categoryTitle,
              categoryId: widget.categoryId,
              rootCategoryId: widget.rootCategoryId,
              levelId: widget.levelId,
            ),
          ),
        );

        if (result == 'restart') {
          _restartQuiz();
        } else if (result == 'next_level') {
          if ((currentLvlIdx + 1) < levelsList.length) {
            final nextIndex = currentLvlIdx + 1;
            final nextLevel = levelsList[nextIndex];

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  levelName: nextLevel["level"] ?? "",
                  categoryTitle: widget.categoryTitle,
                  repetitionTitle: widget.repetitionTitle,
                  questions: nextLevel["questions"] ?? [],
                  data: [],
                  pQuestion: nextLevel["pQuestion"],
                  pParagraph: nextLevel["pParagraph"],
                  categoryId:
                      nextLevel["cat_id"]?.toString() ?? widget.categoryId,
                  rootCategoryId: widget.rootCategoryId,
                  levelId: nextLevel["level_id"]?.toString(),
                  allLevels: levelsList,
                  currentLevelIndex: nextIndex,
                  isReviewQuiz: false,
                ),
              ),
            );
          } else {
            Navigator.pop(context, result);
          }
        } else if (result == 'exit' || result == 'review_complete') {
          Navigator.pop(context, result);
        }
      }
    }
  }

  Future<void> playSound(String type) async {
    try {
      if (type == "correctAnswer") {
        await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound: $e');
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _stopAudio() async {
    await _networkAudioPlayer.stop();
    _audioDurationSub?.cancel();
    _audioPositionSub?.cancel();
    _audioCompleteSub?.cancel();

    if (mounted) {
      setState(() {
        isPlayingNetworkAudio = false;
        networkAudioProgress = 0.0;
        _audioPosition = Duration.zero;
      });
    }
  }

  Future<void> _toggleNetworkAudio(String? audioPath) async {
    if (audioPath == null || audioPath.trim().isEmpty) return;

    final String a = audioPath.trim();
    final String url = a.toLowerCase().startsWith('https')
        ? a
        : 'https://smartiq.ideacipher.com/upload/audio/${a.startsWith('/') ? a.substring(1) : a}';

    if (isPlayingTTS) {
      await flutterTts.stop();
      setState(() {
        isPlayingTTS = false;
        ttsProgress = 0.0;
      });
    }

    if (_currentAudioUrl == url) {
      if (isPlayingNetworkAudio) {
        await _networkAudioPlayer.pause();
        setState(() {
          isPlayingNetworkAudio = false;
        });
      } else {
        if ((_audioPosition >= _audioDuration ||
                _audioPosition == Duration.zero) &&
            _audioDuration != Duration.zero) {
          await _networkAudioPlayer.play(UrlSource(url));
        } else {
          await _networkAudioPlayer.resume();
        }

        setState(() {
          isPlayingNetworkAudio = true;
        });
      }
      return;
    }

    await _stopAudio();
    _currentAudioUrl = url;

    try {
      _audioCompleteSub = _networkAudioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            isPlayingNetworkAudio = false;
            networkAudioProgress = 0.0;
            _audioPosition = Duration.zero;
          });
        }
      });

      _audioDurationSub = _networkAudioPlayer.onDurationChanged.listen((d) {
        if (mounted) {
          setState(() {
            _audioDuration = d;
          });
        }
      });

      _audioPositionSub = _networkAudioPlayer.onPositionChanged.listen((p) {
        if (mounted) {
          setState(() {
            _audioPosition = p;
            networkAudioProgress = (_audioDuration.inMilliseconds > 0)
                ? p.inMilliseconds / _audioDuration.inMilliseconds
                : 0.0;
          });
        }
      });

      await _networkAudioPlayer.play(UrlSource(url));
      setState(() {
        isPlayingNetworkAudio = true;
      });
    } catch (e) {
      if (kDebugMode) print('Failed to play network audio $url: $e');
      await _stopAudio();
    }
  }

  String _getButtonText() {
    // final bool isParagraphCategory = _levelHasParagraph();

    if (showParagraphMode) {
      return "Go to Question";
    }

    if (widget.isReviewQuiz) {
      return "Check";
    }

    if (!isAnswered) {
      return "Check";
    }

    return (currentIndex < _questions.length - 1) ? "Next Question" : "Finish";
  }

  String _getUserId() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.userId?.toString() ?? '';
  }

  String _getToken() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.token ?? '';
  }

  // String _getSavedKey(int index) {
  //   final String titleKey = _titleKey();
  //   final qId = _questions[index]['id']?.toString() ?? index.toString();
  //   return 'saved_${titleKey}_$qId';
  // }

  // String _getEssayKey() {
  //   final String titleKey = _titleKey();
  //   return 'essay_saved_$titleKey';
  // }

  // Future<void> _checkEssaySavedState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = _getEssayKey();
  //   setState(() {
  //     isEssaySaved = prefs.getBool(key) ?? false;
  //   });
  // }

  // Future<void> _toggleSaveForEssay() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = _getEssayKey();
  //   setState(() {
  //     isEssaySaved = !isEssaySaved;
  //   });
  //   await prefs.setBool(key, isEssaySaved);
  // }

  // Future<void> _loadButtonState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String key = _getSavedKey(currentIndex);
  //   setState(() {
  //     isSaved = prefs.getBool(key) ?? false;
  //   });
  // }

  // Future<void> _loadAllButtonStates() async {
  //   if (_questions.isEmpty) return;

  //   final prefs = await SharedPreferences.getInstance();
  //   final String userId = _getUserId();

  //   for (int i = 0; i < _questions.length; i++) {
  //     final String key = _getSavedKey(i);
  //     final savedState = prefs.getBool(key) ?? false;

  //     final String titleToUse = _repetitionTitleToUse();
  //     final String questionText = _questions[i]['question'] ?? '';

  //     // final existingRepetition = await DatabaseHelper.instance
  //     //     .getRepetitionByTitleAndQuestion(userId, titleToUse, questionText);

  //     // final resolvedSaved = savedState || (existingRepetition != null);
  //     final resolvedSaved = savedState;

  //     if (i >= 0 && i < savedStates.length) {
  //       savedStates[i] = resolvedSaved;
  //     }
  //   }

  //   setState(() {
  //     if (currentIndex >= 0 && currentIndex < savedStates.length) {
  //       isSaved = savedStates[currentIndex];
  //     }
  //   });
  // }

  String _titleKey() {
    return _repetitionTitleToUse().replaceAll(' ', '_');
  }

  String _repetitionTitleToUse() {
    return (widget.repetitionTitle?.isNotEmpty == true
            ? widget.repetitionTitle!
            : (widget.categoryTitle ?? widget.levelName ?? ''))
        .trim();
  }

  int _firstUnansweredIndex() {
    if (selectedAnswers.isEmpty) return 0;
    final int idx = selectedAnswers.indexWhere((a) => a == null);
    return idx != -1 ? idx : 0;
  }

  // Future<void> _toggleSaveForCurrentQuestion() async {
  //   final String userId = _getUserId();
  //   final prefs = await SharedPreferences.getInstance();

  //   if (currentIndex < 0) return;
  //   if (currentIndex >= savedStates.length) {
  //     final needed = currentIndex - savedStates.length + 1;
  //     savedStates.addAll(List<bool>.filled(needed, false));
  //   }

  //   setState(() {
  //     savedStates[currentIndex] = !savedStates[currentIndex];
  //     isSaved = savedStates[currentIndex];
  //   });

  //   final key = _getSavedKey(currentIndex);
  //   await prefs.setBool(key, savedStates[currentIndex]);

  //   final question = _questions[currentIndex];
  //   final String questionText = question['question'] ?? '';
  //   final String correctAnswer = question['correctAnswer'] ?? '';
  //   final List options = List.from(question['options'] ?? []);

  //   final Map<String, dynamic> answerData = {
  //     'options': options,
  //     'correctAnswer': correctAnswer,
  //     'explanation': question['explanation'] ?? '',
  //     'exampleAudio': question['exampleAudio'] ?? '',
  //     'exampleImage': question['explanationImage'] ?? '',
  //     'questionImage': question['questionImage'] ?? '',
  //   };
  //   final String answerJson = jsonEncode(answerData);
  //   final String repetitionTitle = _repetitionTitleToUse();

  //   // final existing = await DatabaseHelper.instance
  //   //     .getRepetitionByTitleAndQuestion(userId, repetitionTitle, questionText);

  //   // if (savedStates[currentIndex]) {
  //   //   final repetition = Repetition(
  //   //     id: existing?.id,
  //   //     userId: userId,
  //   //     title: repetitionTitle,
  //   //     category: "Quiz",
  //   //     question: questionText,
  //   //     answer: answerJson,
  //   //     score: score.toString(),
  //   //     time: DateTime.now().toIso8601String(),
  //   //     totalCount: _questions.length,
  //   //     masteredCount: score,
  //   //   );

  //   //   if (existing != null) {
  //   //     await DatabaseHelper.instance.updateRepetition(repetition);
  //   //   } else {
  //   //     await DatabaseHelper.instance.insertRepetition(repetition);
  //   //   }
  //   // } else {
  //   //   await DatabaseHelper.instance.deleteRepetitionByTitleAndQuestion(
  //   //     userId,
  //   //     repetitionTitle,
  //   //     questionText,
  //   //   );
  //   // }

  //   setState(() {});
  // }

  // Future<void> _insertShowAnswerData() async {
  //   if (!widget.isReviewQuiz) return;
  //   // ... database logic commented out ...
  // }

  // Future<void> _removeFromMasteredList() async {
  //   if (!widget.isReviewQuiz) return;
  //   // ... database logic commented out ...
  // }

  Future<void> _showReportDialog() async {
    _timer?.cancel();
    String? reportError;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Report Question",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 20.01,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "ප්‍රශ්නයේ වරදක් ඇත්නම් ඒ බව අපට දැනුවත් කරන්න.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: 10.84,
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: _reportController,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          if (reportError != null) {
                            setState(() {
                              reportError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your message here',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                          errorText: reportError,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                minimumSize: const Size(0, 45),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 0.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                final String reason = _reportController.text
                                    .trim();
                                if (reason.isEmpty) {
                                  setState(() {
                                    reportError = "Please enter a message";
                                  });
                                  return;
                                }

                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    _startTimer(reset: false);
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 553,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),

                ///Image.asset('assets/images/Image.png', width: 207, height: 210),
                const SizedBox(height: 25),
                const Text(
                  "Are you sure want\n to quit?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: 280,
                  height: 59,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 280,
                  height: 59,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      foregroundColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _goToPreviousQuestion() async {
    if (currentIndex > 0) {
      await _stopAudio();
      setState(() {
        currentIndex--;
        selectedAnswer = selectedAnswers[currentIndex];
        isAnswered = selectedAnswer != null;
        showParagraphMode = false;
      });
      // _loadButtonState();
      _scrollToCurrentNumber();
    }
  }

  Future<void> _goToNextQuestion() async {
    if (currentIndex < _questions.length - 1) {
      await _stopAudio();
      setState(() {
        currentIndex++;
        selectedAnswer = selectedAnswers[currentIndex];
        isAnswered = selectedAnswer != null;
        showParagraphMode = false;
      });
      // _loadButtonState();
      _scrollToCurrentNumber();
    }
  }

  void _scrollToCurrentNumber() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_numberScrollController.hasClients) {
        double itemWidth = 57.41;
        int indexToScroll = currentIndex;
        if (_levelHasParagraph()) indexToScroll += 1;

        double targetOffset = (indexToScroll * itemWidth);
        double viewportWidth =
            _numberScrollController.position.viewportDimension;

        _numberScrollController.animateTo(
          (targetOffset - (viewportWidth / 2) + (itemWidth / 2)).clamp(
            0,
            _numberScrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(
      _questions.isNotEmpty ? _questions.length : 1,
      null,
    );
    savedStates = List<bool>.filled(
      _questions.isNotEmpty ? _questions.length : 1,
      false,
    );

    // _loadAllButtonStates();
    _startTimer();
    _stopwatch.start();

    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.9);
    flutterTts.setPitch(1.0);
    flutterTts.setVolume(1.0);

    if ((widget.pQuestion != null && widget.pQuestion!.isNotEmpty) ||
        (widget.pParagraph != null && widget.pParagraph!.isNotEmpty)) {
      showParagraphMode = true;
      _hasParagraph = true;
      // _checkEssaySavedState();
    }

    fetchQuestion();
  }

  Future<void> fetchQuestion() async {
    if (widget.questions.isNotEmpty) {
      return;
    }

    setState(() {
      _isFetching = true;
    });

    // Directly using a hardcoded list for testing, bypassing API calls entirely
    List<Map<String, dynamic>> mapped = [
      {
        'id': 'm1',
        'question': 'ශ්‍රී ලංකාවේ පරිපාලන අගනුවර කුමක්ද?',
        'questionImage': '',
        'options': [
          {'text': 'කොළඹ', 'image': ''},
          {'text': 'ශ්‍රී ජයවර්ධනපුර කෝට්ටේ', 'image': ''},
          {'text': 'මහනුවර', 'image': ''},
          {'text': 'අනුරාධපුරය', 'image': ''},
        ],
        'correctAnswer': 'ශ්‍රී ජයවර්ධනපුර කෝට්ටේ',
        'correctAnswerIndex': 1,
        'explanation':
            'ශ්‍රී ලංකාවේ ප්‍රධාන පරිපාලන අගනුවර ශ්‍රී ජයවර්ධනපුර කෝට්ටේ වේ.',
        'explanationImage': '',
        'exampleAudio': '',
        'paragraphText': '',
      },
      {
        'id': 'm2',
        'question': 'ලෝකයේ උසම කන්ද කුමක්ද?',
        'questionImage': '',
        'options': [
          {'text': 'කේ 2 කන්ද', 'image': ''},
          {'text': 'එවරස්ට් කන්ද', 'image': ''},
          {'text': 'පිදුරුතලාගල කන්ද', 'image': ''},
          {'text': 'මොන්ට් බ්ලැන්ක්', 'image': ''},
        ],
        'correctAnswer': 'එවරස්ට් කන්ද',
        'correctAnswerIndex': 1,
        'explanation':
            'ලොව උසම කන්ද වන්නේ හිමාල කඳුවැටියේ පිහිටි එවරස්ට් කන්දයි.',
        'explanationImage': '',
        'exampleAudio': '',
        'paragraphText': '',
      },
      {
        'id': 'm3',
        'question': 'සූර්යයාට නිල වශයෙන් අයත් ග්‍රහලෝක ගණන කීයද?',
        'questionImage': '',
        'options': [
          {'text': '7', 'image': ''},
          {'text': '8', 'image': ''},
          {'text': '9', 'image': ''},
          {'text': '10', 'image': ''},
        ],
        'correctAnswer': '8',
        'correctAnswerIndex': 1,
        'explanation': 'සූර්යග්‍රහ මණ්ඩලයට නිල වශයෙන් ග්‍රහලෝක 8ක් අයත් වේ.',
        'explanationImage': '',
        'exampleAudio': '',
        'paragraphText': '',
      },
      {
        'id': 'm4',
        'question': 'පහත රූපයේ දැක්වෙන පුද්ගලයා කවුද?',
        'questionImage':
            'https://upload.wikimedia.org/wikipedia/commons/e/e0/Albert_Einstein_1947.jpg',
        'options': [
          {'text': 'ටෙස්ලා', 'image': ''},
          {'text': 'නිව්ටන්', 'image': ''},
          {'text': 'අයිසැක් නිව්ටන්', 'image': ''},
          {'text': 'ඇල්බට් අයින්ස්ටයින්', 'image': ''},
        ],
        'correctAnswer': 'ඇල්බට් අයින්ස්ටයින්',
        'correctAnswerIndex': 3,
        'explanation':
            'මෙම රූපයේ දැක්වෙන්නේ ප්‍රසිද්ධ විද්‍යාඥයෙකු වන ඇල්බට් අයින්ස්ටයින් ය.',
        'explanationImage': '',
        'exampleAudio': '',
        'paragraphText': '',
      },
    ];

    // Artificial delay to simulate network for UI testing (optional)
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _apiQuestions = mapped;
        _isFetching = false;
        _hasParagraph = false;
        selectedAnswers = List<int?>.filled(mapped.length, null);
        savedStates = List<bool>.filled(mapped.length, false);
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _scrollController.dispose();
    flutterTts.stop();
    _audioPlayer.dispose();
    _networkAudioPlayer.dispose();
    _audioDurationSub?.cancel();
    _audioPositionSub?.cancel();
    _audioCompleteSub?.cancel();
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          title: Container(
            width: 112.44,
            height: 31.2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                '$remainingSeconds Seconds',
                style: const TextStyle(color: Colors.white, fontSize: 12.48),
              ),
            ),
          ),
        ),
        body: Center(
          child: _isFetching
              ? const CircularProgressIndicator(color: AppColors.primary)
              : const Text('No questions found for this level'),
        ),
      );
    }

    final Map<String, dynamic> question = _questions[currentIndex];
    final List options = List.from(question['options'] ?? []);
    final String displayParagraph = (widget.pParagraph ?? '').isNotEmpty
        ? widget.pParagraph!
        : (_fetchedPQuestion ?? '');
    final int correctAnswerIndex = question['correctAnswerIndex'] ?? -1;
    final String explanation = question['explanation']?.toString() ?? '';

    List<int> questionNumbers = List.generate(
      _questions.length,
      (index) => index + 1,
    );

    String formatTime(int seconds) {
      final mins = (seconds ~/ 60).toString().padLeft(1, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return "$mins:$secs";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isPaperQuizCategory()
          ? AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _modalBottomSheetMenu(context),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.categoryTitle ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                width: 85,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    formatTime(remainingSeconds),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () => _showReportDialog(),
                                child: SvgPicture.asset(
                                  "assets/images/report.svg",
                                  width: 22,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.levelName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => _modalBottomSheetMenu(context),
                icon: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              title: Center(
                child: Container(
                  width: 112.44,
                  height: 31.2,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '$remainingSeconds Seconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.48,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () => _showReportDialog(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: SvgPicture.asset(
                      "assets/images/report.svg",
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (showParagraphMode || !_isPaperQuizCategory()) return;
          if (details.velocity.pixelsPerSecond.dx > 0)
            _goToPreviousQuestion();
          else if (details.velocity.pixelsPerSecond.dx < 0)
            _goToNextQuestion();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              if (_isPaperQuizCategory())
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 8),
                  child: SingleChildScrollView(
                    controller: _numberScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (_levelHasParagraph())
                          InkWell(
                            onTap: () {
                              setState(() {
                                showParagraphMode = true;
                                currentIndex = 0;
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/images/Number.svg',
                              width: 47,
                            ),
                          ),
                        ...questionNumbers.map((num) {
                          final idx = num - 1;
                          final bool isCurrent =
                              idx == currentIndex && !showParagraphMode;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = idx;
                                selectedAnswer = selectedAnswers[idx];
                                isAnswered = selectedAnswer != null;
                                showParagraphMode = false;
                              });
                              _scrollToCurrentNumber();
                            },
                            child: Container(
                              width: 47,
                              height: 47,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? const Color(0xFF130026)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isCurrent
                                      ? Colors.black
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$num',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              if (!_isPaperQuizCategory())
                Text(
                  '${currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10),
              Container(
                width: 359,
                height: showParagraphMode ? 509 : 240,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (showParagraphMode) ...[
                        if ((widget.pQuestion ?? '').isNotEmpty)
                          Text(
                            widget.pQuestion!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          displayParagraph,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ] else ...[
                        Text(
                          question['question'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        if ((question['questionImage'] ?? '')
                            .toString()
                            .isNotEmpty)
                          Image.network(
                            "https://smartiq.ideacipher.com/upload/images/${question['questionImage']}",
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!showParagraphMode)
                Column(
                  children: options.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final opt = entry.value;
                    final bool isCorrect = idx == correctAnswerIndex;
                    final bool isSelected = selectedAnswer == idx;

                    Color borderColor = const Color(
                      0xFFF1FEF3,
                    ).withOpacity(0.0);
                    Color bgColor = Colors.white;
                    Widget icon = Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                    );

                    if (isAnswered) {
                      if (isCorrect) {
                        borderColor = const Color(0xFFD1FAE5);
                        bgColor = const Color(0xFFECFDF5);
                        icon = const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 22,
                        );
                      } else if (isSelected) {
                        borderColor = const Color(0xFFFEE2E2);
                        bgColor = const Color(0xFFFEF2F2);
                        icon = const Icon(
                          Icons.cancel,
                          color: Color(0xFFEF4444),
                          size: 22,
                        );
                      }
                    } else if (isSelected) {
                      borderColor = const Color(0xFFF1F5F9);
                      bgColor = const Color(0xFFF8FAFC);
                      icon = const Icon(
                        Icons.radio_button_checked,
                        color: Color(0xFF2D4990),
                        size: 22,
                      );
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isAnswered) return;
                        setState(() => selectedAnswer = idx);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 35,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected || (isAnswered && isCorrect)
                                ? borderColor
                                : Colors.black.withOpacity(0.05),
                          ),
                          boxShadow: [
                            if (!isAnswered && !isSelected)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            icon,
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt['text'] ?? opt.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            if (opt is Map &&
                                (opt['image'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Image.network(
                                "https://smartiq.ideacipher.com/upload/images/${opt['image']}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              if (isAnswered && explanation.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8EED9),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text('Explanation: $explanation'),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Row(
            children: [
              if (!showParagraphMode)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        // _toggleSaveForCurrentQuestion();
                      },
                      child: SvgPicture.asset(
                        "assets/images/save.svg",
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              const SizedBox(width: 25),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onCheckOrNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _getButtonText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
