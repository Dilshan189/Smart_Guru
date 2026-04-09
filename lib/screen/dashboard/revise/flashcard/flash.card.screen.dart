import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/screen/dashboard/revise/flashcard/flash.screen.dart';
import 'package:smart_guru/utils/theam.dart';
import '../../home/quize.screen.dart';
import '../../../../models/saved_question.model.dart';

class FlashCardScreen extends StatefulWidget {
  final List<SavedQuestionModel>? questions;
  final String? title;
  final bool isBookmark;
  final bool isIncorrect;
  final bool isFlashcard;

  const FlashCardScreen({
    super.key,
    this.questions,
    this.title,
    this.isBookmark = false,
    this.isIncorrect = false,
    this.isFlashcard = false,
  });

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  bool _isAnswerVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF2E43A8),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF1D2939),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Main Title
              Expanded(
                child: Text(
                  widget.title ?? "Flashcards",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              // Trailing Eye Icon
              IconButton(
                onPressed: () {
                  setState(() {
                    _isAnswerVisible = !_isAnswerVisible;
                  });
                },
                icon: Icon(
                  _isAnswerVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Flashcards Scrollable Target List
          Expanded(
            child: (widget.questions == null || widget.questions!.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.isIncorrect
                              ? "No Incorrect Questions"
                              : widget.isBookmark
                              ? "No Bookmarks Questions"
                              : "No Flashcards Questions",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 156, 156, 156),
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    itemCount: widget.questions!.length,
                    itemBuilder: (context, index) {
                      final card = widget.questions![index];
                      String answerText = "";
                      if (card.options.isNotEmpty &&
                          card.correctAnswerIndex != null) {
                        int checkIdx = card.correctAnswerIndex!;
                        if (checkIdx >= 0 && checkIdx < card.options.length) {
                          answerText = card.options[checkIdx]['text'] ?? "";
                        }
                      }
                      return _buildFlashcardItem(
                        card: card,
                        answer: answerText,
                        status: widget.title == "Incorrect Answers"
                            ? "bad"
                            : "good",
                      );
                    },
                  ),
          ),
          // Fixed Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  // Dynamic Card Builder
  Widget _buildFlashcardItem({
    required SavedQuestionModel card,
    required String answer,
    required String status,
  }) {
    if (widget.isBookmark || widget.isIncorrect) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAECF0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/images/brain.svg",
                width: 26,
                height: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.question.isNotEmpty
                        ? card.question
                        : "Identify Missing Objects?",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Color(0xFF1D2939),
                      fontFamily: "Inter",
                      height: 1.4,
                    ),
                  ),
                  if (card.questionImage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Image.network(
                      "https://commerce.ideacipher.com/upload/images/${card.questionImage}",
                      fit: BoxFit.contain,
                    ),
                  ],
                  if (card.options.isEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EEFF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Essay Question",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B61E4),
                        ),
                      ),
                    ),
                  ] else if (_isAnswerVisible) ...[
                    const SizedBox(height: 12),
                    Text(
                      answer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF98A2B3),
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    Color iconBgColor;
    Color iconColor;
    IconData iconData;

    if (status == "bad") {
      iconBgColor = const Color(0xFFFFEBEB);
      iconColor = const Color(0xFFE63946);
      iconData = Icons.sentiment_dissatisfied_outlined;
    } else if (status == "good") {
      iconBgColor = const Color(0xFFE8F5E9);
      iconColor = const Color(0xFF00C853);
      iconData = Icons.sentiment_satisfied_outlined;
    } else {
      iconBgColor = const Color(0xFFF1F5F9);
      iconColor = const Color(0xFF64748B);
      iconData = Icons.sentiment_neutral_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotion Indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          // Card Text Fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.question.isNotEmpty
                      ? card.question
                      : "Identify Missing Objects?",
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: Color(0xFF1D2939),
                    fontFamily: "Inter",
                    height: 1.4,
                  ),
                ),
                if (_isAnswerVisible) ...[
                  const SizedBox(height: 8),
                  Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF98A2B3),
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for bottom anchor button
  Widget _buildBottomButton() {
    final bool isEmpty = widget.questions == null || widget.questions!.isEmpty;

    return GestureDetector(
      onTap: isEmpty
          ? null
          : () {
              if (widget.isFlashcard) {
                _showRevisionPopup(context);
              } else {
                final mappedQuestions =
                    widget.questions
                        ?.map(
                          (e) => {
                            'id': e.id,
                            'question': e.question,
                            'questionImage': e.questionImage,
                            'options': e.options,
                            'correctAnswerIndex': e.correctAnswerIndex,
                            'explanation': e.explanation,
                            'explanationImage': e.explanationImage,
                            'exampleAudio': e.exampleAudio,
                            'paragraphText': e.paragraphText,
                            'raw_item': e.rawItem,
                          },
                        )
                        .toList() ??
                    [];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      levelName: widget.title ?? "Revision",
                      categoryTitle: widget.title ?? "Revision",
                      data: const [],
                      questions: mappedQuestions,
                      isBookmarkMode: widget.isBookmark,
                      isIncorrectMode: widget.isIncorrect,
                    ),
                  ),
                );
              }
            },
      child: Container(
        width: double.infinity,
        color: isEmpty
            ? const Color(0xFF2E43A8).withOpacity(0.4)
            : const Color(0xFF2E43A8),
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom == 0
              ? 20
              : MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEmpty ? "START REVISION" : "START REVISION",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                letterSpacing: 1.0,
              ),
            ),
            if (!isEmpty) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: Colors.white, size: 22),
            ],
          ],
        ),
      ),
    );
  }

  void _showRevisionPopup(BuildContext context) {
    String selectedCardType = "All";
    double numberOfCards = 15;
    const double maxCards = 55;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Card Type",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D4990),
                                  fontFamily: "Poppins",
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTypeOption(
                                    label: "All",
                                    isSelected: selectedCardType == "All",
                                    onTap: () => setModalState(
                                      () => selectedCardType = "All",
                                    ),
                                  ),
                                  _buildTypeOption(
                                    label: "Bad",
                                    icon: Icons.sentiment_dissatisfied,
                                    iconColor: const Color(0xFFE63946),
                                    bgColor: const Color(0xFFFFEBEB),
                                    isSelected: selectedCardType == "Bad",
                                    onTap: () => setModalState(
                                      () => selectedCardType = "Bad",
                                    ),
                                  ),
                                  _buildTypeOption(
                                    label: "OK",
                                    icon: Icons.sentiment_neutral,
                                    iconColor: const Color(0xFF64748B),
                                    bgColor: const Color(0xFFF1F5F9),
                                    isSelected: selectedCardType == "OK",
                                    onTap: () => setModalState(
                                      () => selectedCardType = "OK",
                                    ),
                                  ),
                                  _buildTypeOption(
                                    label: "Good",
                                    icon: Icons.sentiment_satisfied,
                                    iconColor: const Color(0xFF00C853),
                                    bgColor: const Color(0xFFE8F5E9),
                                    isSelected: selectedCardType == "Good",
                                    onTap: () => setModalState(
                                      () => selectedCardType = "Good",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                "Number Of Cards",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D4990),
                                  fontFamily: "Poppins",
                                ),
                              ),
                              const SizedBox(height: 10),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFF2D4990),
                                  inactiveTrackColor: const Color(0xFFE2E8F0),
                                  thumbColor: const Color(0xFF2D4990),
                                  overlayColor: const Color(0x292D4990),
                                  trackHeight: 4.0,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Slider(
                                        value: numberOfCards,
                                        min: 1,
                                        max: maxCards,
                                        onChanged: (value) {
                                          setModalState(() {
                                            numberOfCards = value;
                                          });
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "${maxCards.toInt()} Cards",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: Text(
                                  "${numberOfCards.toInt()} Cards",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D4990),
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlashScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "LET'S START",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeOption({
    required String label,
    IconData? icon,
    Color? iconColor,
    Color? bgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: isSelected && label == "All"
              ? const Color(0xFFEFF6FF)
              : (bgColor ?? Colors.white),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D4990) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: iconColor ?? const Color(0xFF2D4990),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
