import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/screen/dashboard/nav.wrapper.dart';
import 'package:smart_guru/utils/theam.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  String selectedTab = "All";

  final List<Map<String, dynamic>> leaderboard = [
    {
      "rank": 1,
      "name": "Bryan Wolf",
      "points": 43,
      "image": "https://i.pravatar.cc/150?u=1",
    },
    {
      "rank": 2,
      "name": "Meghan Jes...",
      "points": 40,
      "image": "https://i.pravatar.cc/150?u=2",
    },
    {
      "rank": 3,
      "name": "Alex Turner",
      "points": 38,
      "image": "https://i.pravatar.cc/150?u=3",
    },
    {
      "rank": 4,
      "name": "Marsha Fisher",
      "points": 36,
      "image": "https://i.pravatar.cc/150?u=4",
    },
    {
      "rank": 5,
      "name": "Juanita Cormier",
      "points": 35,
      "image": "https://i.pravatar.cc/150?u=5",
    },
    {
      "rank": 6,
      "name": "Charles Hapmer",
      "points": 34,
      "image": "https://i.pravatar.cc/150?u=6",
    },
    {
      "rank": 7,
      "name": "Tamara Schmidt",
      "points": 33,
      "image": "https://i.pravatar.cc/150?u=7",
    },
    {
      "rank": 8,
      "name": "Ricardo Veum",
      "points": 32,
      "image": "https://i.pravatar.cc/150?u=8",
    },
    {
      "rank": 9,
      "name": "Gary Sanford",
      "points": 31,
      "image": "https://i.pravatar.cc/150?u=9",
    },
  ];

  final Map<String, dynamic> userRank = {
    "rank": 16,
    "name": "Tharindu Fernando",
    "points": 34,
    "image": "https://i.pravatar.cc/150?u=16",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavigationScreen(),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Island Rank",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 5, 64, 153),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTab("All"),
                  _buildTab("Monthly"),
                  _buildTab("Weekly"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Podium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPodiumUser(leaderboard[1], 80, 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildPodiumUser(leaderboard[0], 100, 1),
                  ),
                  _buildPodiumUser(leaderboard[2], 80, 3),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Leaderboard List
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: leaderboard.length - 3,
                  itemBuilder: (context, index) {
                    final user = leaderboard[index + 3];
                    return _buildLeaderboardItem(user);
                  },
                ),
              ),
            ),
            // User Sticky Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Text(
                      "${userRank['rank']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(width: 20),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(userRank['image']),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        userRank['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Poppins",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${userRank['points']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    bool isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0056D2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumUser(Map<String, dynamic> user, double size, int rank) {
    bool isFirst = rank == 1;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (isFirst)
              Positioned(
                top: -35,
                child: Image.asset(
                  'assets/images/abc.png',
                  width: 41.51,
                  height: 41.51,
                ),
              ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                image: DecorationImage(
                  image: NetworkImage(user['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "$rank",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          user['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          "${user['points']}",
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          WidthSizeBox(
            width: 30,
            child: Text(
              "${user['rank']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user['image']),
          ),
          const SizedBox(width: 12),
          Text(
            user['name'],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const Spacer(),
          Text(
            "${user['points']}",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WidthSizeBox extends StatelessWidget {
  final double width;
  final Widget child;
  const WidthSizeBox({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}
