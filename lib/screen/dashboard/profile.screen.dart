import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_guru/screen/dashboard/nav.wrapper.dart';
import 'package:smart_guru/utils/theam.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> stats = {
      "correctAnswers": 378,
      "wrongAnswers": 72,
      "timeSpent": "12h 45m",
      "levelsCompleted": 18,
      "subjects": [
        {
          "title": "wd¾Ól úoHdj",
          "score": "156/1000",
          "percentage": 87,
          "color": const Color(0xFF1E267C),
          "svgPath": "assets/images/Container_4.svg",
        },
        {
          "title": ".sKqïlrKh",
          "score": "120/1000",
          "percentage": 80,
          "color": const Color(0xFF4CAF50),
          "svgPath": "assets/images/Container_5.svg",
        },
        {
          "title": "jHdmdr wOHk​h",
          "score": "102/1000",
          "percentage": 85,
          "color": const Color(0xFF2196F3),
          "svgPath": "assets/images/Container_6.svg",
        },
      ],
      "weeklyProgress": [12, 15, 18, 14, 20, 16, 22],
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xFF1A2475),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavigationScreen()),
            ),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Inter",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      // Overall Performance Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/Icon_4.svg',
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Overall Performance",
                                  style: TextStyle(
                                    fontSize: 15.66,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatGridItem(
                                    label: "Correct",
                                    value: stats["correctAnswers"].toString(),
                                    color: const Color(0xFFE8F5E9),
                                    textColor: const Color(0xFF4CAF50),
                                    svgPath: "assets/images/Container.svg",
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildStatGridItem(
                                    label: "Wrong",
                                    value: stats["wrongAnswers"].toString(),
                                    color: const Color(0xFFFFF1F1),
                                    textColor: const Color(0xFFEF5350),
                                    svgPath: "assets/images/Container_1.svg",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatGridItem(
                                    label: "Time Spent",
                                    value: stats["timeSpent"],
                                    color: const Color(0xFFE3F2FD),
                                    textColor: const Color(0xFF2196F3),
                                    svgPath: "assets/images/Container_2.svg",
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildStatGridItem(
                                    label: "Levels",
                                    value: stats["levelsCompleted"].toString(),
                                    color: const Color(0xFFF3E5F5),
                                    textColor: const Color(0xFF9C27B0),
                                    svgPath: "assets/images/Container_3.svg",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subject Performance Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Subject Performance",
                              style: TextStyle(
                                fontSize: 15.66,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...(stats["subjects"] as List)
                                .map(
                                  (subject) => _buildSubjectItem(
                                    title: subject["title"],
                                    score: subject["score"],
                                    percentage: subject["percentage"],
                                    color: subject["color"],
                                    svgPath: subject["svgPath"],
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Weekly Progress Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Weekly Progress",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildWeeklyChart(stats["weeklyProgress"]),
                          ],
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
    );
  }

  Widget _buildStatGridItem({
    required String label,
    required String value,
    required Color color,
    required Color textColor,
    required String svgPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SvgPicture.asset(svgPath, width: 36, height: 36),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 17.4,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: "Poppins",
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem({
    required String title,
    required String score,
    required int percentage,
    required Color color,
    required String svgPath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(svgPath, width: 44, height: 44),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'FMGanganee',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      score,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$percentage%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<int> data) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: true),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 6,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade100,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.shade100,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 6,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 24,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(index.toDouble(), data[index].toDouble()),
              ),
              isCurved: true,
              color: const Color(0xFF1E267C),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: const Color(0xFF1E267C),
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
