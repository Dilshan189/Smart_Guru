import 'package:flutter/material.dart';
import 'package:smart_guru/screen/dashboard/revise/flashcard/flash.screen.dart';

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  // Sample data to exactly mirror the provided screenshot
  final List<Map<String, dynamic>> flashcards = [
    {
      "question": "1975 ලෝක කුසලාන අවසන් මහා තරගයේදී 'තරගයේ වීරයා' කවුද?",
      "answer": "ක්ලයිව් ලොයිඩ්",
      "status": "bad",
    },
    {
      "question": "1975 ලෝක කුසලාන අවසන් මහා තරගයේදී 'තරගයේ වීරයා' කවුද?",
      "answer": "ක්ලයිව් ලොයිඩ්",
      "status": "neutral",
    },
    {
      "question": "1975 ලෝක කුසලාන අවසන් මහා තරගයේදී 'තරගයේ වීරයා' කවුද?",
      "answer": "ක්ලයිව් ලොයිඩ්",
      "status": "good",
    },
    {
      "question": "1975 ලෝක කුසලාන අවසන් මහා තරගයේදී 'තරගයේ වීරයා' කවුද?",
      "answer": "ක්ලයිව් ලොයිඩ්",
      "status": "neutral",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background
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
              // Circular Back Arrow
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
              const Expanded(
                child: Text(
                  "Flashcards",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              // Trailing Eye Icon
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.visibility,
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final card = flashcards[index];
                return _buildFlashcardItem(
                  question: card["question"],
                  answer: card["answer"],
                  status: card["status"],
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
    required String question,
    required String answer,
    required String status,
  }) {
    Color iconBgColor;
    Color iconColor;
    IconData iconData;

    // Define colors & icons corresponding to performance state
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
            color: Color(0x0A000000), // Very light drop shadow (10% black)
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
                  question,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                    fontFamily: "Inter", // Or FMGanganee depending on setup
                    height: 1.4,
                  ),
                ),
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
            ),
          ),
        ],
      ),
    );
  }

  // Helper for bottom anchor button
  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {
        _showRevisionPopup(context);
      },
      child: Container(
        width: double.infinity,
        color: const Color(0xFF2E43A8), // Deep blue exactly matching Appbar
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom == 0
              ? 20 // Standard padding if no system safe area
              : MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "START REVISION",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.chevron_right, color: Colors.white, size: 22),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlashScreen(),
                              ),
                            );
                            // Navigate to actual revision screen
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2D4990), Color(0xFF1E293B)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              // Removed borderRadius here, as main container handles it
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
