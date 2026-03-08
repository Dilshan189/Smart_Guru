import 'package:flutter/material.dart';
import 'package:smart_guru/screen/auth/register.screen.dart';
import 'package:smart_guru/utils/theam.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final bool isPhoneValid = phoneController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.08,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 58.29,
                    height: 48.57,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.06),

              // User Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2539A4), // Navy Blue circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              SizedBox(height: height * 0.02),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back ",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 30.06,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text("👋", style: TextStyle(fontSize: 26.19)),
                ],
              ),

              const SizedBox(height: 4),

              // Subtitle
              Text(
                "Sign in with your phone number",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13.09,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: height * 0.04),

              // Input Field
              CustomInputField(
                label: "",
                hint: "Enter your phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: height * 0.03),

              // Continue Button
              CustomThiredButton(
                text: "Continue",
                onPressed: isPhoneValid ? () {} : null,
                showArrow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
              : null,
        ),
      ),
    );
  }
}

class CustomThiredButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool showArrow;

  const CustomThiredButton({
    super.key,
    required this.text,
    this.onPressed,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isEnabled = onPressed != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isEnabled ? null : const Color(0xFFE5E7EB),
          gradient: isEnabled ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF1A2475).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isEnabled ? Colors.white : const Color(0xFF9CA3AF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: isEnabled ? Colors.white : const Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
