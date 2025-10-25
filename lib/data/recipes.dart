import '../models/recipe.dart';

const List<String> mockIngredients = [
  'Sugar', 'Flour', 'Eggs', 'Milk', 'Butter',
  'Salt', 'Pepper', 'Chicken', 'Rice', 'Tomato',
];

final List<Recipe> mockRecipes = [
  Recipe(id: 'r1', title: 'Beef Stroganoff', description: 'Beef in a creamy sauce', category: RecipeCategory.mainCourse, ingredients: mockIngredients.sublist(0, 5)),
  Recipe(id: 'r2', title: 'Chicken', description: 'Curry', category: RecipeCategory.mainCourse, ingredients: mockIngredients.sublist(1, 6)),
  Recipe(id: 'r3', title: 'Lasagna', description: 'Layers of pasta', category: RecipeCategory.mainCourse, ingredients: mockIngredients.sublist(2, 7)),
  Recipe(id: 'r4', title: 'Tolma', description: 'Armenian dish', category: RecipeCategory.mainCourse, ingredients: mockIngredients.sublist(3, 8)),
  Recipe(id: 'r5', title: 'Pizza', description: 'Italian dough with cheese', category: RecipeCategory.mainCourse, ingredients: mockIngredients.sublist(4, 9)),

  Recipe(id: 'r6', title: 'Lava Cake', description: 'Warm, chocolate dessert', category: RecipeCategory.dessert, ingredients: mockIngredients.sublist(5, 10)),
  Recipe(id: 'r7', title: 'Cheesecake', description: 'Creamy classic dessert', category: RecipeCategory.dessert, ingredients: mockIngredients.sublist(0, 4)),
  Recipe(id: 'r8', title: 'Pavlova', description: 'Crunchy', category: RecipeCategory.dessert, ingredients: mockIngredients.sublist(1, 5)),
  Recipe(id: 'r9', title: 'Mango ice cream', description: 'Ice cream with mango taste', category: RecipeCategory.dessert, ingredients: mockIngredients.sublist(2, 6)),
  Recipe(id: 'r10', title: 'Shortcake', description: 'Light cake', category: RecipeCategory.dessert, ingredients: mockIngredients.sublist(3, 7)),


  Recipe(id: 'r11', title: 'Bruschetta', description: 'Toasted bread', category: RecipeCategory.appetizer, ingredients: mockIngredients.sublist(4, 8)),
  Recipe(id: 'r12', title: 'Dip', description: 'Cheesy dip', category: RecipeCategory.appetizer, ingredients: mockIngredients.sublist(5, 9)),
  Recipe(id: 'r13', title: 'Spring Rolls', description: 'Vegetable filled rolls.', category: RecipeCategory.appetizer, ingredients: mockIngredients.sublist(0, 5)),
  Recipe(id: 'r14', title: 'Hummus', description: 'Chickpea spread', category: RecipeCategory.appetizer, ingredients: mockIngredients.sublist(1, 6)),
  Recipe(id: 'r15', title: 'Caprese', description: 'Mozzarella, tomato, and basil', category: RecipeCategory.appetizer, ingredients: mockIngredients.sublist(2, 7)),

  Recipe(id: 'r16', title: 'Mojito', description: 'lime and mint cocktail.', category: RecipeCategory.beverage, ingredients: mockIngredients.sublist(3, 8)),
  Recipe(id: 'r17', title: 'Iced Coffee Latte', description: 'Coffee with cold milk and ice', category: RecipeCategory.beverage, ingredients: mockIngredients.sublist(4, 9)),
  Recipe(id: 'r18', title: 'Lemonade', description: 'Homemade limonade', category: RecipeCategory.beverage, ingredients: mockIngredients.sublist(5, 10)),
  Recipe(id: 'r19', title: 'Smoothie', description: 'Blend of vegetables and fruits', category: RecipeCategory.beverage, ingredients: mockIngredients.sublist(0, 4)),
  Recipe(id: 'r20', title: 'Hot Chocolate', description: 'Hot drink', category: RecipeCategory.beverage, ingredients: mockIngredients.sublist(1, 5)),
];
