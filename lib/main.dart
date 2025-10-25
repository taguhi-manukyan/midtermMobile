import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/recipe_bloc.dart';
import 'bloc/recipe_event.dart';
import 'screens/recipe_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipeExplorerApp());
}

class RecipeExplorerApp extends StatelessWidget {
  const RecipeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
      child: MaterialApp(
        title: 'Recipe Explorer',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 4,
          ),
        ),
        home: const RecipeListScreen(),
      ),
    );
  }
}