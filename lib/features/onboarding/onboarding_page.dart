import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Sync with Nature 🌿",
      "desc": "Stay in tune with nature’s rhythm for a balanced lifestyle."
    },
    {
      "title": "Effortless Sync 🔄",
      "desc": "Your schedule automatically adapts to your surroundings."
    },
    {
      "title": "Relax & Unwind 😌",
      "desc": "Set reminders, breathe easy, and enjoy your peace of mind."
    },
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
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
        itemCount: _pages.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  _pages[index]["title"]!,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  _pages[index]["desc"]!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Next / Get Started Button
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    index == _pages.length - 1 ? "Get Started" : "Next",
                  ),
                ),

                // Skip Button
                if (index < _pages.length - 1)
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, "/location"),
                    child: const Text("Skip"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}