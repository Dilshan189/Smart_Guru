import 'package:flutter/material.dart';
import 'package:smart_guru/screen/dashboard/nav.wrapper.dart';
import '../../utils/theam.dart';

class PurchasePremium extends StatefulWidget {
  const PurchasePremium({super.key});

  @override
  State<PurchasePremium> createState() => _PurchasePremiumState();
}

class _PurchasePremiumState extends State<PurchasePremium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: AppColors.background),
          child: Stack(
            children: [
              Positioned(
                left: 32,
                top: 204,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 40,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 63,
                top: 190,
                child: Container(
                  width: 88,
                  height: 27.61,
                  decoration: ShapeDecoration(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.80),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 34.51,
                        offset: Offset(0, 3.45),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 208,
                top: 204,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 40,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 242,
                top: 193,
                child: Container(
                  width: 88,
                  height: 27.61,
                  decoration: ShapeDecoration(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.80),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 34.51,
                        offset: Offset(0, 3.45),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 256,
                top: 197,
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              const Positioned(
                left: 80,
                top: 193,
                child: Text(
                  'Current',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 89,
                top: 237,
                child: Text(
                  'Daily',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 399,
                child: Text(
                  'Features',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 437,
                child: Text(
                  'All Mcqs',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 474,
                child: Text(
                  'Flashcards',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 511,
                child: Text(
                  'Exam Simulator',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 548,
                child: Text(
                  'Smart Revision',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 585,
                child: Text(
                  'Short Notes',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 622,
                child: Text(
                  'Ads-free Learning',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 209,
                top: 399,
                child: Text(
                  'Basic',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 204,
                top: 437,
                child: Text(
                  'Limited',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 271,
                top: 399,
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              const Positioned(
                left: 59,
                top: 302,
                child: Text(
                  'Limited access',
                  style: TextStyle(
                    color: Color(0xFF8696BB),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              const Positioned(
                left: 237,
                top: 304,
                child: Text(
                  'Unlimited access',
                  style: TextStyle(
                    color: Color(0xFF8696BB),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 256,
                top: 241,
                child: Text(
                  'Life time',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 69,
                top: 268,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'LKR 8',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: '+ Tax',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 8,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 245,
                top: 263,
                child: Text(
                  'LKR 2400',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 713,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 353,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Upgrade to Premium > ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Limited Status Indicator (Circle)
              Positioned(
                left: 239,
                top: 474,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF919191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 511,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF919191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 548,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF919191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 585,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF919191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 622,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF919191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              // Premium Success Indicators
              Positioned(
                left: 303,
                top: 437,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              Positioned(
                left: 303,
                top: 474,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              Positioned(
                left: 303,
                top: 511,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              Positioned(
                left: 303,
                top: 548,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              Positioned(
                left: 303,
                top: 585,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              Positioned(
                left: 303,
                top: 622,
                child: Container(
                  width: 18.14,
                  height: 18.14,
                  decoration: ShapeDecoration(
                    color: AppColors.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.07),
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              // Separator Lines
              Positioned(
                left: 32,
                top: 426,
                child: Container(
                  width: 322,
                  height: 1,
                  color: const Color(0xFFA09797),
                ),
              ),
              ...List.generate(5, (index) {
                return Positioned(
                  left: 33.0,
                  top: 463.0 + (index * 37.0),
                  child: Container(
                    width: 322,
                    height: 1,
                    color: const Color(0xFFDDDDDD),
                  ),
                );
              }),
              Positioned(
                left: 23,
                top: 71,
                child: Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 26,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.26,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 121,
                child: SizedBox(
                  width: 333,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'wema tfla ish¿ myiqlï ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'FMMalithi',
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: 'Unlock',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' lr .ekSug Tng re2400 l uqo, f.jd wema tl ñ,§ .; hq;=fõ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'FMMalithi',
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 143,
                top: 780,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Stay on Basic',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 325,
                top: 20,
                child: InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationScreen()),
                  ),
                  child: Container(
                    width: 39,
                    height: 39,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
