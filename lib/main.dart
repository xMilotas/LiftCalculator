import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/screens/training_max_screen.dart';

import 'models/trainingMax.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserProfileAsync.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            title: 'Lift Calculator',
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.grey.shade900,
              primaryColor: Colors.black,
              colorScheme: ColorScheme.dark(),
              iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
            ),
            home: Provider(
              create: (_) => 
                User(
                  UserProfileAsync.instance.liftList, 
                  UserProfileAsync.instance.currentTrainingMaxPercentage
                  ), 
              child: TrainingMaxConfigScreen()
              ), 
          );
        }
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

class User{
  List<TrainingMax> liftList;
  int trainingMaxPercentage;
  User(this.liftList, this.trainingMaxPercentage);
}

// With this we can only pass user profile to 1 screen, should probably switch to a different solution
// Maybe use the boilerplate from the guy
// I also don't like the "rebuilding" of the class

// What defines a training? i.e. how is it calculated

// The excercise, cycle, week, Training Max -- using these we can calc everything?
// (This defines the overall plan for the 4 lifts)
// per lift we need an doneMarker to indicate if the week is complete or not (completedStatus)
// in theory I want to be able to choose which lift I perform 
