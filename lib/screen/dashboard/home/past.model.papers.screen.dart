import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'quize.screen.dart';

class PastModelPapersScreen extends StatefulWidget {
  final String title;

  const PastModelPapersScreen({super.key, required this.title});

  @override
  State<PastModelPapersScreen> createState() => _PastModelPapersScreenState();
}

class _PastModelPapersScreenState extends State<PastModelPapersScreen> {
  final PageController _resumePageController = PageController();
  int _currentResumePage = 0;

  final List<Map<String, dynamic>> _resumeExams = [
    {
      "title": "2024 ප්‍රශ්න පත්‍රය",
      "questions": "8/40 Question",
      "progress": 0.65,
      "percent": "65%",
      "time": "Time Spent : 35 min",
    },
    {
      "title": "2023 ප්‍රශ්න පත්‍රය",
      "questions": "20/40 Question",
      "progress": 0.50,
      "percent": "50%",
      "time": "Time Spent : 60 min",
    },
  ];

  @override
  void dispose() {
    _resumePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
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
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'FMGanganee',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surfaceWhite,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            const Text(
              "Resume Exam",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.bodyText,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 150,
              width: double.infinity,
              child: PageView.builder(
                controller: _resumePageController,
                itemCount: _resumeExams.length,
                onPageChanged: (index) {
                  setState(() => _currentResumePage = index);
                },
                itemBuilder: (context, index) {
                  final exam = _resumeExams[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 4, left: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1A333333),
                            blurRadius: 54,
                            offset: const Offset(10, 24),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 112,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECFA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/Vector (4).svg",
                                colorFilter: ColorFilter.mode(
                                  AppColors.accent,
                                  BlendMode.srcIn,
                                ),
                                width: 44,
                                height: 44,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  exam["title"],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                    fontFamily: 'FMGanganee',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                // Question count in blue
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/44.svg",
                                      width: 13,
                                      height: 13,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      exam["questions"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.accent,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                // Progress bar (full width)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: exam["progress"],
                                    backgroundColor: AppColors.lightGrey,
                                    color: AppColors.accent,
                                    minHeight: 7,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 12,
                                          color: AppColors.secondaryText,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          exam["time"],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.secondaryText,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      exam["percent"],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accent,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                SizedBox(
                                  width: double.infinity,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizScreen(
                                            levelName: exam["title"],
                                            categoryTitle: "Paper Quiz",
                                            questions: const [],
                                            data: const [],
                                            levelId: "1",
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.surfaceWhite,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Resume Exam",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            // Animated Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_resumeExams.length, (index) {
                final isActive = index == _currentResumePage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.secondaryText,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),

            const SizedBox(height: 5),

            Divider(
              color: AppColors.primaryText.withValues(alpha: 0.1),
              indent: 20,
              endIndent: 20,
            ),

            const SizedBox(height: 16),
            const Text(
              "Available Papers",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.bodyText,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            _buildPaperCard(
              title: "2024 ප්‍රශ්න පත්‍රය",
              status: "Not Started",
              score: "00/100",
              imageColor: const Color(0xFFF2F4F7),
              iconColor: const Color(0xFFD0D5DD),
              icon: Icons.file_copy,
              tagBgColor: const Color(0xFFF2F4F7),
              tagTextColor: AppColors.primaryText,
            ),
            const SizedBox(height: 12),
            _buildPaperCard(
              title: "2024 ප්‍රශ්න පත්‍රය",
              status: "In Progress",
              score: "00/100",
              imageColor: AppColors.accent.withValues(alpha: 0.08),
              iconColor: AppColors.accent,
              icon: Icons.file_copy,
              tagBgColor: AppColors.accent.withValues(alpha: 0.08),
              tagTextColor: AppColors.accent,
            ),
            const SizedBox(height: 12),
            _buildPaperCard(
              title: "2023 ප්‍රශ්න පත්‍රය",
              status: "Completed",
              score: "85",
              totalScore: "/100",
              time: "2 hour 15 min",
              imageColor: AppColors.successGreen.withValues(alpha: 0.1),
              iconColor: AppColors.successGreen,
              icon: Icons.task,
              tagBgColor: AppColors.successGreen.withValues(alpha: 0.1),
              tagTextColor: AppColors.successGreen,
            ),
            const SizedBox(height: 12),
            _buildPaperCard(
              title: "2022 ප්‍රශ්න පත්‍රය",
              status: "Premium Access Required",
              score: "",
              isPremium: true,
              imageColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFF59E0B),
              icon: Icons.lock,
              tagBgColor: Colors.transparent,
              tagTextColor: const Color(0xFFD97706),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperCard({
    required String title,
    required String status,
    required String score,
    String totalScore = "",
    String? time,
    bool isPremium = false,
    required Color imageColor,
    required Color iconColor,
    required IconData icon,
    required Color tagBgColor,
    required Color tagTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 82,
                  height: 93,
                  decoration: BoxDecoration(
                    color: imageColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/Vector (6).svg",
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPremium
                              ? AppColors.secondaryText
                              : AppColors.primaryText,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tagBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: tagTextColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: tagTextColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    score.isNotEmpty
                                        ? score
                                        : (isPremium ? "" : "00/100"),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isPremium
                                          ? Colors.transparent
                                          : (totalScore.isNotEmpty
                                                ? AppColors.accent
                                                : AppColors.lightGrey),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  if (totalScore.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        totalScore,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryText,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (time != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: AppColors.bodyText,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      time,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color.fromARGB(255, 14, 14, 15),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      if (!isPremium)
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(
                                      levelName: title,
                                      categoryTitle: "Paper Quiz",
                                      questions: const [],
                                      data: const [],
                                      levelId: "1", // Hardcoded for testing
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.surfaceWhite,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Start Exam",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isPremium)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Premium",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.surfaceWhite,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.diamond,
                      size: 10,
                      color: AppColors.surfaceWhite,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
