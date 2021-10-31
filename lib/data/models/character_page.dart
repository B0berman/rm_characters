import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/data/models/page_info.dart';

class CharacterPage {
  final PageInfo info;
  final List<Character> characters;

  CharacterPage(this.info, this.characters);
}