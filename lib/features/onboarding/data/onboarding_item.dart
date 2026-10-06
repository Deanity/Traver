import 'package:traver/core/constants/app_constants.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
  });

  static const List<OnboardingItem> defaultItems = [
    OnboardingItem(
      title: 'Lets explore\nthe world',
      description: "let's explore the world with us with just a few clicks",
      imagePath: AssetPaths.onboarding1,
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: 'Visit tourist\nattractions',
      description: 'Find thousands of tourist destinations ready for you to visit',
      imagePath: AssetPaths.onboarding2,
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: 'Get ready for\nnext trip',
      description: 'Find thousands of tourist destinations ready for you to visit',
      imagePath: AssetPaths.onboarding3,
      buttonText: 'Get Started',
    ),
  ];
}
