import 'package:equatable/equatable.dart';
import '../models/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String searchTerm;
  const SearchRecipes(this.searchTerm);
  @override
  List<Object> get props => [searchTerm];
}

class FilterRecipes extends RecipeEvent {
  final RecipeCategory category;
  const FilterRecipes(this.category);
  @override
  List<Object> get props => [category];
}

class LoadMoreRecipes extends RecipeEvent {}

class SelectRecipe extends RecipeEvent {
  final String recipeId;
  const SelectRecipe(this.recipeId);
  @override
  List<Object> get props => [recipeId];
}

class ToggleFavorite extends RecipeEvent {
  final String recipeId;
  const ToggleFavorite(this.recipeId);
  @override
  List<Object> get props => [recipeId];
}