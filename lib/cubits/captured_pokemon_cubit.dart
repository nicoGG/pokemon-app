import 'package:flutter_bloc/flutter_bloc.dart';

class CapturedPokemonCubit extends Cubit<List<dynamic>> {
  CapturedPokemonCubit() : super([]);

  void capturePokemon(dynamic pokemon) {
    if (state.length >= 6) {
      state.removeAt(0);
    }
    state.add(pokemon);
    emit(List.from(state));
  }

  void releasePokemon(dynamic pokemon) {
    state.remove(pokemon);
    emit(List.from(state));
  }

  bool isCaptured(dynamic pokemon) {
    return state.contains(pokemon);
  }
}
