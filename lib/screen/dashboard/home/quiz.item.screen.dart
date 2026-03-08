import 'package:flutter/material.dart';
import 'package:smart_guru/utils/theam.dart';

class QuizItemScreen extends StatelessWidget {
  final String title;

  const QuizItemScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "FMGanganee",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "$title සඳහා නව පිටුව", // "New page for [title]"
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "FMGanganee",
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
