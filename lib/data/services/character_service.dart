
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/data/models/character_page.dart';
import 'package:rm_characters/data/models/page_info.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

const baseUrl = "https://rickandmortyapi.com/api/character";

class CharacterService {
  Future<CharacterPage> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final characters = _parseCharacters(response.body);
      final pageInfo = _parsePageInfo(response.body);

      return CharacterPage(pageInfo, characters);
    }
    throw Exception('Failed to load characters');
  }

  Future<CharacterPage> getCharacters({String name = "", String page = "1"}) async {
    final nameQuery = name.isEmpty ? "" : "&name=$name";
    final response = await http.get(Uri.parse("$baseUrl/?page=$page$nameQuery"));
    if (response.statusCode == 200) {
      final characters = _parseCharacters(response.body);
      final pageInfo = _parsePageInfo(response.body);

      return CharacterPage(pageInfo, characters);
    }
    throw Exception(json.decode(response.body)["error"] as String);
  }

  Future<List<Character>> getCharactersByIds(Set<String> ids) async {
    var url = "$baseUrl/${ids.join(',')}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return _parseCharacters("{\"results\":${response.body}}");
    }
    throw Exception('Failed to load characters');
  }

  Future<Character> getOne(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/${id.toString()}"));
    if (response.statusCode == 200) {
      return Character.fromJSON(json.decode(response.body));
    }
    throw Exception('Failed to load character');
  }

  PageInfo _parsePageInfo(String responseBody) {
    final parsed = json.decode(responseBody)["info"];
    return PageInfo.fromJSON(parsed);
  }

  List<Character> _parseCharacters(String responseBody) {
    final parsed = json.decode(responseBody)["results"].cast<Map<String, dynamic>>();
    return parsed.map<Character>((json) => Character.fromJSON(json)).toList();
  }


  Future<bool> setFavorite(int id) async {
    final sp = await StreamingSharedPreferences.instance;
    final current = sp.getBool(id.toString(), defaultValue: false).getValue();
    if (await sp.setBool(id.toString(), !current)) {
      return !current;
    }
    return current;
  }

  Future<List<Character>> getFavorites() async {
    final ids = await _getFavoritesInPrefs();
    return getCharactersByIds(ids);
  }

  Future<Set<String>> _getFavoritesInPrefs() async {
    final sp = await StreamingSharedPreferences.instance;
    final keys = sp.getKeys().getValue();
    final Set<String> favorites = {};
    for (var element in keys) {
      if (sp.getBool(element, defaultValue: false).getValue()) {
        favorites.add(element);
      }
    }
    return favorites;
  }
}