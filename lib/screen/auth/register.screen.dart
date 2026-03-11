import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_guru/screen/auth/login.screen.dart';
import 'package:smart_guru/screen/onborad/verify.number.screen.dart';
import '../../utils/theam.dart';
import '../../widgets/custom.button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var w = size.width;
    var h = size.height;

    double sw(double v) => (v / 390.0) * w;
    double sh(double v) => (v / 844.0) * h;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: sw(20),
              right: sw(20),
              top: sh(222),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sh(6),
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      color: AppColors.textBody,
                      fontSize: sw(14),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw(16),
                      vertical: sh(18),
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: sw(1),
                          color: Color(0xFFD8DADC),
                        ),
                        borderRadius: BorderRadius.circular(sw(10)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Your name',
                            style: TextStyle(
                              color: Color(0x7F000000),
                              fontSize: sw(16),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: sw(20),
              right: sw(20),
              top: sh(324),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sh(6),
                children: [
                  Text(
                    'Phone number ',
                    style: TextStyle(
                      color: AppColors.textBody,
                      fontSize: sw(14),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw(16),
                      vertical: sh(18),
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: sw(1),
                          color: Color(0xFFD8DADC),
                        ),
                        borderRadius: BorderRadius.circular(sw(10)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '07X XXX XXXX',
                            style: TextStyle(
                              color: Color(0x7F000000),
                              fontSize: sw(16),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: sw(23),
              right: sw(23),
              top: sh(55),
              child: Text(
                'Register for\nDaily Access',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: sw(30),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ),
            Positioned(
              left: sw(20),
              right: sw(20),
              top: sh(435),
              child: CustomButton(
                text: 'Register',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyNumberScreen(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: sw(23),
              right: sw(23),
              top: sh(149),
              child: Text(
                'Get started for just LKR 8 + tax/day. \nCancel anytime.',
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: sw(14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 1.25,
                ),
              ),
            ),
            Positioned(
              left: sw(20),
              right: sw(20),
              top: sh(511),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already purchased Lifetime??',
                        style: TextStyle(
                          color: Color(0xB2000000),
                          fontSize: sw(14),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: sw(14),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: sw(14),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                      ),
                    ],
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
