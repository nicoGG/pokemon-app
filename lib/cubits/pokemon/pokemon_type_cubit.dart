import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/providers/pokemon_provider.dart';

part 'pokemon_type_state.dart';

class PokemonTypeCubit extends Cubit<PokemonTypeState> {
  final PokemonProvider _pokemonProvider;

  PokemonTypeCubit(this._pokemonProvider) : super(PokemonTypeInitial());

  Future<void> fetchPokemonTypes() async {
    emit(PokemonTypeLoading());
    try {
      final types = await _pokemonProvider.getPokemonTypes();
      emit(PokemonTypeLoaded(types));
    } catch (e) {
      emit(PokemonTypeError("Error fetching Pokémon types: ${e.toString()}"));
    }
  }
}
