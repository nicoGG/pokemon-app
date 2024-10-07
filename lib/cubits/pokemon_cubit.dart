import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/models/pokemon_model.dart';
import '../providers/pokemon_provider.dart';

part 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final PokemonProvider _pokemonProvider;

  PokemonCubit(this._pokemonProvider) : super(PokemonInitial());

  Future<void> fetchPokemons(int page, {String? name, String? type}) async {
    emit(PokemonLoading());
    try {
      final data =
          await _pokemonProvider.getPokemons(page, name: name, type: type);
      List<Pokemon> pokemons = data['pokemons'];
      int currentPage = data['currentPage'];
      int totalPages = data['totalPages'];
      int totalPokemons = data['totalPokemons'];

      emit(PokemonLoaded(
        pokemons: pokemons,
        currentPage: currentPage,
        totalPages: totalPages,
        totalPokemons: totalPokemons,
      ));
    } catch (e) {
      emit(PokemonError("Error fetching Pokémon: ${e.toString()}"));
    }
  }
}
