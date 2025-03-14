import 'package:flutter/material.dart';
import 'package:shopping_list/screens/groceries_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Groceries",
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 147, 229, 250),
              brightness: Brightness.dark),
        ),
        home: GroceriesScreen());
  }
}
