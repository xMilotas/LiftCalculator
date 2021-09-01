import 'package:flutter/material.dart';

buildDrawer(context) => Drawer(
      child: ListView(
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
              Navigator.pushReplacementNamed(context, '/trainingConfig');
            },
          )
        ],
      ),
    );
