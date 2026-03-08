import 'package:flutter/material.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/screen/dashboard/home/level.screen.dart';

class IqCategory extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> quizList;
  final String categoryId;
  final String? rootCategoryId;
  final String levelId;
  final Function(double)? onRefresh;

  const IqCategory({
    super.key,
    required this.title,
    required this.quizList,
    required this.subtitle,
    required this.categoryId,
    this.rootCategoryId,
    required this.levelId,
    this.onRefresh,
  });

  @override
  State<IqCategory> createState() => _IqCategoryState();
}

class _IqCategoryState extends State<IqCategory> {
  final List<Map<String, dynamic>> levels = [
    {
      "id": "1",
      "level_name": "මූලික ආර්ථික ප්‍රශ්න",
      "questions_count": "20 MCQs",
      "progress": 0.3,
      "is_premium": false,
    },
    {
      "id": "2",
      "level_name": "ඉල්ලුම, සැපයුම, නම්‍යතාව",
      "questions_count": "20 MCQs",
      "progress": 0.0,
      "is_premium": false,
    },
    {
      "id": "3",
      "level_name": "වෙළෙඳ පොළට රජය මැදිහත් වන ආකාරය",
      "questions_count": "20 MCQs",
      "progress": 0.0,
      "is_premium": false,
    },
    {
      "id": "4",
      "level_name": "නිෂ්පාදන සාධක වෙළෙඳපොළ",
      "questions_count": "20 MCQs",
      "progress": 0.0,
      "is_premium": false,
    },
    {
      "id": "5",
      "level_name": "ජාතික ගිණුම්කරණය",
      "questions_count": "20 MCQs",
      "progress": 0.0,
      "is_premium": false,
    },
    {
      "id": "6",
      "level_name": "සාර්ව ආර්ථික සමතුලිතය",
      "questions_count": "20 MCQs",
      "progress": 0.0,
      "is_premium": true,
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
                widget.subtitle,
                style: const TextStyle(
                  fontFamily: "FMGanganee",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final bool isPremium = level["is_premium"] == true;

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LevelScreen(title: level["level_name"]),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EFFD),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                level["level_name"],
                                style: const TextStyle(
                                  fontFamily: "FMGanganee",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Color(0xFF4338CA),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              level["questions_count"],
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: level["progress"],
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isPremium)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "Premium",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.diamond_outlined,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
