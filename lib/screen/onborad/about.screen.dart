import 'package:flutter/material.dart';
import '../../utils/theam.dart';
import '../../widgets/custom.button.dart';
import 'waiting.screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final PageController _pageController = PageController();
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _currentPage = 0;
  bool _isButtonEnabled = false;

  final List<Map<String, String>> _questions = [
    {
      'question': 'Which district are you\nfrom?',
      'placeholder': 'Enter your district',
    },
    {
      'question': 'What school do you\nattend?',
      'placeholder': 'Enter your school name',
    },
    {
      'question': 'When will you take your\nA/L exam?',
      'placeholder': '2025 A/L',
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _controllers[_currentPage].text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var w = size.width;
    var h = size.height;

    double sw(double v) => (v / 390.0) * w;
    double sh(double v) => (v / 844.0) * h;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: EdgeInsets.only(left: sw(20), top: sh(20)),
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: sw(39),
                    height: sw(39),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: sw(1),
                          color: Color(0xFFD8DADC),
                        ),
                        borderRadius: BorderRadius.circular(sw(10)),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new, size: sw(16)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: sh(20)),
            // Line Progress Indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw(100)),
              child: Stack(
                children: [
                  Container(
                    height: sh(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(sw(10)),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: sh(10),
                    width:
                        (MediaQuery.of(context).size.width - sw(200)) *
                        ((_currentPage + 1) / _questions.length),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(sw(10)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh(40)),
            // Question Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _updateButtonState();
                  });
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw(20)),
                    child: Column(
                      children: [
                        Text(
                          _questions[index]['question']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: sw(24),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: sh(30)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sw(16),
                            vertical: sh(8),
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: sw(1),
                                color: Color(0xFFD8DADC),
                              ),
                              borderRadius: BorderRadius.circular(sw(10)),
                            ),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              hintText: _questions[index]['placeholder'],
                              hintStyle: TextStyle(
                                color: Colors.black.withValues(alpha: 0.3),
                                fontSize: sw(16),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: sh(25)),
                        CustomButton2(
                          text: 'Next',
                          isEnabled: _isButtonEnabled,
                          onPressed: () {
                            if (_currentPage < _questions.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WaitingScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
