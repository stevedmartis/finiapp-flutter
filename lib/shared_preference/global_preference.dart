import 'package:shared_preferences/shared_preferences.dart';

Future<void> setOnboardingCompleted() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("hasCompletedOnboarding", true);
}

Future<bool> hasUserCompletedOnboarding() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("hasCompletedOnboarding") ?? false;
}
