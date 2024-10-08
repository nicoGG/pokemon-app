import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/cubits/pokemon/captured_pokemon_cubit.dart';
import 'package:pokemon_app/cubits/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/cubits/pokemon/pokemon_type_cubit.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Pokedex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _showLoginConfirmationDialog(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCapturedPokemons(context),
        child: const Icon(Icons.list_alt),
      ),
      body: const Stack(
        children: [
          PokemonListView(),
        ],
      ),
    );
  }

  void _showCapturedPokemons(BuildContext context) {
    context.push('/captured');
  }

  void _showLoginConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro que deseas ir al login?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Sí, estoy seguro'),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  int currentPage = 1;
  String? searchName;
  String? searchType;
  int totalPages = 1;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPokemonsForCurrentPage();
    context.read<PokemonTypeCubit>().fetchPokemonTypes();
  }

  Future<void> _refreshPokemons() async {
    setState(() {
      currentPage = 1;
    });
    await _fetchPokemonsForCurrentPage();
  }

  Future<void> _fetchPokemonsForCurrentPage() async {
    await context.read<PokemonCubit>().fetchPokemons(
          currentPage,
          name: searchName,
          type: searchType,
        );
  }

  void _changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
    _fetchPokemonsForCurrentPage();
  }

  void _showMaxPokemonToast(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('No puedes capturar más de 6 Pokémones'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Campo de búsqueda con un botón para limpiar el input
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por nombre',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchName = null;
                            });
                            _fetchPokemonsForCurrentPage();
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchName = value;
                          currentPage = 1;
                        });
                        _fetchPokemonsForCurrentPage();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Selector de tipo de Pokémon, altura igualada con el TextField
                  Expanded(
                    child: BlocBuilder<PokemonTypeCubit, PokemonTypeState>(
                      builder: (context, state) {
                        if (state is PokemonTypeLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is PokemonTypeLoaded) {
                          final typesWithAll = ['Todos', ...state.types];

                          return Container(
                            height: 58, // Misma altura que el TextField
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                alignment: Alignment
                                    .centerLeft, // Centrando el texto seleccionado
                                value: searchType == '' ? 'Todos' : searchType,
                                hint: const Text("Buscar por tipo"),
                                isExpanded: true,
                                items: typesWithAll.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type == 'Todos' ? 'Todos' : type,
                                    child: Center(
                                      child: Text(type
                                          .toUpperCase()), // Centrar el texto del dropdown
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    searchType = newValue == 'Todos'
                                        ? 'Todos'
                                        : newValue;
                                    currentPage = 1;
                                  });
                                  _fetchPokemonsForCurrentPage();
                                },
                              ),
                            ),
                          );
                        } else {
                          return const Text('No se pudieron cargar los tipos');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PokemonCubit, PokemonState>(
                builder: (context, state) {
                  if (state is PokemonListLoading && currentPage == 1) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PokemonLoaded) {
                    totalPages = state.totalPages;

                    if (state.pokemons.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            size: 90,
                            Icons.not_interested_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'No se encontraron Pokémones',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshPokemons,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120.0),
                        itemCount: state.pokemons.length,
                        itemBuilder: (context, index) {
                          final pokemon = state.pokemons[index];
                          final isCaptured = context
                              .watch<CapturedPokemonCubit>()
                              .isCapturedById(pokemon.id);

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Stack(
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: isCaptured
                                        ? const BorderSide(
                                            color: Colors.green, width: 2.0)
                                        : BorderSide.none,
                                  ),
                                  title: Text(
                                    pokemon.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Image.network(pokemon.image),
                                  trailing: Icon(
                                    isCaptured
                                        ? Icons.check_circle
                                        : Icons.add_circle_outline,
                                    color:
                                        isCaptured ? Colors.green : Colors.grey,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    final capturedCount = context
                                        .read<CapturedPokemonCubit>()
                                        .state
                                        .length;

                                    if (isCaptured) {
                                      context
                                          .read<CapturedPokemonCubit>()
                                          .releasePokemonById(pokemon.id);
                                    } else if (capturedCount < 6) {
                                      context
                                          .read<CapturedPokemonCubit>()
                                          .capturePokemon(pokemon);
                                    } else {
                                      _showMaxPokemonToast(context);
                                    }
                                  },
                                  selected: isCaptured,
                                  subtitle: Wrap(
                                    spacing: 5.0,
                                    runSpacing: 1.0,
                                    children: pokemon.types
                                        .map<Widget>((type) => Chip(
                                              label: Text(
                                                type,
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              shape: const StadiumBorder(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: -1.0,
                                                      vertical: -10.0),
                                              backgroundColor:
                                                  Colors.amber.withOpacity(0.2),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ))
                                        .toList(),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
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
                  } else if (state is PokemonError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const Center(
                        child: Text('No hay pokemones encontrados'));
                  }
                },
              ),
            ),
          ],
        ),
        _buildPaginator(),
      ],
    );
  }

  Widget _buildPaginator() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        margin: const EdgeInsets.only(left: 90, right: 90, bottom: 27),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: currentPage > 1 ? Colors.blue : Colors.grey,
              onPressed:
                  currentPage > 1 ? () => _changePage(currentPage - 1) : null,
            ),
            Text(
              'Página $currentPage de $totalPages',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              color: currentPage < totalPages ? Colors.blue : Colors.grey,
              onPressed: currentPage < totalPages
                  ? () => _changePage(currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
