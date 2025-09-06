import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app/constants/colors.dart';
import 'package:flutter_onboarding_app/common_widgets/my_button.dart';
import 'onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, "/location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: AppColors.primaryColor,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          data.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: AppColors.primaryColor,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 28,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data.desc,
                              style: TextStyle(color: AppColors.onPrimary, fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: DotsIndicator(
                                dotsCount: onboardingData.length,
                                position: _currentIndex.toDouble(),
                                decorator: DotsDecorator(
                                  color: AppColors.onPrimary.withOpacity(
                                    0.2,
                                  ), // Inactive color
                                  activeColor: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            MyButton(
                              onTap: _nextPage,
                              buttonBackgroundColor: AppColors.secondaryColor,
                              buttonText: index == onboardingData.length - 1
                                  ? "Get Started"
                                  : "Next",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (index < onboardingData.length - 1)
                Positioned(
                  top: 40,
                  right: 30,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, "/location"),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: AppColors.onPrimary),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
