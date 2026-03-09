import 'package:flutter/material.dart';
import 'package:smart_guru/utils/theam.dart';

class ShortNoteScreen extends StatefulWidget {
  const ShortNoteScreen({super.key});

  @override
  State<ShortNoteScreen> createState() => _ShortNoteScreenState();
}

class _ShortNoteScreenState extends State<ShortNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
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
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF1E2939),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "කෙටි සටහන්",
                style: TextStyle(
                  fontFamily: 'FMGanganee',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surfaceWhite,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGrey, width: 1),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search notes...",
                  hintStyle: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Reading Section
            const Text(
              "Continue Reading",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildNoteCard(
              title: "වෙළඳ පොළට රජය මැදිහත් වන ආකාරය",
              subtitle: "විෂය කොටස්වලට අදාල කෙටි සටහන් මෙහි ඇතුලත් වේ.",
              pages: "12 Pages",
              tag: "Demand\n& Supply",
              subTag: "ECONOMICS",
              thumbnailColor: const Color(0xFF717986),
            ),
            const SizedBox(height: 24),

            // Short Notes Section
            const Text(
              "Short Notes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildNoteCard(
              title: "වෙළඳ පොළට රජය මැදිහත් වන ආකාරය",
              subtitle: "විෂය කොටස්වලට අදාල කෙටි සටහන් මෙහි ඇතුලත් වේ.",
              pages: "12 Pages",
              tag: "Demand\n& Supply",
              subTag: "ECONOMICS",
              thumbnailColor: const Color(0xFFF07D3E),
              thumbnailGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF07D3E), Color(0xFFFBB13C)],
              ),
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              title: "වෙළඳ පොළට රජය මැදිහත් වන ආකාරය",
              subtitle: "විෂය කොටස්වලට අදාල කෙටි සටහන් මෙහි ඇතුලත් වේ.",
              pages: "12 Pages",
              tag: "Demand\n& Supply",
              subTag: "ECONOMICS",
              thumbnailColor: const Color(0xFF97A2B0),
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              title: "වෙළඳ පොළට රජය මැදිහත් වන ආකාරය",
              subtitle: "විෂය කොටස්වලට අදාල කෙටි සටහන් මෙහි ඇතුලත් වේ.",
              pages: "12 Pages",
              tag: "Demand\n& Supply",
              subTag: "ECONOMICS",
              thumbnailColor: const Color(0xFF2E3E9C),
            ),
            const SizedBox(height: 12),
            _buildNoteCard(
              title: "වෙළඳ පොළට රජය මැදිහත් වන ආකාරය",
              subtitle: "විෂය කොටස්වලට අදාල කෙටි සටහන් මෙහි ඇතුලත් වේ.",
              pages: "12 Pages",
              tag: "Demand\n& Supply",
              subTag: "ECONOMICS",
              thumbnailColor: const Color(0xFF2E77F6),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard({
    required String title,
    required String subtitle,
    required String pages,
    required String tag,
    required String subTag,
    required Color thumbnailColor,
    Gradient? thumbnailGradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 95,
            height: 125,
            decoration: BoxDecoration(
              color: thumbnailColor,
              gradient: thumbnailGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTag,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    fontFamily: 'FMGanganee',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontFamily: 'FMGanganee',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  pages,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
