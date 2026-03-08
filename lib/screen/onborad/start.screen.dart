import 'package:flutter/material.dart';
import 'package:smart_guru/screen/auth/register.screen.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/widgets/custom.button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Blue Background Container
            Positioned(
              left: 0,
              right: 0,
              top: 181,
              child: Center(
                child: Container(
                  width: 275,
                  height: 375,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, 0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [Color(0xFF1A2475), Color(0xFF2B45C4)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // A+ Background Text
            Positioned(
              left: 0,
              right: 0,
              top: 168,
              child: const Text(
                'A+',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 137.27,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // Student Character Image
            Positioned(
              left: 0,
              right: 0,
              top: 190,
              child: Center(
                child: Container(
                  width: 243,
                  height: 366,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/3d-portrait-high-school-teenager 1.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Sinhala Bottom Text
            Positioned(
              left: 20,
              right: 20,
              top: 591,
              child: const Text(
                'iaud¾Ü úÈhg flduia\nbf.k .uqo@',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E2939),
                  fontSize: 24,
                  fontFamily: 'FMGanganee',
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ),
            // Bottom Action Button
            Positioned(
              left: 20,
              right: 20,
              top: 780,
              child: CustomButton2(
                text: 'Get Started ',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
