import 'package:flutter/material.dart';
import 'package:rm_characters/ui/screens/characters_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to the Rick & Morty application',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          backgroundColor: Colors.white
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: CharactersScreen(),
      ),
    );
  }

}