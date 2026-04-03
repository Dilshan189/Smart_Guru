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
  List<dynamic> quizItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      final String? token = SessionManager.token;
      final List<dynamic> fetchedCategories = await CommerceService.getCategory(
        categoryId: int.tryParse(widget.categoryId),
        module: "word",
        token: token,
        status: "active",
      );

      setState(() {
        quizItems = fetchedCategories;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
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
          : quizItems.isEmpty
          ? const Center(child: Text("No lessons available"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              itemCount: quizItems.length,
              itemBuilder: (context, index) {
                final item = quizItems[index];
                final String title = item["name"] ?? "";
                final String subtitle = item["description"] ?? "";
                final bool isComingSoon = item["status"] == "inactive";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: isComingSoon
                            ? null
                            : () {
                                // Default to lessons navigation for categories fetched
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonWiseScreen(
                                      title: widget.title,
                                      subtitle: title,
                                      quizList: const [],
                                      categoryId: item["id"]?.toString() ?? "",
                                      levelId: "1",
                                    ),
                                  ),
                                );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontFamily: "FMGanganee",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          subtitle,
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
                                  if (!isComingSoon)
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
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
                                    // item["count_left"] ?
                                    "Available",
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
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
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
                          top: -9,
                          right: -9,
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
