import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/utils/token_storage.dart';
import 'package:pokemon_app/pages/captured_pokemons_page.dart';
import 'package:pokemon_app/pages/login_page.dart';
import 'package:pokemon_app/pages/pokemon_list_page.dart';
import 'providers/pokemon_provider.dart';
import 'cubits/pokemon_cubit.dart';
import 'cubits/captured_pokemon_cubit.dart';
import 'cubits/login_cubit.dart';
import 'providers/login_provider.dart';

void main() {
  runApp(const PokeApp());
}

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PokemonProvider>(
          create: (context) => PokemonProvider(),
        ),
        RepositoryProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PokemonCubit>(
            create: (context) => PokemonCubit(
              context.read<PokemonProvider>(),
            ),
          ),
          BlocProvider<CapturedPokemonCubit>(
            create: (context) => CapturedPokemonCubit(),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(
              context.read<LoginProvider>(),
            ),
          ),
        ],
        child: FutureBuilder<String?>(
          future: TokenStorage.getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final String? token = snapshot.data;
            final bool isLoggedIn = token != null;

            final GoRouter router = GoRouter(
              initialLocation: isLoggedIn ? '/' : '/login',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const PokemonListPage(),
                ),
                GoRoute(
                  path: '/login',
                  builder: (context, state) => const LoginPage(),
                ),
                GoRoute(
                  path: '/captured',
                  builder: (context, state) => const CapturedPokemonsPage(),
                ),
              ],
            );

            return MaterialApp.router(
              routerConfig: router,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
            );
          },
        ),
      ),
    );
  }
}
