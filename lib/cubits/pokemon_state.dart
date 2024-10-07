part of 'pokemon_cubit.dart';

abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final int currentPage;
  final int totalPages;
  final int totalPokemons;

  PokemonLoaded({
    required this.pokemons,
    required this.currentPage,
    required this.totalPages,
    required this.totalPokemons,
  });
}

class PokemonError extends PokemonState {
  final String errorMessage;

  PokemonError(this.errorMessage);
}
