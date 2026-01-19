import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage the interactive tutorial flow
class TutorialService extends ChangeNotifier {
  static final TutorialService _instance = TutorialService._internal();
  factory TutorialService() => _instance;
  TutorialService._internal();

  bool _tutorialActive = false;
  int _currentStep = 0;

  // Global keys for showcase targets
  final GlobalKey settingsButtonKey = GlobalKey();
  final GlobalKey myCarsKey = GlobalKey();
  final GlobalKey addCarButtonKey = GlobalKey();
  final GlobalKey carNameFieldKey = GlobalKey();
  final GlobalKey saveCarButtonKey = GlobalKey();

  bool get tutorialActive => _tutorialActive;
  int get currentStep => _currentStep;

  /// Start the tutorial after onboarding
  Future<void> startTutorial() async {
    _tutorialActive = true;
    _currentStep = 0;
    notifyListeners();
  }

  /// Move to next step
  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  /// Complete the tutorial
  Future<void> completeTutorial() async {
    _tutorialActive = false;
    _currentStep = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_complete', true);
    notifyListeners();
  }

  /// Skip the tutorial
  Future<void> skipTutorial() async {
    await completeTutorial();
  }

  /// Check if tutorial was already completed
  Future<bool> isTutorialComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorial_complete') ?? false;
  }

  /// Reset tutorial (for testing)
  Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tutorial_complete');
    _tutorialActive = false;
    _currentStep = 0;
    notifyListeners();
  }
}
