import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/utils/theam.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnswerVisible = false;
  int _currentIndex = 3;
  final int _totalCards = 15;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isAnswerVisible) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isAnswerVisible = !_isAnswerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _currentIndex / _totalCards,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4ADE80),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(width: 34), // Placeholder for balance
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // White Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "$_currentIndex/$_totalCards",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Flash Card
                      _buildFlashCard(),
                      const SizedBox(height: 30),
                      // Rating Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Rate your answer",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildRatingButtons(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashCard() {
    return Expanded(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isBack = angle > pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Transform(
                    transform: Matrix4.identity()..rotateY(isBack ? pi : 0),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        // Status Icon (Top Right)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Icon(
                            Icons.sentiment_dissatisfied,
                            color: const Color(0xFFE63946).withOpacity(0.8),
                            size: 32,
                          ),
                        ),
                        // Center Content
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              isBack
                                  ? "ක්ලයිව් ලොයිඩ්" // Answer
                                  : "1975 ලෝක කුසලාන අවසන් මහා තරගයේදී 'තරගයේ වීරයා' කවුද?", // Question
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                                fontFamily: "Inter",
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        // Bottom Action Section
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                "Swipe and rate your answer",
                                style: TextStyle(
                                  color: const Color(
                                    0xFF94A3B8,
                                  ).withOpacity(0.6),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: Colors.black.withOpacity(0.05),
                                height: 1,
                              ),
                              GestureDetector(
                                onTap: _toggleFlip,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/Vector (8).svg',
                                        color: AppColors.primary,
                                        width: 24,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        isBack
                                            ? "Tap to see question"
                                            : "Tap to see answers",
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Side Indicators (Visual Only)
                  Positioned(
                    left: 15,
                    bottom: 17,
                    child: Opacity(
                      opacity: 0.1,
                      child: SvgPicture.asset(
                        'assets/images/material-symbols_swipe-left-outline.svg',
                        width: 40,
                        color: const Color.fromARGB(255, 73, 73, 73),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 17,
                    child: Opacity(
                      opacity: 0.1,
                      child: Transform.scale(
                        scaleX: -1,
                        child: SvgPicture.asset(
                          'assets/images/material-symbols_swipe-left-outline (1).svg',
                          width: 40,
                          color: const Color.fromARGB(255, 73, 73, 73),
                        ),
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

  Widget _buildRatingButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRateButton(
            label: "Don't know",
            icon: Icons.sentiment_dissatisfied,
            color: const Color(0xFFE63946),
            bgColor: const Color(0xFFFFEBEB),
          ),
          _buildRateButton(
            label: "Almost",
            icon: Icons.sentiment_neutral,
            color: const Color(0xFF64748B),
            bgColor: const Color(0xFFF1F5F9),
          ),
          _buildRateButton(
            label: "Know it",
            icon: Icons.sentiment_satisfied,
            color: const Color(0xFF00C853),
            bgColor: const Color(0xFFE8F5E9),
          ),
        ],
      ),
    );
  }

  Widget _buildRateButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
