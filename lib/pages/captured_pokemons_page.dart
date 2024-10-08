import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/cubits/pokemon/captured_pokemon_cubit.dart';
import 'package:pokemon_app/models/pokemon_model.dart';

class CapturedPokemonsPage extends StatelessWidget {
  const CapturedPokemonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémones Capturados'),
        actions: [
          BlocBuilder<CapturedPokemonCubit, List<Pokemon>>(
            builder: (context, capturedPokemons) {
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: capturedPokemons.isEmpty
                    ? null
                    : () {
                        _showReleaseAllDialog(context);
                      },
                tooltip: 'Liberar todos los Pokémon',
                color: capturedPokemons.isEmpty ? Colors.grey : Colors.red,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CapturedPokemonCubit, List<Pokemon>>(
        builder: (context, capturedPokemons) {
          if (capturedPokemons.isEmpty) {
            return const Center(
              child: _EmptyCapturedPokemons(),
            );
          }
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: ListView.builder(
              itemCount: capturedPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = capturedPokemons[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  child: Stack(
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            pokemon.image,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Wrap(
                          spacing: 5.0,
                          runSpacing: 1.0,
                          children: pokemon.types
                              .map<Widget>((type) => Chip(
                                    label: Text(
                                      type,
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    shape: const StadiumBorder(),
                                    backgroundColor:
                                        Colors.blue.withOpacity(0.2),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<CapturedPokemonCubit>()
                                .releasePokemon(pokemon);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    '${pokemon.name.toUpperCase()} ha sido liberado.'),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            '#${pokemon.id}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showReleaseAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Liberación'),
          content:
              const Text('¿Estás seguro que deseas liberar todos los Pokémon?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Liberar Todos'),
              onPressed: () {
                context.read<CapturedPokemonCubit>().releaseAll();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Todos los Pokémon han sido liberados.'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _EmptyCapturedPokemons extends StatelessWidget {
  const _EmptyCapturedPokemons();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.catching_pokemon,
          size: 100,
          color: Colors.grey,
        ),
        const SizedBox(height: 20),
        const Text(
          'No has capturado ningún Pokémon.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Ir a capturar Pokémon'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }
}
