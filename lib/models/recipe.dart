import 'package:equatable/equatable.dart';

enum RecipeCategory {
  mainCourse,
  dessert,
  appetizer,
  beverage,
  all,
}

class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final RecipeCategory category;
  final List<String> ingredients;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ingredients,
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    RecipeCategory? category,
    List<String>? ingredients,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, category, isFavorite];
}