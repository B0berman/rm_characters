import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/ui/widgets/centered_indicator.dart';
import 'package:rm_characters/ui/widgets/favorite_button.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoriteTap;

  const CharacterDetailsScreen({Key? key, required this.character, required this.onFavoriteTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          FavoriteButton(character: character, onFavoriteTap: () => onFavoriteTap.call())
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                if (Platform.isIOS) Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CachedNetworkImage(
                        imageUrl: character.image,
                        placeholder: (context, url) => const CenteredIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2,)
                  ],
                ),
                const Divider(thickness: 1),
                _buildInformationWidget(Icons.all_inclusive, "Status", character.status),
                const Divider(thickness: 1),
                _buildInformationWidget(Icons.pets, "Species", character.species),
                const Divider(thickness: 1),
                _buildInformationWidget(Icons.wc, "Gender", character.gender),
                const Divider(thickness: 1),
                _buildInformationWidget(Icons.public, "Origin", character.origin.name),
                const Divider(thickness: 1),
                _buildInformationWidget(Icons.place, "Location", character.location.name),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildInformationWidget(IconData icon, String key, String value) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(icon, color: Colors.blueGrey),
        ),
        Text("$key : ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

}
