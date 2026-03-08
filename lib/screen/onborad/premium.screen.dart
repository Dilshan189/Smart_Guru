import 'package:flutter/material.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.identity()
        ..translate(0.0, 0.0)
        ..rotateZ(-3.14),
      width: 390,
      height: 603,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [const Color(0x00D9D9D9), const Color(0x7F2539A4)],
        ),
      ),
    );
  }
}
