
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/ui/screens/characters_details_screen.dart';
import 'package:rm_characters/ui/widgets/favorite_button.dart';
import 'package:rm_characters/ui/widgets/centered_indicator.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoriteTap;

  const CharacterCard({Key? key, required this.character, required this.onFavoriteTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CharacterDetailsScreen(character: character, onFavoriteTap: onFavoriteTap),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 2,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: character.image,
                placeholder: (context, url) => const CenteredIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.fill,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(color: Colors.black54),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              character.name,
                              maxLines: 2,
                              // overflow: TextOverflow.clip,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Positioned(
                  right: 0,
                  child: FavoriteButton(idPreference: character.id.toString(), onFavoriteTap: onFavoriteTap, color: Colors.red)
              ),
            ],
          ),
        ),
      ),
    );
  }

}