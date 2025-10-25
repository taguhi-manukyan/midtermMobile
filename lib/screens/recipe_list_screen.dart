import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<RecipeBloc>().add(LoadMoreRecipes());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer 🧑‍🍳'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.allRecipes.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Recipes',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<RecipeBloc>().add(const SearchRecipes(''));
                      },
                    )
                        : null,
                  ),
                  onChanged: (searchTerm) {
                    context.read<RecipeBloc>().add(SearchRecipes(searchTerm));
                  },
                ),
              ),

              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  children: RecipeCategory.values.map((category) {
                    final isSelected = category == state.currentCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text(_getCategoryName(category)),
                        backgroundColor: isSelected ? Colors.deepOrange.shade100 : Colors.grey.shade100,
                        side: isSelected ? const BorderSide(color: Colors.deepOrange) : null,
                        onPressed: () {
                          context.read<RecipeBloc>().add(FilterRecipes(category));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              Expanded(
                child: state.displayedRecipes.isEmpty && !state.isLoading
                    ? Center(child: Text('No recipes found for "${state.currentSearchTerm}" in ${_getCategoryName(state.currentCategory)}.'))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: state.displayedRecipes.length + (state.hasMoreToLoad ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.displayedRecipes.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final recipe = state.displayedRecipes[index];
                    return _RecipeListTile(recipe: recipe);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  const _RecipeListTile({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.restaurant,
          color: recipe.category == RecipeCategory.dessert ? Colors.pink.shade300 : Colors.deepOrange,
        ),
        title: Text(
          recipe.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(recipe.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.star : Icons.star_border,
            color: recipe.isFavorite ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            context.read<RecipeBloc>().add(ToggleFavorite(recipe.id));
          },
        ),
        onTap: () {
          context.read<RecipeBloc>().add(SelectRecipe(recipe.id));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RecipeDetailScreen()),
          );
        },
      ),
    );
  }
}