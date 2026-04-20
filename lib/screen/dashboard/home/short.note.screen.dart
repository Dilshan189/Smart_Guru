import 'package:flutter/material.dart';
import 'package:smart_guru/screen/dashboard/home/pdf.viewer.screen.dart';
import 'package:smart_guru/utils/theam.dart';
import 'package:smart_guru/services/api.service.dart';
import 'package:smart_guru/services/session.manager.dart';


class ShortNoteScreen extends StatefulWidget {
  final String subjectId;
  const ShortNoteScreen({super.key, required this.subjectId});

  @override
  State<ShortNoteScreen> createState() => _ShortNoteScreenState();
}

class _ShortNoteScreenState extends State<ShortNoteScreen> {
  List<dynamic> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShortNotes();
  }

  Future<void> _fetchShortNotes() async {
    try {
      final token = SessionManager.token;
      final results = await CommerceService.getSubjectShortNote(
        subjectId: int.tryParse(widget.subjectId),
        token: token,
        status: "active",
      );
      setState(() {
        _notes = results.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching short notes: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF1E2939),
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "flá igy​ka",
                style: TextStyle(
                  fontFamily: 'FMGanganee',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.surfaceWhite,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? const Center(child: Text("No short notes available"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildNoteCard(
                    title: note["title"] ?? note["name"] ?? "",
                    subtitle: note["description"] ?? "",
                    pages:
                        "${note["page_count"] ?? note["pages"] ?? "0"} Pages",
                    tag: note["tag"] ?? "General",
                    subTag:
                        note["subject_name"] ?? note["category_name"] ?? "ECON",
                    thumbnailColor: const Color(0xFFF1F5F9), // Light grey background
                    coverImage: note["cover_image"],
                    pdfFile: note["pdf_file"],
                  ),
                );
              },
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
    String? coverImage,
    String? pdfFile,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (pdfFile != null && pdfFile.isNotEmpty) {
          final String cleanedPath =
              pdfFile.startsWith('/') ? pdfFile.substring(1) : pdfFile;
          final pdfUrl = "https://commerce.ideacipher.com/$cleanedPath";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                url: pdfUrl,
                title: title,
              ),
            ),
          );
        } else {
          debugPrint("pdfFile is null or empty");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                image: coverImage != null && coverImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                          "https://commerce.ideacipher.com/$coverImage",
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(
                      color: Color(0xFF1E293B), // Dark text
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
                      color: const Color(0xFF1E293B).withOpacity(0.5), // Subtle dark text
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
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontFamily: 'Inter',
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
      ),
    );
  }
}
