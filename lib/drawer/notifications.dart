import 'package:flutter/material.dart';

class Notificationss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 34, 53, 51),
          title: Text('Notifications Page'),
        ),
        body: Center(
          child: Text('Notifications will be there'),
        ),
      ),
    );
  }
}
