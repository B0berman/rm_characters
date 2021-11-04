import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/data/services/character_service.dart';

part 'list_state.dart';

class CharactersListCubit extends Cubit<ListState<Character>> {
  CharactersListCubit({required this.repository})
      : super(const ListState.loading()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage();
    });
  }

  bool _favoriteFilter = false;

  final CharacterService repository;
  final PagingController pagingController = PagingController(firstPageKey: 1);

  Future<void> fetchFirstPage() async {
    try {
      final items = await repository.getAll();
      emit(ListState<Character>.success(items.characters));
    } on Exception {
      emit(const ListState.failure());
    }
  }

  Future<void> _fetchNextPage({int pageKey = 1}) async {
    final response = await repository.getCharacters(page: pageKey.toString());
    if (pagingController.nextPageKey != response.info.pages) {
      pagingController.appendPage(response.characters, pagingController.nextPageKey + 1);
    } else {
      pagingController.appendLastPage(response.characters);
    }
  }

  Future<void> _fetchFavorites() async {
    try {
      final res = await repository.getFavorites();
      pagingController.appendLastPage(res);
    } on Exception {
      emit(const ListState.failure());
    }
  }

  Future<void> switchFavoritesFilter() async {
    _favoriteFilter = !_favoriteFilter;
    pagingController.refresh();
  }

  Future<void> fetchPage() async {
    if (_favoriteFilter) {
      await _fetchFavorites();
    } else {
      await _fetchNextPage();
    }
  }
}