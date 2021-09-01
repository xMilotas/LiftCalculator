import 'package:flutter/material.dart';
import 'package:liftcalculator/screens/settings_screen.dart';

buildAppBar(context, [String? title]){
String appBarTitle = 'Lift Calculator';
if(title != null) appBarTitle = title;

return AppBar(
      centerTitle: true,
      title: Text(appBarTitle),
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
}