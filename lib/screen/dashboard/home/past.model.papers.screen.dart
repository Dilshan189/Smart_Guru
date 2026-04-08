import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';
import 'quize.screen.dart';

class PastModelPapersScreen extends StatefulWidget {
  final String title;
  final String subjectId;
  final String paperType;

  const PastModelPapersScreen({
    super.key,
    required this.title,
    required this.subjectId,
    required this.paperType,
  });

  @override
  State<PastModelPapersScreen> createState() => _PastModelPapersScreenState();
}

class _PastModelPapersScreenState extends State<PastModelPapersScreen> {
  final PageController _resumePageController = PageController();
  int _currentResumePage = 0;
  List<dynamic> _papers = [];
  bool _isLoading = true;

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
  void initState() {
    super.initState();
    _fetchPapers();
  }

  Future<void> _fetchPapers() async {
    try {
      final token = SessionManager.token;
      final results = await CommerceService.getSubjectPaper(
        subjectId: int.tryParse(widget.subjectId),
        paperType: widget.paperType,
        token: token,
        status: "active",
      );
      setState(() {
        _papers = results;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching papers: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.secondary,
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'FMGanganee',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.surfaceWhite,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        return _buildResumeCard(exam);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
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
                  if (_papers.isEmpty)
                    const Center(child: Text("No papers available")),
                  ...List.generate(_papers.length, (index) {
                    final paper = _papers[index];
                    final bool isPremium = paper["is_premium"] == 1;
                    String paperStatus;
                    if (isPremium) {
                      paperStatus = "Premium Access Required";
                    } else if (paper["is_completed"] == 1) {
                      paperStatus = "Completed";
                    } else if (paper["is_started"] == 1 ||
                        (paper["progress"] != null && paper["progress"] > 0)) {
                      paperStatus = "In Progress";
                    } else {
                      paperStatus = "Not Started";
                    }
                    // Set colors based on status
                    Color imageColor;
                    Color iconColor;
                    IconData icon;

                    if (isPremium) {
                      imageColor = const Color(0xFFFFFBEB);
                      iconColor = const Color(0xFFF59E0B);
                      icon = Icons.lock;
                    } else if (paperStatus == "Completed") {
                      imageColor = const Color(0xFFDCFCE7);
                      iconColor = const Color(0xFF16A34A);
                      icon = Icons.description;
                    } else if (paperStatus == "In Progress") {
                      imageColor = const Color(0xFFE8ECFA);
                      iconColor = const Color(0xFF283593);
                      icon = Icons.description;
                    } else {
                      imageColor = const Color(0xFFF2F4F7);
                      iconColor = const Color(0xFF94A3B8);
                      icon = Icons.description;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildPaperCard(
                        paper: paper,
                        title: paper["title"] ?? paper["name"] ?? "",
                        status: paperStatus,
                        score: paper["score"]?.toString() ?? "00/100",
                        isPremium: isPremium,
                        imageColor: imageColor,
                        iconColor: iconColor,
                        icon: icon,
                        timeSpent: paper["time_spent"]?.toString(),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildResumeCard(Map<String, dynamic> exam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A333333),
              blurRadius: 54,
              offset: Offset(10, 24),
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
                  colorFilter: const ColorFilter.mode(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exam["time"],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                          fontFamily: 'Inter',
                        ),
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
                      onPressed: () {},
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
  }

  Color _getStatusDotColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF22C55E); // Green
      case "In Progress":
        return const Color(0xFF3B82F6); // Blue
      case "Premium Access Required":
        return const Color(0xFFF59E0B); // Amber
      default:
        return const Color(0xFF94A3B8); // Grey for Not Started
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF16A34A);
      case "In Progress":
        return const Color(0xFF2563EB);
      case "Premium Access Required":
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF64748B);
    }
  }

  Widget _buildPaperCard({
    required Map<String, dynamic> paper,
    required String title,
    required String status,
    required String score,
    bool isPremium = false,
    required Color imageColor,
    required Color iconColor,
    required IconData icon,
    String? timeSpent,
  }) {
    final bool isCompleted = status == "Completed";
    final String buttonText = status == "Not Started"
        ? "Start Exam"
        : "Start Exam";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                      // Status with colored dot
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getStatusDotColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getStatusTextColor(status),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Score and Button row
                      if (!isPremium)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  score,
                                  style: TextStyle(
                                    fontSize: isCompleted ? 20 : 16,
                                    fontWeight: isCompleted
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isCompleted
                                        ? AppColors.primaryText
                                        : const Color(0xFF94A3B8),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                if (isCompleted && timeSpent != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 13,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          timeSpent,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF94A3B8),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        levelName: title,
                                        categoryTitle: title,
                                        questions: const [],
                                        data: const [],
                                        levelId: paper["id"]?.toString() ?? "1",
                                        subjectId: widget.subjectId,
                                        paperType: widget.paperType,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.surfaceWhite,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  buttonText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                  children: [
                    Text(
                      "Premium",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.diamond, size: 10, color: Colors.white),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
