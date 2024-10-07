import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/models/pokemon_model.dart';

class CapturedPokemonCubit extends Cubit<List<Pokemon>> {
  CapturedPokemonCubit() : super([]);

  void capturePokemon(Pokemon pokemon) {
    if (state.length >= 6) {
      state.removeAt(0);
    }
    state.add(pokemon);
    emit(List.from(state));
  }

  void releasePokemon(Pokemon pokemon) {
    state.remove(pokemon);
    emit(List.from(state));
  }

  bool isCaptured(Pokemon pokemon) {
    return state.contains(pokemon);
  }
}
