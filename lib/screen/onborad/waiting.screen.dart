import 'package:flutter/material.dart';
import 'package:smart_guru/screen/onborad/purchase.premium.screen.dart';
import '../../utils/theam.dart';

class WaitingScreen extends StatefulWidget {
  final int initialStage;
  const WaitingScreen({super.key, this.initialStage = 0});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _shimmerController;
  late AnimationController _switchController;
  late int _stage;
  final List<String> _loadingTexts = [
    "Analyzing your preferences...",
    "Calibrating your learning path...",
    "Setting up premium features...",
    "Finalizing your personalized plan...",
  ];

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (_stage == 0) {
      _startProfiling();
    }
  }

  void _startProfiling() {
    _progressController.forward().then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PurchasePremium()),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _shimmerController.dispose();
    _switchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _buildStageContent(),
      ),
    );
  }

  Widget _buildStageContent() {
    switch (_stage) {
      case 0:
        return _buildProfilingStage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProfilingStage() {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressController, _shimmerController]),
      builder: (context, child) {
        final double progress = _progressController.value;
        final int percentage = (progress * 100).toInt();

        int textIndex = (progress * _loadingTexts.length).floor();
        if (textIndex >= _loadingTexts.length) {
          textIndex = _loadingTexts.length - 1;
        }

        return Container(
          key: const ValueKey(0),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(-3.14),
                  height: 603,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, -0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [Color(0x00D9D9D9), Color(0x7F2539A4)],
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            AppColors.primary,
                            Color(0xFF009BF3),
                            AppColors.primary,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                          begin: Alignment(
                            -1.0 + (_shimmerController.value * 3),
                            0,
                          ),
                          end: Alignment(
                            1.0 + (_shimmerController.value * 3),
                            0,
                          ),
                          tileMode: TileMode.clamp,
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "Creating your profile...",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 30,
                      child: Text(
                        _loadingTexts[textIndex],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900.withOpacity(0.7),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Circular Progress with Percentage
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.blue.shade50,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 52, 17, 248),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          "$percentage%",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
