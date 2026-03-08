import 'package:flutter/material.dart';
import 'package:smart_guru/screen/onborad/start.screen.dart';
import 'package:smart_guru/utils/theam.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSartScreen();
  }

  Future<void> _navigateToSartScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 402,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'SmartGuru\n',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 40,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    TextSpan(
                      text: 'Learn Commerce',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 246,
              child: Center(
                child: Container(
                  width: 118.57,
                  height: 118.57,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.58),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x1E000000),
                        blurRadius: 19.33,
                        offset: Offset(0, 5.16),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 767,
              child: const Text(
                'powered by',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 6.58,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 774.27,
              child: const Text(
                'ideacipher',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 20.36,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 256,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/ChatGPT Image Mar 4, 2026, 09_43_04 PM 1.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
