import 'package:flutter/material.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/screen/dashboard/home/level.screen.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';

class LessonWiseScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> quizList;
  final String categoryId;
  final String? rootCategoryId;
  final String levelId;
  final Function(double)? onRefresh;

  const LessonWiseScreen({
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
  State<LessonWiseScreen> createState() => _LessonWiseScreenState();
}

class _LessonWiseScreenState extends State<LessonWiseScreen> {
  List<dynamic> levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    try {
      final String? token = SessionManager.token;
      final List<dynamic> fetchedLevels =
          await CommerceService.getSubjectLesson(
            lessonId: int.tryParse(widget.categoryId),
            token: token,
            status: "active",
          );

      setState(() {
        levels = fetchedLevels;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching levels: $e");
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : levels.isEmpty
          ? const Center(child: Text("No items available"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final String levelName = level["name"] ?? "";
                final bool isPremium = level["is_premium"] == 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LevelScreen(
                            title: levelName,
                            lessonId: level["id"]?.toString() ?? "",
                          ),
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
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8EFFD),
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
                                      levelName,
                                      style: const TextStyle(
                                        fontFamily: "FMGanganee",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (!isPremium)
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEEF2FF),
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
                                  const Text(
                                    "View Lessons",
                                    style: TextStyle(
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
                                        value: 0.0,
                                        minHeight: 6,
                                        backgroundColor: const Color(
                                          0xFFF1F5F9,
                                        ),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                              child: const Row(
                                children: [
                                  Text(
                                    "Premium",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
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
