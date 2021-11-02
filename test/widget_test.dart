// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/ui/screens/characters_details_screen.dart';
import 'package:rm_characters/ui/widgets/favorite_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void main() {
  late Character character;
  setUp(() async {
    final file = File('test_resources/Character1.json');
    final json = jsonDecode(await file.readAsString());
    character = Character.fromJSON(json);
  });
  testWidgets("Check if character is favorite in card", (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      SharedPreferences.setMockInitialValues({}); //set values here
      final pref = await StreamingSharedPreferences.instance;
      await pref.setBool("${character.id}", true);
      final widget = MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: FavoriteButton(idPreference: character.id.toString(), onFavoriteTap: () {},))
      );
      await tester.pumpWidget(widget);

      final favIconFinder = find.byIcon(Icons.favorite);
      final unfavIconFinder = find.byIcon(Icons.favorite_border);

      expect(favIconFinder, findsNothing);
      expect(unfavIconFinder, findsNothing);
    });
  });

  testWidgets("Check if character is favorite in detail screen", (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: CharacterDetailsScreen(character: character, onFavoriteTap: () {},))
      ));

      final favIconFinder = find.byIcon(Icons.favorite);
      //final unfavIconFinder = find.byIcon(Icons.favorite_border);

      expect(favIconFinder, findsNothing);
      //expect(unfavIconFinder, findsOneWidget);
    });
  });
}
