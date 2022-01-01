import 'package:flutter/material.dart';
//TODO: exclude all the widgets imports
import 'package:flutter/widgets.dart';
import 'package:liftcalculator/models/changeLiftDialog.dart';
import 'package:liftcalculator/models/dbLift.dart';
import 'package:liftcalculator/models/selectedLift.dart';
import 'package:liftcalculator/screens/assistance_editor_screen.dart';
import 'package:liftcalculator/screens/assistance_screen.dart';
import 'package:liftcalculator/screens/cycle_overview_screen.dart';
import 'package:liftcalculator/screens/db_dump_screen.dart';
import 'package:liftcalculator/screens/exercise_screen.dart';
import 'package:liftcalculator/screens/home_screen.dart';
import 'package:liftcalculator/screens/settings_screen.dart';
import 'package:liftcalculator/screens/stats_as_text_screen.dart';
import 'package:liftcalculator/screens/stats_per_day_screen.dart';
import 'package:liftcalculator/screens/stats_screen.dart';
import 'package:liftcalculator/screens/training_max_display_screen.dart';
import 'package:liftcalculator/util/weight_reps.dart';
import 'package:provider/provider.dart';

import 'package:liftcalculator/models/profile.dart';
import 'package:liftcalculator/screens/training_max_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
            ChangeNotifierProvider(
              create: (context) => UserProfile()
            ),
            ChangeNotifierProvider(create: (context) => LiftSelector()),
            ChangeNotifierProvider(create: (context) => StatsSelectedLift(DbLift(0,DateTime.now(),WeightReps(0,0))))
      ],
      child: MyApp(),
    )

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
        '/trainingMax': (context) => TrainingMaxScreen(),
        '/exercise': (context) => ExerciseScreen(),
        '/DbDumpScreen': (context) => DbDumpScreen(),
        '/stats': (context) => StatsScreen(),
        '/cycleOverview': (context) => CycleOverviewScreen(),
        '/diary': (context) => StatsPerDayScreen(),
        '/assistanceEditor': (context) => AssistanceEditorScreen(),
        '/assistance': (context) => AssistanceScreen(),
        '/statsAsText': (context) => StatsTextScreen()
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00121D),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
              child: Image.asset("graphics/icon.png"),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),

              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color> (Colors.white),
              )
            ]
        )
      )
    );
  }
}
