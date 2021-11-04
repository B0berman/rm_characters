import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rm_characters/data/cubit/characters_list_cubit.dart';
import 'package:rm_characters/data/models/character.dart';
import 'package:rm_characters/data/services/character_service.dart';
import 'package:rm_characters/ui/widgets/character_card.dart';
import 'package:rm_characters/ui/widgets/simple_error.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => CharactersListCubit(
          repository: context.read<CharacterService>(),
        )..fetchFirstPage(),
        child: CharactersView(),
      ),
    );
  }
}

class CharactersView extends StatelessWidget {
  const CharactersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharactersListCubit>().state;
    switch (state.status) {
      case ListStatus.failure:
        return const Center(child: Text('Oops something went wrong!'));
      case ListStatus.success:
        return buildCharacters(context);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildCharacters(BuildContext context) {
    final pagingController = context.read<CharactersListCubit>().pagingController;
    return PagedGridView(pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate(
            noItemsFoundIndicatorBuilder: (context) => SimpleError(message: "No Character found", onRetryTap: () {
              pagingController.refresh();
            }),
            itemBuilder: (context, item, index) => CharacterCard(character: item as Character, onFavoriteTap: () {
             context.read<CharacterService>().setFavorite(item.id);
            })
        ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          crossAxisCount: 2,
        ));
  }
}