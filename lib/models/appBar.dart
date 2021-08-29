import 'package:flutter/material.dart';
import 'package:liftcalculator/screens/settings_screen.dart';

buildAppBar(context) => AppBar(
      centerTitle: true,
      title: Text('Lift Calculator'),
      actions: [
        IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen()
                  ),
                );
            },
          ),
      ],
    );
