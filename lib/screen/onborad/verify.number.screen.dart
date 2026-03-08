import 'package:flutter/material.dart';
import '../../utils/theam.dart';
import '../../widgets/custom.button.dart';
import 'about.screen.dart';

class VerifyNumberScreen extends StatefulWidget {
  const VerifyNumberScreen({super.key});

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus to show the keyboard on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            const Positioned(
              left: 20,
              right: 20,
              top: 145,
              child: Text(
                'Verify your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 236,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'We’ve sent an SMS with an activation\n code to your phone ',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.70),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                    const TextSpan(
                      text: '076 648 3484',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 311,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCodeBox(
                    _pinController.text.length > 0
                        ? _pinController.text[0]
                        : "",
                    _isError,
                    _pinController.text.length == 0,
                  ),
                  _buildCodeBox(
                    _pinController.text.length > 1
                        ? _pinController.text[1]
                        : "",
                    _isError,
                    _pinController.text.length == 1,
                  ),
                  _buildCodeBox(
                    _pinController.text.length > 2
                        ? _pinController.text[2]
                        : "",
                    _isError,
                    _pinController.text.length == 2,
                  ),
                  _buildCodeBox(
                    _pinController.text.length > 3
                        ? _pinController.text[3]
                        : "",
                    _isError,
                    _pinController.text.length == 3,
                  ),
                  _buildCodeBox(
                    _pinController.text.length > 4
                        ? _pinController.text[4]
                        : "",
                    _isError,
                    _pinController.text.length == 4,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 437,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I didn’t receive a code ',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.70),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isError)
              Positioned(
                left: 20,
                right: 20,
                top: 390,
                child: const Text(
                  'Wrong code, please try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF04438),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Positioned(
              left: 20,
              right: 20,
              top: 481,
              child: CustomButton(
                text: 'Verify',
                onPressed: () {
                  final otp = _pinController.text.trim();
                  if (otp.length == 5) {
                    if (otp == '00000') {
                      setState(() {
                        _isError = false;
                      });
                      // Navigate to About Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    } else {
                      setState(() {
                        _isError = true;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter 5 digit code"),
                      ),
                    );
                  }
                },
              ),
            ),
            // Hidden TextField to capture numeric input
            Opacity(
              opacity: 0,
              child: SizedBox(
                width: 0,
                height: 0,
                child: TextField(
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (value) {
                    setState(() {});
                    if (_isError) {
                      setState(() {
                        _isError = false;
                      });
                    }
                  },
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 50,
              child: Container(
                width: 39,
                height: 39,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFD8DADC)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBox(String code, bool isError, bool isFocused) {
    return Container(
      width: 63,
      height: 64,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isError ? const Color(0xFFF04438) : const Color(0xFFD8DADC),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox.expand(),
          if (isFocused && code.isEmpty)
            Positioned(
              bottom: 12,
              child: Container(
                width: 25,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          Center(
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
