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
    var size = MediaQuery.of(context).size;
    var w = size.width;
    var h = size.height;

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
              top: h * 0.21,
              child: Center(
                child: Container(
                  width: w * 0.7,
                  height: h * 0.44,
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
              top: h * 0.19,
              child: Text(
                'A+',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.35,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // Student Character Image
            Positioned(
              left: 0,
              right: 0,
              top: h * 0.22,
              child: Center(
                child: Container(
                  width: w * 0.62,
                  height: h * 0.43,
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
              top: h * 0.69,
              child: Text(
                'iaud¾Ü úÈhg flduia\nbf.k .uqo@',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1E2939),
                  fontSize: w * 0.06,
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
              bottom: h * 0.05,
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
