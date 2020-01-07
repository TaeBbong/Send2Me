import 'package:flutter/material.dart';
import './chat_screen.dart';
import './list_screen.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

const String _name = "User Name";

final routes = {
  '/': (BuildContext context) => ChatScreen(),
  '/first': (BuildContext context) => ChatScreen(),
  '/second': (BuildContext context) => ListScreen(),
};

class MyApp extends StatelessWidget {
  MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY MEMO',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff28385e),
        child: Center(
          child: Image.asset('images/my_logo.png'),
        ),
      ),
    );
  }
}
