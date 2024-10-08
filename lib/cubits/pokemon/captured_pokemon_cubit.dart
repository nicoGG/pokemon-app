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
    return state.any((captured) => captured.id == pokemon.id);
  }

  void releasePokemonById(int id) {
    state.removeWhere((pokemon) => pokemon.id == id);
    emit(List.from(state));
  }

  bool isCapturedById(int id) {
    return state.any((p) => p.id == id);
  }

  void releaseAll() {
    emit([]);
  }
}
