import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';
import 'quize.screen.dart';

class LevelScreen extends StatefulWidget {
  final String title;
  final String lessonId;
  final String subjectId;

  const LevelScreen({
    super.key,
    required this.title,
    required this.lessonId,
    required this.subjectId,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  List<dynamic> levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    try {
      final String? token = SessionManager.token;
      final List<dynamic> fetchedLevels =
          await CommerceService.getSubjectLessonLevel(
            subjectId: int.tryParse(widget.subjectId ?? ''),
            lessonId: int.tryParse(widget.lessonId),
            token: token,
            status: "active",
          );

      setState(() {
        levels = fetchedLevels;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching subject lesson levels: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: "FMGanganee",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : levels.isEmpty
          ? const Center(child: Text("No levels available"))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return _buildLevelCard(level, index);
              },
            ),
    );
  }

  Widget _buildLevelCard(dynamic item, int index) {
    final String levelName = item["level_name"] ?? "Level ${index + 1}";
    final bool isPremium = item["is_premium"] == "1" || item["is_premium"] == 1;

    final bool isLocked = index > 0 && !(isPremium);

    return InkWell(
      onTap: () {
        if (!isLocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                levelName: levelName,
                categoryTitle: widget.title,
                questions: const [],
                data: const [],
                categoryId: widget.lessonId, // mapped to lessonId in QuizScreen
                levelId: item["id"]?.toString() ?? index.toString(),
                subjectId: widget.subjectId,
                allLevels: levels
                    .map(
                      (l) => {
                        "level": l["level_name"],
                        "level_id": l["id"],
                        "cat_id": widget.lessonId,
                        "questions": [],
                      },
                    )
                    .toList(),
                currentLevelIndex: index,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLocked
                ? Colors.blue.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  levelName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isLocked
                        ? const Color(0xFFABC4FF)
                        : const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBE6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isLocked
                          ? "assets/images/Group 512878.svg"
                          : "assets/images/uis_unlock.svg",
                      colorFilter: ColorFilter.mode(
                        isLocked
                            ? const Color(0xFF8DA9FF)
                            : const Color(0xFF1E3A8A),
                        BlendMode.srcIn,
                      ),
                      width: 22,
                      height: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!isPremium)
                  Text(
                    isLocked ? "Locked" : "Unlocked",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? const Color(0xFFABC4FF)
                          : const Color(0xFF1E3A8A),
                    ),
                  ),
              ],
            ),
            if (isPremium)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 21,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D4990),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Premium",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        "assets/images/fluent_premium-28-filled.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 12,
                        height: 12,
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
}
