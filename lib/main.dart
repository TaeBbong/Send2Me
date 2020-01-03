import 'package:flutter/material.dart';
import './chat_screen.dart';
import './list_screen.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

const String _name = "User Name";

final routes = {
  '/': (BuildContext context) => ChatScreen(),
  '/first': (BuildContext context) => ChatScreen(),
  '/second': (BuildContext context) => ListScreen(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY MEMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
