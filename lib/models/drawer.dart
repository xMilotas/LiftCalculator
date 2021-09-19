import 'package:flutter/material.dart';

buildDrawer(context) => Drawer(
      child: ListView(
        controller: ScrollController(),
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: const Text('Configure 1RM/TM'),
            onTap: () {
              Navigator.pushNamed(context, '/trainingConfig');
            },
          ),
          ListTile(
            leading: Icon(Icons.android_sharp),
            title: const Text('DEBUG: DB DUMP'),
            onTap: () {
              Navigator.pushNamed(context, '/DbDumpScreen');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: const Text('Configure TM'),
            onTap: () {
              Navigator.pushNamed(context, '/trainingMax');
            },
          )
        ],
      ),
    );


    