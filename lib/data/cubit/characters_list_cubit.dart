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

  final FilterCubit filterCubit = FilterCubit();
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
    filterCubit.switchFavoriteFilter();
    pagingController.refresh();
  }

  Future<void> fetchPage() async {
    if (filterCubit.favoriteFilter) {
      await _fetchFavorites();
    } else {
      await _fetchNextPage();
    }
  }
}

enum FilterStatus { empty, nameOnly, favoriteOnly, nameAndFavorite }

class FilterState extends Equatable {
  const FilterState._({
    this.status = FilterStatus.empty,
    this.nameFilter = "",
    this.favoriteFilter = false
  });

  const FilterState.empty() : 
      this._(status: FilterStatus.empty);

  const FilterState.nameOnly(String name)
      : this._(status: FilterStatus.nameOnly, nameFilter: name);

  const FilterState.favoriteOnly(bool activated)
      : this._(status: FilterStatus.favoriteOnly, favoriteFilter: activated);

  const FilterState.nameAndFavorite(String name, bool activated)
      : this._(status: FilterStatus.nameAndFavorite, nameFilter: name, favoriteFilter: activated);

  final FilterStatus status;
  final String nameFilter;
  final bool favoriteFilter;

  @override
  List<Object> get props => [status, nameFilter, favoriteFilter];
}

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState.empty());

  bool favoriteFilter = false;

  bool get isFiltered {
    return favoriteFilter;
  }

  Future<void> switchFavoriteFilter() async {
    favoriteFilter = !favoriteFilter;
    emit(FilterState.favoriteOnly(favoriteFilter));
  }
}