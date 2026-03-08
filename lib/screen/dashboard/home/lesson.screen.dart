import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/screen/dashboard/home/quiz.item.screen.dart';
import 'package:smart_guru/screen/dashboard/home/lesson.wise.screen.dart';

class IQScreen extends StatefulWidget {
  final String title;
  final String categoryId;

  const IQScreen({super.key, required this.title, required this.categoryId});

  @override
  State<IQScreen> createState() => _IQScreenState();
}

class _IQScreenState extends State<IQScreen> {
  final List<Map<String, dynamic>> quizItems = [
    {
      "id": "lessons",
      "title": "පාඩම් අනුව ප්‍රශ්න",
      "subtitle": "පාඩම් අනුව වර්ගීකරණය කරන ලද ප්‍රශ්න ඇතුළත් වේ.",
      "count_left": "12 lessons",
      "count_right": "1000 MCQs",
      "isComingSoon": false,
    },
    {
      "id": "past_papers",
      "title": "පසුගිය විභාග ප්‍රශ්න",
      "subtitle": "පසුගිය විභාග ප්‍රශ්න පත්‍ර ඇතුළත් වේ.",
      "count_left": "2020-2025",
      "count_right": "200 MCQs",
      "isComingSoon": false,
    },
    {
      "id": "model_papers",
      "title": "අනුමාන ප්‍රශ්න පත්‍ර",
      "subtitle": "අප විසින් සකස් කරන ලද අනුමාන ප්‍රශ්න ඇතුළත් වේ.",
      "count_left": "12 Papers",
      "count_right": "200 MCQs",
      "isComingSoon": false,
    },
    {
      "id": "short_notes",
      "title": "කෙටි සටහන්",
      "subtitle": "විෂය කොටස්වලට අදාළ කෙටි සටහන් මෙහි ඇතුළත් වේ.",
      "count_left": "0 Topics",
      "count_right": "0 PDFs",
      "isComingSoon": false,
    },
    {
      "id": "video_lessons",
      "title": "වීඩියෝ පාඩම්",
      "subtitle": "වීඩියෝ පාඩම් මාලාව ළඟදීම බලාපොරොත්තු වන්න.",
      "count_left": "0 Lessons",
      "count_right": "0 videos",
      "isComingSoon": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: "FMGanganee",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        itemCount: quizItems.length,
        itemBuilder: (context, index) {
          final item = quizItems[index];
          final bool isComingSoon = item["isComingSoon"] == true;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: isComingSoon
                      ? null
                      : () {
                          if (item["id"] == "lessons") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IqCategory(
                                  title: widget.title,
                                  subtitle: item["title"],
                                  quizList: const [],
                                  categoryId: widget.categoryId,
                                  levelId: "1",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizItemScreen(title: item["title"]),
                              ),
                            );
                          }
                        },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"],
                                    style: const TextStyle(
                                      fontFamily: "FMGanganee",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item["subtitle"],
                                    style: const TextStyle(
                                      fontFamily: "FMGanganee",
                                      fontSize: 14,
                                      color: Color(0xFF94A3B8),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isComingSoon
                                    ? const Color(0xFF94A3B8).withOpacity(0.8)
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: isComingSoon
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item["count_left"],
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item["count_right"],
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isComingSoon)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: SvgPicture.asset(
                      'assets/images/comingSoonLabel.svg',
                      width: 90,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
