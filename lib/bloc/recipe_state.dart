import 'package:equatable/equatable.dart';
import '../models/recipe.dart';

class RecipeState extends Equatable {
  final List<Recipe> allRecipes;
  final List<Recipe> filteredRecipes;
  final List<Recipe> displayedRecipes;

  final String currentSearchTerm;
  final RecipeCategory currentCategory;
  final int limit;

  final Recipe? selectedRecipe;

  final bool hasMoreToLoad;
  final bool isLoading;

  const RecipeState({
    this.allRecipes = const [],
    this.filteredRecipes = const [],
    this.displayedRecipes = const [],
    this.currentSearchTerm = '',
    this.currentCategory = RecipeCategory.all,
    this.limit = 5,
    this.selectedRecipe,
    this.hasMoreToLoad = true,
    this.isLoading = false,
  });

  RecipeState copyWith({
    List<Recipe>? allRecipes,
    List<Recipe>? filteredRecipes,
    List<Recipe>? displayedRecipes,
    String? currentSearchTerm,
    RecipeCategory? currentCategory,
    int? limit,
    Recipe? selectedRecipe,
    bool? hasMoreToLoad,
    bool? isLoading,
  }) {
    return RecipeState(
      allRecipes: allRecipes ?? this.allRecipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      displayedRecipes: displayedRecipes ?? this.displayedRecipes,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
      currentCategory: currentCategory ?? this.currentCategory,
      limit: limit ?? this.limit,
      selectedRecipe: selectedRecipe,
      hasMoreToLoad: hasMoreToLoad ?? this.hasMoreToLoad,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    allRecipes,
    filteredRecipes,
    displayedRecipes,
    currentSearchTerm,
    currentCategory,
    selectedRecipe,
    hasMoreToLoad,
    isLoading,
  ];
}