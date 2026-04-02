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
    double screenWidth = MediaQuery.of(context).size.width;
    double scale = screenWidth / 390.0;
    double sw(double v) => v * scale;
    double sh(double v) => v * scale;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sw(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sh(20)),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationScreen(),
                      ),
                    ),
                    child: Container(
                      width: sw(40),
                      height: sh(40),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(sw(10)),
                      ),
                      child: Icon(Icons.close, size: sw(20)),
                    ),
                  ),
                ),
                Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: sw(26),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: sh(10)),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'wema tfla ish¿ myiqlï ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: sw(14),
                          fontFamily: 'FMMalithi',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Unlock',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: sw(14),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
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
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPlanCard(
                      title: 'Current',
                      subTitle: 'Daily',
                      price: 'LKR 8',
                      tax: '+ Tax',
                      access: 'Limited access',
                      isSelected: false,
                      sw: sw,
                      sh: sh,
                    ),
                    _buildPlanCard(
                      title: 'Premium',
                      subTitle: 'Life time',
                      price: 'LKR 2400',
                      tax: '',
                      access: 'Unlimited access',
                      isSelected: true,
                      sw: sw,
                      sh: sh,
                    ),
                  ],
                ),
                SizedBox(height: sh(30)),
                _buildFeatureHeader(sw, sh),
                Divider(color: const Color(0xFFA09797), height: sh(1)),
                _buildFeatureRow('All Mcqs', true, true, sw, sh),
                _buildFeatureRow('Flashcards', false, true, sw, sh),
                _buildFeatureRow('Exam Simulator', false, true, sw, sh),
                _buildFeatureRow('Smart Revision', false, true, sw, sh),
                _buildFeatureRow('Short Notes', false, true, sw, sh),
                _buildFeatureRow('Ads-free Learning', false, true, sw, sh),
                SizedBox(height: sh(40)),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: sh(56),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(sw(10)),
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
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh(20)),
                Center(
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
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subTitle,
    required String price,
    required String tax,
    required String access,
    required bool isSelected,
    required double Function(double) sw,
    required double Function(double) sh,
  }) {
    return Container(
      width: sw(160),
      padding: EdgeInsets.all(sw(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sw(10)),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: sw(2))
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 40,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: sw(12), vertical: sh(4)),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(sw(15)),
            ),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: sw(12)),
            ),
          ),
          SizedBox(height: sh(10)),
          Text(
            subTitle,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
              fontSize: sw(14),
            ),
          ),
          SizedBox(height: sh(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: sw(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              if (tax.isNotEmpty)
                Text(
                  tax,
                  style: TextStyle(
                    fontSize: sw(8),
                    color: AppColors.primaryText,
                  ),
                ),
            ],
          ),
          SizedBox(height: sh(5)),
          Text(
            access,
            style: TextStyle(color: const Color(0xFF8696BB), fontSize: sw(11)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHeader(
    double Function(double) sw,
    double Function(double) sh,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Features',
            style: TextStyle(color: AppColors.secondaryText, fontSize: sw(14)),
          ),
        ),
        Expanded(
          child: Text(
            'Basic',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondaryText, fontSize: sw(14)),
          ),
        ),
        Expanded(
          child: Text(
            'Premium',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondaryText, fontSize: sw(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(
    String feature,
    bool basicAccess,
    bool premiumAccess,
    double Function(double) sw,
    double Function(double) sh,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: sh(12.0)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  feature,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: sw(14),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: basicAccess
                      ? Text(
                          'Limited',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: sw(12),
                          ),
                        )
                      : Container(
                          width: sw(18),
                          height: sh(18),
                          decoration: const BoxDecoration(
                            color: Color(0xFF919191),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: sw(12),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Center(
                  child: premiumAccess
                      ? Container(
                          width: sw(18),
                          height: sh(18),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: sw(12),
                          ),
                        )
                      : Text('-', style: TextStyle(fontSize: sw(12))),
                ),
              ),
            ],
          ),
        ),
        Divider(color: const Color(0xFFDDDDDD), height: sh(1)),
      ],
    );
  }
}
