import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  // for store and update a single, immutable state

  FavoriteMealsNotifier() : super([]);
  //  initializes the state with an empty list ([]).

  bool toggleMealFavoritesStatus(Meal meal) {
    final mealIsFavorite =
        state.contains(meal); // like we use widget, here we use state

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false; //This creates a new list without the selected meal.
      // It keeps only the meals whose id is different from meal.id.
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider = //returning sateNotifierProvider
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
