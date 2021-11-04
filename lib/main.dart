import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rm_characters/data/services/character_service.dart';
import 'package:rm_characters/ui/screens/characters_page.dart';

void main() {
  Bloc.observer = BlocObserver();
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
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CharacterService>(
            create: (context) => CharacterService(),
          ),
        ],
        child: const CharactersPage(),
      ),
    );
  }

}