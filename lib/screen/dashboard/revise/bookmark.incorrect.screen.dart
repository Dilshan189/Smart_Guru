import 'package:flutter/material.dart';

class BookMarkIncorrectScreen extends StatefulWidget {
  const BookMarkIncorrectScreen({super.key});

  @override
  State<BookMarkIncorrectScreen> createState() =>
      _BookMarkIncorrectScreenState();
}

class _BookMarkIncorrectScreenState extends State<BookMarkIncorrectScreen> {
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

  Widget _buildFlashcardItem({
    required String question,
    required String answer,
    required String status,
  }) {
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
                    fontFamily: "Inter",
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

  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        color: const Color(0xFF2E43A8),
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom == 0
              ? 20
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
}
