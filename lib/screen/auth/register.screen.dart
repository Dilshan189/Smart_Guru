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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              top: 222,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      color: AppColors.textBody,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFD8DADC),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Your name',
                            style: TextStyle(
                              color: Color(0x7F000000),
                              fontSize: 16,
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
              left: 20,
              right: 20,
              top: 324,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: [
                  const Text(
                    'Phone number ',
                    style: TextStyle(
                      color: AppColors.textBody,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFD8DADC),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '07X XXX XXXX',
                            style: TextStyle(
                              color: Color(0x7F000000),
                              fontSize: 16,
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
            const Positioned(
              left: 23,
              right: 23,
              top: 55,
              child: Text(
                'Register for\nDaily Access',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 435,
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
            const Positioned(
              left: 23,
              right: 23,
              top: 149,
              child: Text(
                'Get started for just LKR 8 + tax/day. \nCancel anytime.',
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 1.25,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 511,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already purchased Lifetime??',
                        style: TextStyle(
                          color: Color(0xB2000000),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      const TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 14,
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
