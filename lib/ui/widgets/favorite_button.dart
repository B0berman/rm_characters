import 'package:flutter/material.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FavoriteButton extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoriteTap;
  final Color color;

  const FavoriteButton({Key? key, required this.character, required this.onFavoriteTap, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StreamingSharedPreferences.instance,
        builder: (context, snapshot) {
          final preferences = snapshot.data as StreamingSharedPreferences?;
          return preferences != null ? PreferenceBuilder<bool>(
              preference: preferences.getBool(character.id.toString(), defaultValue: false),
              builder: (context, isFavorite) {
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: color),
                  onPressed: () => onFavoriteTap.call(),
                );
              }) : Container();
        });
  }
}