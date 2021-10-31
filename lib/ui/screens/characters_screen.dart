import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/data/services/character_service.dart';
import 'package:rm_characters/ui/controllers/character_paging_controller.dart';
import 'package:rm_characters/ui/widgets/character_card.dart';
import 'package:rm_characters/ui/widgets/simple_error.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final CharacterService _characterService = CharacterService();
  late final CharacterPagingController _pagingController;
  late final SearchBar _searchBar;

  _CharactersScreenState() {
    _pagingController = CharacterPagingController(characterService: _characterService);
    _searchBar = SearchBar(
        inBar: true,
        setState: setState,
        onChanged: (name) => _pagingController.nameFilter = name,
        onCleared: () => _pagingController.nameFilter = "",
        onClosed: () => _pagingController.nameFilter = "",
        buildDefaultAppBar: buildAppBar
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      body: buildCharacters(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Characters", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        _searchBar.getSearchAction(context),
        IconButton(
            onPressed: () => _pagingController.switchFavoriteFilter(),
            icon: const Icon(Icons.favorite_border))
      ],
    );
  }

  Widget buildCharacters(BuildContext context) {
    return PagedGridView(pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          noItemsFoundIndicatorBuilder: (context) => SimpleError(message: "No Character found", onRetryTap: () {
            _pagingController.refresh();
          }),
          itemBuilder: (context, item, index) => CharacterCard(character: item as Character, onFavoriteTap: () {
            _characterService.setFavorite(item.id);
          })
        ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          crossAxisCount: 2,
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}