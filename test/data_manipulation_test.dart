// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:rm_characters/data/models/character.dart';

void main() {
  group("JSON", () {
    test("Correctly deserialize JSON Character object", () async {
      final file = File('test_resources/Character1.json');
      final json = jsonDecode(await file.readAsString());
      final character = Character.fromJSON(json);
      expect("Rick Sanchez", character.name);
      expect(1, character.id);
      expect("Alive", character.status);
      expect("Human", character.species);
      expect("Earth (C-137)", character.origin.name);
      expect("Earth (Replacement Dimension)", character.location.name);
    });
  });
}
