import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_guru/screen/dashboard/revise/flashcard/flash.card.screen.dart';

class ReviseScreen extends StatefulWidget {
  const ReviseScreen({super.key});

  @override
  State<ReviseScreen> createState() => _ReviseScreenState();
}

class _ReviseScreenState extends State<ReviseScreen> {
  double _questionsPerDay = 10;
  bool _dailyReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTopCard(
                    icon: Icons.bookmark_border,
                    iconBgColor: const Color(0xFFE5EEFF),
                    iconColor: const Color(0xFF3B61E4),
                    title: "Bookmarked",
                    subtitle: "24 Questions",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTopCard(
                    icon: Icons.cancel_outlined,
                    iconBgColor: const Color(0xFFFFEBEB),
                    iconColor: const Color(0xFFE63946),
                    title: "Incorrect\nAnswers",
                    subtitle: "18 Questions",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              "Flashcards",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                color: Color(0xFF1D2939),
                fontStyle: FontStyle.normal,
              ),
            ),
            const SizedBox(height: 16),

            // Flashcard List Item
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashCardScreen()),
                );
              },
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAECF0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 2,
                      spreadRadius: -1,
                      offset: Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E43A8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "wd¾Ól úoHdj",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "FMGanganee",
                                  color: Color(0xFF1D2939),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "1240 Flashcards",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF667085),
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF98A2B3),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Color(0xFF98A2B3),
                        ),
                        const SizedBox(width: 6),
                        RichText(
                          text: const TextSpan(
                            text: "Last reviewed: ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF98A2B3),
                              fontFamily: "Poppins",
                            ),
                            children: [
                              TextSpan(
                                text: "2 days ago",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E43A8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Settings Card
            Container(
              height: 258,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAECF0), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 2,
                    spreadRadius: -1,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "${_questionsPerDay.toInt()} Questions ",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        fontFamily: "Poppins",
                      ),
                      children: const [
                        TextSpan(
                          text: "per day",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Slider Implementation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 14,
                        activeTrackColor: const Color(0xFF030310),
                        inactiveTrackColor: const Color(0xFFEAECF0),
                        thumbColor: Colors.white,
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: const _BorderedSliderThumbShape(
                          thumbRadius: 7,
                        ),
                        trackShape: _CustomTrackShape(),
                      ),
                      child: Slider(
                        value: _questionsPerDay,
                        min: 1,
                        max: 30,
                        divisions: 29,
                        onChanged: (val) {
                          setState(() {
                            _questionsPerDay = val;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "1",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "15",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "20",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "30",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Daily Reminder Toggle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Enable Daily Reminder",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                                fontFamily: "Poppins",
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You will receive a daily notification with\nyour Smart Revision questions.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontFamily: "Poppins",
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: _dailyReminder,
                          activeColor: const Color(0xFF00C853),
                          onChanged: (val) {
                            setState(() {
                              _dailyReminder = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlashCardScreen()),
        );
      },
      child: Container(
        width: 157.5,
        height: 162,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAECF0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              spreadRadius: -1,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
                fontFamily: "poppins",
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF667085),
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BorderedSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;
  const _BorderedSliderThumbShape({this.thumbRadius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paintBg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, paintBg);
    canvas.drawCircle(center, thumbRadius, paintBorder);
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
