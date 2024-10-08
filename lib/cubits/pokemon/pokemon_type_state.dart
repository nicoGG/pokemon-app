part of 'pokemon_type_cubit.dart';

abstract class PokemonTypeState {}

class PokemonTypeInitial extends PokemonTypeState {}

class PokemonTypeLoading extends PokemonTypeState {}

class PokemonTypeLoaded extends PokemonTypeState {
  final List<String> types;
  PokemonTypeLoaded(this.types);
}

class PokemonTypeError extends PokemonTypeState {
  final String message;
  PokemonTypeError(this.message);
}
