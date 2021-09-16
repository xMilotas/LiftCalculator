import 'package:flutter/material.dart';

List<Widget> dataFetchingIndicator() {
  return const <Widget>[
  SizedBox(
    child: CircularProgressIndicator(),
    width: 60,
    height: 60,
  ),
  Padding(
    padding: EdgeInsets.only(top: 16),
    child: Text('Fetching data...'),
  )
  ];
}