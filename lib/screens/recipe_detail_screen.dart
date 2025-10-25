import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        final recipe = state.selectedRecipe;

        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Recipe not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.title),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<RecipeBloc>().add(ToggleFavorite(recipe.id));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Chip(
                  label: Text(_getCategoryName(recipe.category)),
                  backgroundColor: Colors.deepOrange.shade100,
                  side: const BorderSide(color: Colors.deepOrange),
                ),
                const SizedBox(height: 16),

                Text(
                  'Description',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Expanded(child: Text(ingredient)),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCategoryName(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.mainCourse: return 'Main Course';
      case RecipeCategory.dessert: return 'Dessert';
      case RecipeCategory.appetizer: return 'Appetizer';
      case RecipeCategory.beverage: return 'Beverage';
      default: return 'All Recipes';
    }
  }
}