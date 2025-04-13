import 'package:flutter/material.dart';
import 'package:heronfit/widgets/main_screen_wrapper.dart'; // Import MainScreenWrapper
import 'features/onboarding/views/splash_screen.dart';
import 'features/onboarding/views/onboarding_hero.dart';
import 'features/auth/views/login_widget.dart';
import 'features/auth/views/register01_widget.dart'; // Import RegisterWidget
import 'features/workout/views/add_exercise_screen.dart';
import 'features/workout/views/start_workout_from_template.dart'; // Import StartWorkoutFromTemplate
import 'features/workout/views/workout_complete_widget.dart'; // Import WorkoutCompleteWidget
import 'features/workout/views/workout_history_widget.dart'; // Import WorkoutHistoryWidget
import 'core/theme.dart';
import 'core/auth_guard.dart'; // Import AuthGuard

class HeronFitApp extends StatelessWidget {
  const HeronFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeronFit',
      theme: HeronFitTheme.lightTheme, // Apply custom theme
      home: SplashScreenWidget(), // Start with SplashScreen
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => AuthGuard(child: const MainScreenWrapper()),
            );
          case '/onboarding':
            return MaterialPageRoute(
              builder: (context) => const OnboardingWidget(),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginWidget());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterWidget(),
            );
          case '/add_exercise':
            return MaterialPageRoute(
              builder: (context) => AuthGuard(child: AddExerciseScreen()),
            );
          case '/workoutComplete':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (context) => AuthGuard(
                    child: WorkoutCompleteWidget(
                      workoutId: args['workoutId'],
                      workoutName: args['workoutName'],
                      startTime: args['startTime'],
                      endTime: args['endTime'],
                      exercises: args['exercises'],
                    ),
                  ),
            );
          case '/workoutHistory':
            return MaterialPageRoute(
              settings: settings,
              builder:
                  (context) => AuthGuard(child: const WorkoutHistoryWidget()),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreenWidget(),
            );
        }
      },
    );
  }
}
