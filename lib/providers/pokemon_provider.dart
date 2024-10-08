import 'package:dio/dio.dart';
import 'package:pokemon_app/interceptors/dio_interceptor.dart';
import 'package:pokemon_app/models/pokemon_model.dart';

class PokemonProvider {
  final Dio _dio;
  final String apiUrl = 'http://localhost:3000/api/pokemon';

  PokemonProvider() : _dio = Dio() {
    _dio.interceptors.add(DioInterceptor());
  }

  Future<Map<String, dynamic>> getPokemons(int page,
      {String? name, String? type}) async {
    try {
      final queryParams = {
        'page': page,
        if (name != null) 'name': name,
        if (type != null && type.isNotEmpty) 'type': type,
      };

      final response = await _dio.get(apiUrl, queryParameters: queryParams);
      List<Pokemon> pokemons = (response.data['pokemons'] as List)
          .map((pokemonData) => Pokemon.fromJson(pokemonData))
          .toList();

      int currentPage = response.data['currentPage'];
      int totalPages = response.data['totalPages'];
      int totalPokemons = response.data['totalPokemons'];

      return {
        'pokemons': pokemons,
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalPokemons': totalPokemons,
      };
    } catch (e) {
      throw Exception("Error fetching Pokémon: ${e.toString()}");
    }
  }

  Future<List<String>> getPokemonTypes() async {
    try {
      final response = await _dio.get('$apiUrl/types');

      List<String> types = (response.data as List).map((typeData) {
        return typeData.toString();
      }).toList();

      return types;
    } catch (e) {
      throw Exception("Error fetching Pokémon types: ${e.toString()}");
    }
  }
}
