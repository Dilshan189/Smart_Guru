import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/screen/dashboard/home/home.screen.dart';
import 'package:smart_guru/screen/dashboard/profile/profile.home.screen.dart';
import 'package:smart_guru/screen/dashboard/revise/revise.screen.dart';
import '../../services/session.manager.dart';
import '../../utils/theam.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectIndex = 0;
  late final List<Widget> _pages;
  final GlobalKey<ReviseScreenState> _reviseKey = GlobalKey<ReviseScreenState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      ReviseScreen(key: _reviseKey),
      const ProfileHomeScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: selectIndex == 0 || selectIndex == 1
            ? AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: selectIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              SessionManager.name ?? "User",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Ready to practice today?",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Smart Revision",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Review and strengthen your weak areas",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
      
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EAF6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notification_add_rounded,
                          color: Color(0xFF3F51B5),
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
        body: IndexedStack(
          index: selectIndex.clamp(0, _pages.length - 1),
          children: _pages,
        ),
      
        /// Custom Bottom Navigation
        bottomNavigationBar: Container(
          height: 70,
          padding: const EdgeInsets.fromLTRB(26.87, 4.3, 26.87, 4.3),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF0EBF5), width: 1.61),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A05330F),
                blurRadius: 8.6,
                offset: const Offset(0, -4.3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem('assets/images/Icon.svg', "Home", 0),
              _buildNavItem('assets/images/Icon_1.svg', "Revise", 1),
              _buildNavItem('assets/images/Icon_3.svg', "Profile", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    final isSelected = selectIndex == index;
    final Color iconColor = isSelected
        ? AppColors.primary
        : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectIndex = index;
        });
        if (index == 1) {
          _reviseKey.currentState?.loadData();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: iconColor,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}
