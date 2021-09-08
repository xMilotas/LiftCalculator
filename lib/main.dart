import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liftcalculator/screens/excercise_screen.dart';
import 'package:liftcalculator/screens/home_screen.dart';
import 'package:liftcalculator/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/screens/training_max_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfile(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lift Calculator',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.dark(),
        iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/trainingConfig': (context) => TrainingMaxConfigScreen(),
        '/excercise': (context) => ExcerciseScreen(),
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(child: Image.asset('graphics/splash.png')),
    );
  }
}
