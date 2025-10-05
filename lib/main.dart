import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart' as app_auth; // 👈 alias to avoid name clash
import 'providers/task_provider.dart';
import 'providers/usage_provider.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/weekly_review_screen.dart';



Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <-- and this
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final user = FirebaseAuth.instance.currentUser;

  final initialRoute = user != null
      ? '/home'
      : (seenOnboarding ? '/login' : '/onboarding');

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  // 👇 make this optional with a default so tests using const MyApp() work
  final String initialRoute;
  const MyApp({super.key, this.initialRoute = '/login'});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UsageProvider()),
      ],
      child: MaterialApp(
        title: 'ProductiveApp',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: initialRoute,
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/add-task': (context) => const AddTaskScreen(),
          '/edit-task': (context) => const EditTaskScreen(),
          '/task-detail': (context) => const TaskDetailScreen(),
          '/weekly-review': (context) => const WeeklyReviewScreen(),
        },
      ),
    );
  }
}

