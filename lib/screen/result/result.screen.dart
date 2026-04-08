import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/utils/theam.dart';

class LevelComplete extends StatefulWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final Duration timeTaken;
  final int currentLevelIndex;
  final List<Map<String, dynamic>> allLevels;
  final bool isPaperQuiz;
  final bool isBookmarkMode;
  final bool isIncorrectMode;
  final String? catrgoryTitle;
  final String? categoryId;
  final String? rootCategoryId;
  final String? levelId;

  const LevelComplete({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeTaken,
    required this.currentLevelIndex,
    required this.isPaperQuiz,
    required this.allLevels,
    this.isBookmarkMode = false,
    this.isIncorrectMode = false,
    this.catrgoryTitle,
    this.categoryId,
    this.rootCategoryId,
    this.levelId,
  });

  @override
  State<LevelComplete> createState() => _LevelCompleteState();
}

class _LevelCompleteState extends State<LevelComplete> {
  late double scorePercent;
  late int points;
  late bool isFailed;
  String currentUserPoints = "0";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    int totalQuestions = widget.correctAnswers + widget.incorrectAnswers;
    scorePercent = totalQuestions > 0
        ? (widget.correctAnswers / totalQuestions) * 100
        : 0;
    points = (scorePercent / 10).round();
    isFailed = widget.incorrectAnswers > widget.correctAnswers;

    if (!widget.isBookmarkMode && !widget.isIncorrectMode) {}
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "${minutes}m ${seconds}s";
  }

  String _getAverageTime() {
    int totalQuestions = widget.correctAnswers + widget.incorrectAnswers;
    if (totalQuestions == 0) return " 00:00";

    int totalSeconds = widget.timeTaken.inSeconds;
    int avgSeconds = (totalSeconds / totalQuestions).round();

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits((avgSeconds ~/ 60));
    String seconds = twoDigits((avgSeconds % 60));

    return " $minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    double sidePadding = width * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Column(
              children: [
                SizedBox(height: height * 0.025),
                if (!widget.isBookmarkMode && !widget.isIncorrectMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, 'exit');
                        },
                        child: SvgPicture.asset(
                          'assets/images/logout.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: height * 0.025),
                Image.asset(
                  (widget.isBookmarkMode || widget.isIncorrectMode)
                      ? 'assets/images/icon.png'
                      : (isFailed
                            ? 'assets/images/😓.png'
                            : 'assets/images/icon.png'),
                  height: height * 0.13,
                ),
                SizedBox(height: height * 0.025),

                SvgPicture.asset(
                  (widget.isBookmarkMode || widget.isIncorrectMode)
                      ? 'assets/images/Review Complete! copy.svg'
                      : (widget.catrgoryTitle == 'Paper Quiz')
                      ? 'assets/images/Paper Completed!.svg'
                      : (isFailed
                            ? 'assets/images/Level Failed! copy.svg'
                            : 'assets/images/Level Completed! copy.svg'),

                  height: 40,
                  width: width * 0.1,
                ),
                SizedBox(height: height * 0.02),
                if (widget.isBookmarkMode || widget.isIncorrectMode)
                  const Text(
                    "You’ve reinforced your memory today.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF30373D),
                    ),
                  ),
                if (!widget.isBookmarkMode && !widget.isIncorrectMode)
                  widget.catrgoryTitle == 'Paper Quiz'
                      ? Column(
                          children: [
                            const Text(
                              "Great Job! You completed the past paper.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: Color(0xFF30373D),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  TextSpan(
                                    text: scorePercent.toStringAsFixed(0),
                                    style: const TextStyle(
                                      color: Color(0xFF2D4990),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "/100",
                                    style: TextStyle(color: Color(0xFFCBD5E1)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "You’ve scored ${scorePercent.toStringAsFixed(0)}% ",
                              ),
                              TextSpan(
                                text:
                                    widget.isBookmarkMode ||
                                        widget.isIncorrectMode
                                    ? "in this Revision"
                                    : "in this Level",
                                style: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                SizedBox(height: height * 0.02),
                if (widget.isBookmarkMode || widget.isIncorrectMode)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(text: "Average Time per Question:"),
                        TextSpan(
                          text: _getAverageTime(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!widget.isBookmarkMode &&
                    !widget.isIncorrectMode &&
                    widget.catrgoryTitle != 'Paper Quiz')
                  Text(
                    isFailed
                        ? "You’ve Earned 0 Pts"
                        : "You’ve Earned ${points}Pts",
                    style: TextStyle(
                      fontSize: width * 0.042,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  width: 309,
                  height: 178,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRow(
                          SvgPicture.asset(
                            "assets/images/Group 633350.svg",
                            height: height * 0.03,
                          ),
                          (widget.isBookmarkMode || widget.isIncorrectMode)
                              ? "Mastered"
                              : "Correct Answers",
                          widget.correctAnswers,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildRow(
                          SvgPicture.asset(
                            "assets/images/Group 633349.svg",
                            height: height * 0.03,
                          ),
                          (widget.isBookmarkMode || widget.isIncorrectMode)
                              ? "To review "
                              : "Incorrect Answers",
                          widget.incorrectAnswers,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildRow(
                          SvgPicture.asset(
                            "assets/images/Group 633348 (1).svg",
                            height: height * 0.03,
                          ),
                          "Time taken",
                          formatDuration(widget.timeTaken),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed:
                          isFailed ||
                              widget.isBookmarkMode ||
                              widget.isIncorrectMode ||
                              ((widget.currentLevelIndex + 1) >=
                                  widget.allLevels.length)
                          ? () {
                              Navigator.pop(context, 'restart');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFailed &&
                                (!widget.isBookmarkMode &&
                                    !widget.isIncorrectMode)
                            ? AppColors.primary
                            : ((widget.currentLevelIndex + 1) >=
                                          widget.allLevels.length &&
                                      (!widget.isBookmarkMode &&
                                          !widget.isIncorrectMode)
                                  ? AppColors.primary
                                  : Colors.grey.shade400),
                        minimumSize: Size(width * 0.85, height * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.1),
                        ),
                      ),
                      child: Text(
                        widget.catrgoryTitle == 'Paper Quiz'
                            ? "Review Mistakes"
                            : "Start Over",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.045,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    ElevatedButton(
                      onPressed:
                          ((!isFailed ||
                                  widget.isBookmarkMode ||
                                  widget.isIncorrectMode) &&
                              !isLoading)
                          ? () async {
                              if (mounted) {
                                Navigator.pop(
                                  context,
                                  (widget.isBookmarkMode ||
                                          widget.isIncorrectMode)
                                      ? 'review_complete'
                                      : 'next_level',
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (!isFailed ||
                                widget.isBookmarkMode ||
                                widget.isIncorrectMode)
                            ? AppColors.primary
                            : Colors.grey.shade400,
                        minimumSize: Size(width * 0.85, height * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.1),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              widget.catrgoryTitle == 'Paper Quiz'
                                  ? "Back to Papers"
                                  : ((widget.isBookmarkMode ||
                                            widget.isIncorrectMode)
                                        ? "Back to Home"
                                        : ((widget.currentLevelIndex + 1) >=
                                                  widget.allLevels.length
                                              ? "Back to Levels"
                                              : "Next Level")),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.045,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Widget icon, String label, dynamic value, [Color? color]) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: width * 0.025),
            Text(
              label,
              style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: widget.isBookmarkMode || widget.isIncorrectMode
                    ? FontWeight.w400
                    : FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ],
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
