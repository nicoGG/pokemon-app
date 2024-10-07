import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/cubits/captured_pokemon_cubit.dart';
import 'package:pokemon_app/cubits/pokemon_cubit.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              context.push('/captured');
            },
          )
        ],
      ),
      body: const PokemonListView(),
    );
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  _PokemonListViewState createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  int currentPage = 1;
  bool isLoadingMore = false;
  String? searchName;
  String? searchType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PokemonCubit>().fetchPokemons(currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore) {
        loadMore();
      }
    });
  }

  void loadMore() {
    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    context
        .read<PokemonCubit>()
        .fetchPokemons(currentPage, name: searchName, type: searchType)
        .then((_) {
      setState(() {
        isLoadingMore = false;
      });
    });
  }

  Future<void> _refreshPokemons() async {
    setState(() {
      currentPage = 1;
    });
    await context
        .read<PokemonCubit>()
        .fetchPokemons(currentPage, name: searchName, type: searchType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Buscar por nombre'),
                  onChanged: (value) {
                    setState(() {
                      searchName = value;
                      currentPage = 1;
                    });
                    context
                        .read<PokemonCubit>()
                        .fetchPokemons(1, name: value, type: searchType);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Buscar por tipo'),
                  onChanged: (value) {
                    setState(() {
                      searchType = value;
                      currentPage = 1;
                    });
                    context
                        .read<PokemonCubit>()
                        .fetchPokemons(1, name: searchName, type: value);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<PokemonCubit, PokemonState>(
            builder: (context, state) {
              if (state is PokemonLoading && currentPage == 1) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PokemonLoaded) {
                return RefreshIndicator(
                  onRefresh: _refreshPokemons,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.pokemons.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.pokemons.length && isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final pokemon = state.pokemons[index];
                      final isCaptured = context
                          .watch<CapturedPokemonCubit>()
                          .isCaptured(pokemon);

                      return ListTile(
                        title: Text(pokemon.name),
                        trailing: isCaptured
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.add, color: Colors.grey),
                        onTap: () {
                          if (isCaptured) {
                            context
                                .read<CapturedPokemonCubit>()
                                .releasePokemon(pokemon);
                          } else {
                            context
                                .read<CapturedPokemonCubit>()
                                .capturePokemon(pokemon);
                          }
                        },
                      );
                    },
                  ),
                );
              } else if (state is PokemonError) {
                return Center(child: Text(state.errorMessage));
              } else {
                return const Center(child: Text('No Pokémon found'));
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
