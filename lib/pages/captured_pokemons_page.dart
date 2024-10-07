import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/cubits/captured_pokemon_cubit.dart';

class CapturedPokemonsPage extends StatelessWidget {
  const CapturedPokemonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Capturados'),
      ),
      body: BlocBuilder<CapturedPokemonCubit, List<dynamic>>(
        builder: (context, capturedPokemons) {
          if (capturedPokemons.isEmpty) {
            return const Center(
                child: Text('No has capturado ningún Pokémon.'));
          }
          return ListView.builder(
            itemCount: capturedPokemons.length,
            itemBuilder: (context, index) {
              final pokemon = capturedPokemons[index];
              return ListTile(
                title: Text(pokemon.name),
                trailing: const Icon(Icons.delete, color: Colors.red),
                onTap: () {
                  context.read<CapturedPokemonCubit>().releasePokemon(pokemon);
                },
              );
            },
          );
        },
      ),
    );
  }
}
