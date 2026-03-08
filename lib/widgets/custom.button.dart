import 'package:flutter/material.dart';
import '../utils/theam.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        decoration: ShapeDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Gradient? gradient;
  final bool isEnabled;

  const CustomButton2({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.gradient,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        decoration: ShapeDecoration(
          gradient: isEnabled ? (gradient ?? AppColors.primaryGradient) : null,
          color: isEnabled ? null : const Color(0xFFE5E7EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEnabled ? Colors.white : const Color(0xFF99A1AF),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward,
              color: isEnabled ? Colors.white : const Color(0xFF99A1AF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
