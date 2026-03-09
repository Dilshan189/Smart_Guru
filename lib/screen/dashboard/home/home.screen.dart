import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smart_guru/screen/dashboard/home/lesson.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _couponController = TextEditingController();
  int _activePage = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, dynamic>> words = [
    {
      "sinhala": "wd¾Ól úoHdj",
      "module": "1",
      "Question": "1240 MCQs",
      "Coming Soon": false,
      'image': 'assets/images/Icon (7).svg',
      "title": "සාමාන්ය දැනුම",
      "progress": 0.65,
      "color": Color(0xFF1A237E),
    },
    {
      "sinhala": ".sKqïlrKh",
      "module": "2",
      "Question": "980 MCQs",
      'image': 'assets/images/Icon (5).svg',
      "Coming Soon": true,
      "title": "බුද්ධි පරීක්ෂණ",
      "progress": 0.0,
      "color": Color(0xFF78909C),
    },
    {
      "sinhala": "jHdmdr wOHk​h",
      "module": "3",
      "Question": "1150 MCQs",
      'image': 'assets/images/Icon (6).svg',
      "Coming Soon": true,
      "title": "භාෂා හැකියාව",
      "progress": 0.0,
      "color": Color(0xFF78909C),
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If device is invalid

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
          SliverList(
            key: const ValueKey('quiz_list_section'),
            delegate: SliverChildBuilderDelegate((context, index) {
              final word = words[index];
              final bool isComingSoon = word["Coming Soon"] == true;
              final double progress = word["progress"] ?? 0.0;
              final Color iconBg = word["color"] ?? const Color(0xFF1A237E);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                                    title: word["sinhala"] ?? "",
                                    categoryId:
                                        word["module"]?.toString() ?? "",
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
                                    child: SvgPicture.asset(
                                      word['image'] ?? '',
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          word["sinhala"] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: "FMGanganee",
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          word["Question"] ?? "",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
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
                          width: 110,
                        ),
                      ),
                  ],
                ),
              );
            }, childCount: words.length),
          ),
        ],
      ),
    );
  }
}
