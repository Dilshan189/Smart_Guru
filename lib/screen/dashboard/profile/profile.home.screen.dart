import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guru/screen/auth/login.screen.dart';
import 'package:smart_guru/screen/dashboard/profile/profile.screen.dart';
import 'package:smart_guru/screen/dashboard/profile/rank.screen.dart';
import 'package:smart_guru/utils/theam.dart';

import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  Map<String, dynamic>? profile;
  bool _isLoading = true;
  String _rank = "0";
  String _points = "0";

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  /// Api calls
  Future<void> _fetchProfileData() async {
    try {
      final String? token = SessionManager.token;
      final int? userId = SessionManager.userId;

      if (token != null && userId != null) {
        // Fetch points and leaderboard in parallel
        final results = await Future.wait([
          CommerceService.getUserPoints(userId, token),
          CommerceService.getLeaderboard(userId, token),
        ]);

        if (mounted) {
          setState(() {
            // Extract points
            if (results[0] != null && results[0] is Map) {
              _points = results[0]['total_points']?.toString() ?? "0";
            }

            // Extract rank from leaderboard data
            if (results[1] != null && results[1] is Map) {
              _rank = results[1]['rank']?.toString() ?? "0";
            }

            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching profile data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // final TextEditingController _couponController = TextEditingController();

  void _showReportDialog() {
    final TextEditingController reportController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Report Question",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 20.01,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "m%Yakfha jrola we;skï tA nj wmsg oekqj;a lrkak'",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'FMMalithi',
                          fontSize: 10.84,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Responsive TextField
                      TextField(
                        controller: reportController,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          if (errorMessage != null) {
                            setState(() {
                              errorMessage = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your message here',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                          errorText: errorMessage,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.84),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                minimumSize: const Size(0, 45),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 0.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.39,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                final message = reportController.text.trim();
                                if (message.isEmpty) {
                                  setState(() {
                                    errorMessage = "Please enter your message";
                                  });
                                  return;
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Report submitted successfully",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.39,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// logout

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 345,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),

                Text(
                  "Are you sure want\n to Logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: 280,
                  height: 59,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Provider.of<UserProvider>(
                      //   context,
                      //   listen: false,
                      // ).logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 280,
                  height: 59,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      foregroundColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// responsive helpers
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scale = (screenWidth / 375).clamp(0.8, 1.2);

    final headerHeight = screenHeight * 0.24;
    final cardWidth = screenWidth * 0.84;
    final cardHeight = 200 * scale;
    final avatarRadius = 30 * scale;
    final nameFontSize = 18 * scale;
    final smallFontSize = 13 * scale;
    // final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20 * scale),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 17 * scale, top: 10 * scale),
                    child: Row(
                      children: [
                        Text(
                          'Profile',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 32 * scale,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Ubuntu',
                            color: Colors.white,
                          ),
                        ),

                        Spacer(),

                        InkWell(
                          onTap: () {
                            _modalBottomSheetMenu(context);
                          },
                          child: SvgPicture.asset(
                            'assets/images/logout.svg',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8 * scale),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 20 * scale,
                              top: 23 * scale,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SessionManager.isPremium == 1
                                    ? Container(
                                        width: 80,
                                        height: 21,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF6901),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/images/fluent_premium-28-filled.svg",
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Premium",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: 67,
                                        height: 21,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD10A2D),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Icon(
                                                Icons.error,
                                                color: Color(0xFFFFFFFF),
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Basic",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),

                          CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: const Color(0xFFFFEECB),
                            child: ClipOval(
                              child: Image.network(
                                "https://i.pravatar.cc/150?img=55",
                                width: 60 * scale,
                                height: 60 * scale,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: 2 * scale),

                          Text(
                            SessionManager.name ?? "User",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              fontSize: nameFontSize,
                            ),
                          ),

                          SizedBox(height: 2 * scale),

                          Text(
                            SessionManager.phone ?? "",
                            style: TextStyle(
                              height: 1,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontSize: smallFontSize,
                            ),
                          ),

                          SizedBox(height: 5 * scale),

                          Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                Container(
                                  width: 34.64 * scale,
                                  height: 34.68 * scale,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE1DAFB),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 40,
                                      height: 20,
                                      child: SvgPicture.asset(
                                        'assets/images/d4.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10 * scale),

                                Column(
                                  children: [
                                    Text(
                                      'Rank',
                                      style: TextStyle(
                                        fontSize: 11 * scale,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),

                                    Text(
                                      _rank,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 13.02 * scale,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(width: 10 * scale),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 48 * scale),
                                  child: Container(
                                    width: 1,
                                    height: 32 * scale,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 18 * scale,
                                    ),
                                    color: const Color(0xFFD9D9D9),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34.64 * scale,
                                        height: 34.68 * scale,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE1DAFB),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 40,
                                            height: 30,
                                            child: SvgPicture.asset(
                                              'assets/images/Path.svg',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10 * scale),

                                      Column(
                                        children: [
                                          Text(
                                            'Points',
                                            style: TextStyle(
                                              fontSize: 11 * scale,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),

                                          Text(
                                            _points,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 13.02 * scale,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30 * scale),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            _ProfileMenuItem(
                              SvgPictureAsset: 'assets/images/d3.svg',
                              label: 'Apply Coupon code',
                              color: Color(0xFF4EDC8A),
                              onTap: () {},
                            ),
                            _ProfileMenuItem(
                              SvgPictureAsset: 'assets/images/d4.svg',
                              label: 'Leaderboard',
                              color: Color(0xFFB18AFF),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RankScreen(),
                                  ),
                                );
                              },
                            ),
                            _ProfileMenuItem(
                              SvgPictureAsset: 'assets/images/statics.svg',
                              label: 'Statistics',
                              color: Color(0xFF169EEA),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                            ),
                            _ProfileMenuItem(
                              SvgPictureAsset: 'assets/images/d2.svg',
                              label: 'Report a problem',
                              color: Color(0xFFF88F2E),
                              onTap: () {
                                _showReportDialog();
                              },
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Privacy policy',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14 * scale,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30 * scale),

                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Terms and conditions',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14 * scale,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String SvgPictureAsset;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.SvgPictureAsset,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // compute a local scale for menu items so they adapt on small/large screens
    final localScreenWidth = MediaQuery.of(context).size.width;
    final localScale = (localScreenWidth / 375).clamp(0.8, 1.2);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0 * localScale,
        vertical: 8 * localScale,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16 * localScale),
        onTap: onTap ?? () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * localScale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10 * localScale,
                offset: Offset(0, 3 * localScale),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              width: 38 * localScale,
              height: 38 * localScale,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10 * localScale),
                border: Border.all(
                  color: Colors.white,
                  width: 1.35 * localScale,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  SvgPictureAsset,
                  width: 22 * localScale,
                  height: 22 * localScale,
                  color: color,
                  fit: BoxFit.none,
                ),
              ),
            ),

            // show the provided label
            title: Text(
              label,
              style: TextStyle(
                fontSize: 14.85 * localScale,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: const Color(0xFF0E0D0E),
              ),
            ),

            trailing: Icon(
              Icons.chevron_right,
              color: const Color(0xFFB5B8CB),
              size: 20 * localScale,
            ),
          ),
        ),
      ),
    );
  }
}
