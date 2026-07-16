import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smart_guru/screen/dashboard/home/lesson.screen.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> subjects = [];
  bool _isLoading = true;
  int _activePage = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      final fetchedSubjects = await CommerceService.getSubject(
        status: 'active',
        token: SessionManager.token,
      );

      if (!mounted) return;
      setState(() {
        subjects = fetchedSubjects;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching subjects: $e");
      if (!mounted) return;
      setState(() {
        subjects = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider(
                  items: [1, 2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E43A8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -40,
                                top: -40,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.07),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -30,
                                bottom: -50,
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.07),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Daily Challenge",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Inter",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "🔥",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "5 Questions Ready • Mixed Topics",
                                      style: TextStyle(
                                        color: Color(0xFFE2E8F0),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(
                                          0xFF2E43A8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 10,
                                        ),
                                        minimumSize: const Size(0, 42),
                                      ),
                                      child: const Text(
                                        "Start Now",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 161,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _activePage = index;
                      });
                    },
                  ),
                  carouselController: _carouselController,
                ),
                const SizedBox(height: 12),
                AnimatedSmoothIndicator(
                  activeIndex: _activePage,
                  count: 2,
                  effect: const ScrollingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 15,
                    activeDotColor: Color(0xFFE0E0E0),
                    dotColor: Color(0xFFEEEEEE),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        "Your Subjects",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (subjects.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Center(
                  child: Text(
                    "No subjects available",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            )
          else
            SliverList(
              key: const ValueKey('quiz_list_section'),
              delegate: SliverChildBuilderDelegate((context, index) {
                final Map<String, dynamic> subject = Map<String, dynamic>.from(
                  subjects[index] as Map,
                );
                final String subjectName = subject['name'] ?? "";
                final String subjectId = subject['id']?.toString() ?? "";
                final bool isComingSoon = subject["status"] != "active";
                final double progress =
                    double.tryParse(subject['progress']?.toString() ?? "") ??
                    0.0;
                final String totalLessons =
                    subject['total_lessons']?.toString() ?? "0";

                final Color iconBg =
                    subject['iconBg'] ?? const Color(0xFF1A237E);
                final IconData iconData =
                    subject['icon'] ?? Icons.book_outlined;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: isComingSoon
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonScreen(
                                      title: subjectName,
                                      categoryId: subjectId,
                                    ),
                                  ),
                                );
                              },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 145,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFEEEEEE)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: iconBg,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        iconData,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subjectName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "$totalLessons lessons",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isComingSoon)
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text(
                                      "Progress",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${(progress * 100).toInt()}%",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isComingSoon
                                            ? const Color.fromARGB(
                                                255,
                                                129,
                                                130,
                                                131,
                                              )
                                            : const Color(0xFF1A237E),
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: isComingSoon
                                        ? const Color(0xFFE5E7EB)
                                        : const Color(0xFFEEEEEE),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isComingSoon
                                          ? const Color.fromARGB(
                                              255,
                                              129,
                                              130,
                                              131,
                                            )
                                          : const Color(0xFF2962FF),
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isComingSoon)
                        Positioned(
                          top: -9,
                          right: -9,
                          child: SvgPicture.asset(
                            'assets/images/comingSoonLabel.svg',
                            width: 80,
                          ),
                        ),
                    ],
                  ),
                );
              }, childCount: subjects.length),
            ),
        ],
      ),
    );
  }
}
