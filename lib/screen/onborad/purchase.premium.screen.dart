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
    var size = MediaQuery.of(context).size;
    var w = size.width;

    // Use uniform scaling based on width to preserve perfect proportions
    double scale = w / 390.0;
    double sw(double v) => v * scale;
    double sh(double v) => v * scale;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: w,
              height: 844 * scale,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: AppColors.background),
              child: Stack(
                children: [
                  Positioned(
                    left: sw(32),
                    top: sh(204),
                    child: Container(
                      width: sw(150),
                      height: sh(150),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(10)),
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
                    left: sw(63),
                    top: sh(190),
                    child: Container(
                      width: sw(88),
                      height: sh(27.61),
                      decoration: ShapeDecoration(
                        color: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(13.80)),
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
                    left: sw(208),
                    top: sh(204),
                    child: Container(
                      width: sw(150),
                      height: sh(150),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: sw(2),
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(sw(10)),
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
                    left: sw(242),
                    top: sh(193),
                    child: Container(
                      width: sw(88),
                      height: sh(27.61),
                      decoration: ShapeDecoration(
                        color: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(13.80)),
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
                    left: sw(256),
                    top: sh(197),
                    child: Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(80),
                    top: sh(193),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(89),
                    top: sh(237),
                    child: Text(
                      'Daily',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(39),
                    top: sh(399),
                    child: Text(
                      'Features',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(437),
                    child: Text(
                      'All Mcqs',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(474),
                    child: Text(
                      'Flashcards',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(511),
                    child: Text(
                      'Exam Simulator',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(548),
                    child: Text(
                      'Smart Revision',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(585),
                    child: Text(
                      'Short Notes',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(37),
                    top: sh(622),
                    child: Text(
                      'Ads-free Learning',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(209),
                    top: sh(399),
                    child: Text(
                      'Basic',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(204),
                    top: sh(437),
                    child: Text(
                      'Limited',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(271),
                    top: sh(399),
                    child: Text(
                      'Premium',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(59),
                    top: sh(302),
                    child: Text(
                      'Limited access',
                      style: TextStyle(
                        color: Color(0xFF8696BB),
                        fontSize: sw(12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(237),
                    top: sh(304),
                    child: Text(
                      'Unlimited access',
                      style: TextStyle(
                        color: Color(0xFF8696BB),
                        fontSize: sw(12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(256),
                    top: sh(241),
                    child: Text(
                      'Life time',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(69),
                    top: sh(268),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'LKR 8',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: sw(18),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: sh(1.25),
                            ),
                          ),
                          TextSpan(
                            text: '+ Tax',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: sw(8),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: sh(1.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(245),
                    top: sh(263),
                    child: Text(
                      'LKR 2400',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: sw(18),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: sh(1.25),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(18),
                    top: sh(713),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: sw(353),
                        height: sh(56),
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sw(10)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Upgrade to Premium > ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: sw(16),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: sh(1.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Limited Status Indicator (Circle)
                  Positioned(
                    left: sw(239),
                    top: sh(474),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF919191),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(239),
                    top: sh(511),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF919191),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(239),
                    top: sh(548),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF919191),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(239),
                    top: sh(585),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF919191),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(239),
                    top: sh(622),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF919191),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Premium Success Indicators
                  Positioned(
                    left: sw(303),
                    top: sh(437),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(303),
                    top: sh(474),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(303),
                    top: sh(511),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(303),
                    top: sh(548),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(303),
                    top: sh(585),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(303),
                    top: sh(622),
                    child: Container(
                      width: sw(18.14),
                      height: sh(18.14),
                      decoration: ShapeDecoration(
                        color: AppColors.successGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(9.07)),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: sw(12),
                      ),
                    ),
                  ),
                  // Separator Lines
                  Positioned(
                    left: sw(32),
                    top: sh(426),
                    child: Container(
                      width: sw(322),
                      height: sh(1),
                      color: const Color(0xFFA09797),
                    ),
                  ),
                  ...List.generate(5, (index) {
                    return Positioned(
                      left: sw(33.0),
                      top: sh(463.0) + (index * 37.0),
                      child: Container(
                        width: sw(322),
                        height: sh(1),
                        color: const Color(0xFFDDDDDD),
                      ),
                    );
                  }),
                  Positioned(
                    left: sw(23),
                    top: sh(71),
                    child: Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: sw(26),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: sh(1.30),
                        letterSpacing: -0.26,
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(24),
                    top: sh(121),
                    child: SizedBox(
                      width: sw(333),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'wema tfla ish¿ myiqlï ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sw(14),
                                fontFamily: 'FMMalithi',
                                fontWeight: FontWeight.w400,
                                height: sh(1.25),
                              ),
                            ),
                            TextSpan(
                              text: 'Unlock',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sw(14),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: sh(1.25),
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' lr .ekSug Tng re2400 l uqo, f.jd wema tl ñ,§ .; hq;=fõ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sw(14),
                                fontFamily: 'FMMalithi',
                                fontWeight: FontWeight.w400,
                                height: sh(1.25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(143),
                    top: sh(780),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Stay on Basic',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: sw(16),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: sh(1.25),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: sw(325),
                    top: sh(20),
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationScreen(),
                        ),
                      ),
                      child: Container(
                        width: sw(39),
                        height: sh(39),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: sw(1),
                              color: AppColors.lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(sw(10)),
                          ),
                        ),
                        child: Icon(Icons.close, size: sw(20)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
