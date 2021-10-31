import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rm_characters/data/services/character_service.dart';

class CharacterPagingController extends PagingController {
  final CharacterService characterService;
  var _nameFilter = "";
  var _favoriteFilter = false;

  set nameFilter(String name) {
    _nameFilter = name;
    refresh();
  }

  String get nameFilter {
    return _nameFilter;
  }

  switchFavoriteFilter() {
    _favoriteFilter = !_favoriteFilter;
    refresh();
  }


  CharacterPagingController({firstPageKey = 1, required this.characterService}) : super(firstPageKey: firstPageKey) {
    addPageRequestListener((pageKey) {
      refreshPage();
    });
  }

  Future<void> getNextPage() async {
    try {
      final response = await characterService.getCharacters(name: _nameFilter, page: nextPageKey.toString());
      if (nextPageKey != response.info.pages) {
        appendPage(response.characters, nextPageKey + 1);
      } else {
        appendLastPage(response.characters);
      }
    } catch (e) {
      value = const PagingState(
        itemList: [],
        error: null,
        nextPageKey: 1,
      );
    }
  }

  Future<void> getFavoritesPage() async {
    try {
      final response = await characterService.getFavorites();
      appendLastPage(response);
    } catch (e) {
      value = const PagingState(
        itemList: [],
        error: null,
        nextPageKey: 1,
      );
    }
  }

  Future<void> refreshPage() async {
    if (_favoriteFilter) {
      await getFavoritesPage();
    } else {
      await getNextPage();
    }
  }
}