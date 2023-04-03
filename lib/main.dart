// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/providers/recipe_provider.dart';
import 'package:recipe_finder/screens/home_screen.dart';
import 'package:recipe_finder/screens/splash_screen.dart';


//The app begins here

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: MaterialApp(
        title: 'Recipe Finder',
        theme: ThemeData(primarySwatch: Colors.green),
        home: MyApp(),
      ),

    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
