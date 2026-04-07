import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/screen/dashboard/home/lesson.wise.screen.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';

class LessonScreen extends StatefulWidget {
  final String title;
  final String categoryId;

  const LessonScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Map<String, dynamic>? subjectData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryLessons();
  }

  Future<void> fetchCategoryLessons() async {
    try {
      final String? token = SessionManager.token;
      final Map<String, dynamic>? counts = await CommerceService.getSubjectModuleCounts(
        subjectId: int.tryParse(widget.categoryId) ?? 0,
        token: token,
      );

      setState(() {
        subjectData = counts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching subject lessons: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              itemCount: 5,
              itemBuilder: (context, index) {
                String title = "";
                String subtitle = "";
                String leftText = "";
                String rightText = "";
                bool isComingSoon = false;

                if (index == 0) {
                  title = "පාඩම් අනුව ප්‍රශ්න";
                  subtitle = "පාඩම් අනුව වර්ගීකරණය කරන ලද ප්‍රශ්න ඇතුලත් වේ.";
                  leftText = "${subjectData?['total_lessons'] ?? 0} lessons";
                  rightText = "View";
                } else if (index == 1) {
                  title = "පසුගිය විභාග ප්‍රශ්න";
                  subtitle = "පසුගිය විභාග ප්‍රශ්න පත්‍ර ඇතුලත් වේ.";
                  leftText = "${subjectData?['total_pass_papers'] ?? 0} Papers";
                  rightText = "View";
                } else if (index == 2) {
                  title = "අනුමාන ප්‍රශ්න පත්‍ර";
                  subtitle = "අප විසින් සකසන විභාග අනුමාන ප්‍රශ්න ඇතුලත් වේ.";
                  leftText = "${subjectData?['total_model_papers'] ?? 0} Papers";
                  rightText = "View";
                } else if (index == 3) {
                  title = "කෙටි සටහන්";
                  subtitle = "විෂය කොටස්වලට අදාළ කෙටි සටහන් මෙහි ඇතුලත් වේ.";
                  leftText = "${subjectData?['total_short_notes'] ?? 0} Topics";
                  rightText = "View";
                } else if (index == 4) {
                  title = "වීඩියෝ පාඩම්";
                  subtitle = "වීඩියෝ පාඩම් මීළඟට බලාපොරොත්තු වන්න.";
                  leftText = "${subjectData?['total_video_lessons'] ?? 0} Lessons";
                  rightText = "View";
                  isComingSoon = true;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: isComingSoon
                            ? null
                            : () {
                                if (index == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LessonWiseScreen(
                                        title: widget.title,
                                        subtitle: title,
                                        quizList: const [],
                                        categoryId: widget.categoryId,
                                        levelId: "1",
                                      ),
                                    ),
                                  );
                                }
                              },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFF1F5F9),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          subtitle,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF94A3B8),
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: isComingSoon
                                          ? const Color(0xFF64748B) // Grayish
                                          : const Color(
                                              0xFF283593,
                                            ), // Deep Blue
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    leftText,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      rightText,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
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
                          top: -6,
                          right: -6,
                          child: SvgPicture.asset(
                            'assets/images/comingSoonLabel.svg',
                            width: 80,
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
