import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/recipes.dart';
import '../models/recipe.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(const RecipeState()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<SearchRecipes>(_onSearchRecipes);
    on<FilterRecipes>(_onFilterRecipes);
    on<LoadMoreRecipes>(_onLoadMoreRecipes);
    on<SelectRecipe>(_onSelectRecipe);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadRecipes(LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));

    final initialRecipes = mockRecipes;

    final filteredRecipes = _applyFilters(
        initialRecipes,
        state.currentSearchTerm,
        RecipeCategory.all
    );

    final displayedRecipes = filteredRecipes.toList();

    final hasMore = filteredRecipes.length > state.limit;

    emit(state.copyWith(
      allRecipes: initialRecipes,
      filteredRecipes: filteredRecipes,
      displayedRecipes: displayedRecipes,
      hasMoreToLoad: hasMore,
      currentCategory: RecipeCategory.all,
      isLoading: false,
    ));
  }

  List<Recipe> _applyFilters(List<Recipe> recipes, String searchTerm, RecipeCategory category) {
    print(recipes.length);
    List<Recipe> tempRecipes = recipes.where((recipe) {
      return category == RecipeCategory.all || recipe.category == category;
    }).toList();

    if (searchTerm.isNotEmpty) {
      tempRecipes = tempRecipes.where((recipe) {
        return recipe.title.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    }

    print(tempRecipes.length);

    return tempRecipes;
  }

  void _onSearchRecipes(SearchRecipes event, Emitter<RecipeState> emit) {
    final newSearchTerm = event.searchTerm;

    final newFilteredRecipes = _applyFilters(
        state.allRecipes,
        newSearchTerm,
        state.currentCategory
    );

    final newDisplayedRecipes = newFilteredRecipes.take(state.limit).toList();
    final hasMore = newFilteredRecipes.length > state.limit;

    emit(state.copyWith(
      currentSearchTerm: newSearchTerm,
      filteredRecipes: newFilteredRecipes,
      displayedRecipes: newDisplayedRecipes,
      hasMoreToLoad: hasMore,
    ));
  }

  void _onFilterRecipes(FilterRecipes event, Emitter<RecipeState> emit) {
    final newCategory = event.category;

    final newFilteredRecipes = _applyFilters(
        state.allRecipes,
        state.currentSearchTerm,
        newCategory
    );

    final newDisplayedRecipes = newFilteredRecipes.take(state.limit).toList();
    final hasMore = newFilteredRecipes.length > state.limit;

    emit(state.copyWith(
      currentCategory: newCategory,
      filteredRecipes: newFilteredRecipes,
      displayedRecipes: newDisplayedRecipes,
      hasMoreToLoad: hasMore,
    ));
  }

  void _onLoadMoreRecipes(LoadMoreRecipes event, Emitter<RecipeState> emit) async {
    if (!state.hasMoreToLoad || state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 700));

    final currentCount = state.displayedRecipes.length;
    final newOffset = currentCount;
    final newLimit = state.limit;

    final nextBatch = state.filteredRecipes
        .skip(newOffset)
        .take(newLimit)
        .toList();

    final newDisplayedList = List<Recipe>.from(state.displayedRecipes)
      ..addAll(nextBatch);

    final hasMore = newDisplayedList.length < state.filteredRecipes.length;

    emit(state.copyWith(
      displayedRecipes: newDisplayedList,
      hasMoreToLoad: hasMore,
      isLoading: false,
    ));
  }

  void _onSelectRecipe(SelectRecipe event, Emitter<RecipeState> emit) {
    final selected = state.allRecipes.firstWhere((r) => r.id == event.recipeId);
    emit(state.copyWith(selectedRecipe: selected));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<RecipeState> emit) {
    final updatedAllRecipes = state.allRecipes.map((recipe) {
      if (recipe.id == event.recipeId) {
        return recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
      return recipe;
    }).toList();

    final newFilteredRecipes = _applyFilters(
        updatedAllRecipes,
        state.currentSearchTerm,
        state.currentCategory
    );

    final newDisplayedRecipes = newFilteredRecipes.take(state.displayedRecipes.length).toList();

    final hasMore = newDisplayedRecipes.length < newFilteredRecipes.length;

    Recipe? newSelectedRecipe = state.selectedRecipe?.id == event.recipeId
        ? updatedAllRecipes.firstWhere((r) => r.id == event.recipeId)
        : state.selectedRecipe;

    emit(state.copyWith(
      allRecipes: updatedAllRecipes,
      filteredRecipes: newFilteredRecipes,
      displayedRecipes: newDisplayedRecipes,
      selectedRecipe: newSelectedRecipe,
      hasMoreToLoad: hasMore,
    ));
  }
}