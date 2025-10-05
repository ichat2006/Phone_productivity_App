import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/usage_service.dart';

class UsageProvider with ChangeNotifier {
  bool _needInterventionPrompt = false;
  String _promptMessage = '';
  int _promptCount = 0;
  DateTime? _lastPromptTime;
  Timer? _timer;

  bool get needInterventionPrompt => _needInterventionPrompt;
  String get promptMessage => _promptMessage;
  int get interventionCount => _promptCount;

  UsageProvider() {
    // Only track usage on Android; on iOS, use dummy reminder logic
    if (Platform.isAndroid) {
      // Check usage periodically (e.g., every minute)
      _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
        // Avoid prompting too frequently (e.g., minimum 30 minutes apart)
        if (_lastPromptTime != null &&
            DateTime.now().difference(_lastPromptTime!) < const Duration(minutes: 30)) {
          return;
        }
        // Only proceed if a user is logged in
        if (FirebaseAuth.instance.currentUser == null) return;
        bool excessive = await UsageService.checkExcessiveUsage();
        if (excessive) {
          _needInterventionPrompt = true;
          _promptMessage = 'You’ve been spending a lot of time away from the app. Time to refocus on your tasks?';
          _promptCount += 1;
          _lastPromptTime = DateTime.now();
          notifyListeners();
        }
      });
    } else {
      // Dummy logic on iOS: show a generic prompt after a delay (since usage data is unavailable)
      _timer = Timer(const Duration(minutes: 1), () {
        _needInterventionPrompt = true;
        _promptMessage = 'Stay productive! Remember to focus on your tasks.';
        _promptCount += 1;
        _lastPromptTime = DateTime.now();
        notifyListeners();
      });
    }
  }

  // Call this after showing the intervention prompt to reset the flag
  void clearPrompt() {
    _needInterventionPrompt = false;
    _promptMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
