import 'package:flutter/material.dart';
import 'package:hytribe/onboardingcard.dart';
import 'package:hytribe/signup.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  static final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> onBoardingPages = [
      onboardingcard(
        image: "assets/images/1.jpeg",
        logo: "assets/images/log.png",
        title:
            "Hytribe is a social mental wellness platform that fosters online support communities called hives",
        buttonText: "Next",
        onPressed: () {
          _pageController.animateToPage(1,
              duration: Durations.long1, curve: Curves.linear);
        },
      ),
      onboardingcard(
        image: "assets/images/2.jpeg",
        logo: "assets/images/log.png",
        title:
            "Our mission is to foster belonging and involvement within people through tribes",
        onPressed: () {
          _pageController.animateToPage(2,
              duration: Durations.long1, curve: Curves.linear);
        },
        buttonText: "Next",
      ),
      onboardingcard(
        image: "assets/images/3.jpeg",
        logo: "assets/images/log.png",
        title: "Define yourself. Tell your story.",
        onPressed: () {
          _pageController.animateToPage(3,
              duration: Durations.long1, curve: Curves.linear);
        },
        buttonText: "Next",
      ),
      onboardingcard(
        image: "assets/images/4.jpeg",
        logo: "assets/images/log.png",
        title: "Create a hive with power. Connect to people like you.",
        buttonText: "Next",
        onPressed: () {
          _pageController.animateToPage(4,
              duration: Durations.long1, curve: Curves.linear);
        },
      ),
      onboardingcard(
        image: "assets/images/5.png",
        logo: "assets/images/log.png",
        title: "Drop-in or host audio conversations about anything at anytime.",
        buttonText: "Enter",
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(
              'first_time', false); // 👈 save that onboarding is done

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: onBoardingPages, // Use the local list
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 5,
            )
          ],
        ),
      ),
    );
  }
}
