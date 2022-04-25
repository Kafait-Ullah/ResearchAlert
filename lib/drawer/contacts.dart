import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 34, 53, 51),
          title: Text('Contact Us'),
        ),
        body: Center(
          child: Text('Kafaitbhatti.cs@gmail.com'),
        ),
      ),
    );
  }
}
