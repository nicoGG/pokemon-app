part of 'pokemon_cubit.dart';

abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonListLoading extends PokemonState {}

class PokemonTypesLoading extends PokemonState {}

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

class PokemonTypesLoaded extends PokemonState {
  final List<String> types;

  PokemonTypesLoaded(this.types);
}

class PokemonError extends PokemonState {
  final String errorMessage;

  PokemonError(this.errorMessage);
}
