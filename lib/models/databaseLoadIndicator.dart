import 'package:flutter/material.dart';

List<Widget> dataFetchingIndicator() {
  return [
    Padding(
      padding: EdgeInsets.only(top: 16),
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 40,
        height: 40,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Fetching data...'),
      ),
  ];
}