import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'quize.screen.dart';

class LevelScreen extends StatefulWidget {
  final String title;
  const LevelScreen({super.key, required this.title});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  // Sample data to match the screenshot
  final List<Map<String, dynamic>> levels = [
    {"num": "1", "status": "85%", "isLocked": false, "isPremium": false},
    {
      "num": "2",
      "status": "Not Started",
      "isLocked": false,
      "isPremium": false,
    },
    {"num": "3", "status": "Locked", "isLocked": true, "isPremium": false},
    {"num": "4", "status": "Locked", "isLocked": true, "isPremium": false},
    {"num": "5", "status": "Locked", "isLocked": true, "isPremium": false},
    {"num": "6", "status": "Locked", "isLocked": true, "isPremium": false},
    {"num": "7", "status": "", "isLocked": true, "isPremium": true},
    {"num": "8", "status": "", "isLocked": true, "isPremium": true},
    {"num": "9", "status": "", "isLocked": true, "isPremium": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
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
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          return _buildLevelCard(level);
        },
      ),
    );
  }

  Widget _buildLevelCard(Map<String, dynamic> item) {
    bool isLocked = item["isLocked"];
    bool isPremium = item["isPremium"];

    return InkWell(
      onTap: () {
        if (!isLocked) {
          // Navigating to QuizScreen. In a real app, you would fetch questions from an API here
          // or pass the category/level ID to QuizScreen to fetch its own questions.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                levelName: "Level ${item['num']}",
                categoryTitle: widget.title,
                questions:
                    const [], // Questions will be fetched by QuizScreen using levelId/categoryId
                data: const [],
                categoryId:
                    "1", // This would normally come from the API/Data model
                levelId: item['num'],
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLocked
                ? Colors.blue.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level ${item['num']}",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isLocked
                        ? const Color(0xFFABC4FF)
                        : const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? const Color(0xFFDBE6FF)
                        : const Color(0xFFDBE6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isLocked
                          ? "assets/images/Group 512878.svg"
                          : "assets/images/uis_unlock.svg",
                      colorFilter: ColorFilter.mode(
                        isLocked
                            ? const Color(0xFF8DA9FF)
                            : const Color(0xFF1E3A8A),
                        BlendMode.srcIn,
                      ),
                      width: 22,
                      height: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!isPremium)
                  Text(
                    item['status'],
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? const Color(0xFFABC4FF)
                          : const Color(0xFF1E3A8A),
                    ),
                  ),
              ],
            ),
            if (isPremium)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 21,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D4990),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Premium",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset(
                        "assets/images/fluent_premium-28-filled.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
