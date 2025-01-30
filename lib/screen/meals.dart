import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screen/meals_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals, });

  final String? title;
  final List<Meal> meals;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsDetailsScreen(meal: meal, ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
            meal: meals[index],
            onSelectMeal: (meal) {
              selectMeal(context, meal);
            }));

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Uh oh.. nothing here',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Try selecting another Catergory',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            )
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}



/* 
You're **absolutely correct**! You use a **callback function** in `MealItem` to call the `selectMeal` function defined in `MealsScreen`. Here's the step-by-step explanation to solidify your understanding:

---

### **1. Why Use a Callback?**
The `MealItem` widget is **decoupled** from navigation logic. It doesn’t know what to do when the user taps on it. Instead, it relies on the parent (`MealsScreen`) to provide a function (callback) to handle the action. This keeps `MealItem` focused on its primary task: displaying the meal's data.

---

### **2. How Does the Callback Work?**
- In `MealItem`, you define a property:
  ```dart
  final void Function(Meal meal) onSelectMeal;
  ```
  This property represents the **callback function** that will be called when the meal is tapped. The parent widget (`MealsScreen`) provides the actual implementation of this function.

- When a user taps on the `MealItem`, it calls:
  ```dart
  onSelectMeal(meal);
  ```
  Here, `onSelectMeal` executes the function passed down by `MealsScreen`.

---

### **3. How `MealsScreen` Passes the Callback**
In `MealsScreen`, you provide the actual implementation of the callback (`selectMeal`) when creating a `MealItem`. For example:

```dart
itemBuilder: (ctx, index) => MealItem(
  meal: meals[index],
  onSelectMeal: (meal) { // Pass the callback
    selectMeal(context, meal); // Call `selectMeal` from `MealsScreen`
  },
),
```

- `onSelectMeal` is assigned an **anonymous function**:
  ```dart
  (meal) {
    selectMeal(context, meal);
  }
  ```
  This anonymous function takes a `Meal` as input and calls the `selectMeal` function from `MealsScreen`, passing `context` and the selected `Meal`.

---

### **4. `selectMeal` Handles Navigation**
The `selectMeal` method in `MealsScreen` contains the logic for navigation. For example:
```dart
void selectMeal(BuildContext context, Meal meal) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MealsDetailsScreen(meal: meal),
    ),
  );
}
```

This method:
1. Receives the `context` and the selected `Meal`.
2. Uses the `Navigator` to push the `MealsDetailsScreen` and pass the selected `Meal` to it.

---

### **How Everything Works Together**

Here’s the complete flow:
1. **`MealsScreen` creates a `MealItem`** and provides a callback:
   ```dart
   MealItem(
     meal: meals[index],
     onSelectMeal: (meal) {
       selectMeal(context, meal); // Callback passed to `MealItem`
     },
   );
   ```

2. **The user taps the `MealItem`.**
   - Inside `MealItem`, the `onTap` of `InkWell` is triggered:
     ```dart
     onTap: () {
       onSelectMeal(meal); // Calls the callback
     },
     ```
   - `onSelectMeal` is the callback provided by `MealsScreen`.

3. **The callback is executed in `MealsScreen`.**
   - The anonymous function `(meal) { selectMeal(context, meal); }` is called.
   - This calls `selectMeal`, which handles navigation:
     ```dart
     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (ctx) => MealsDetailsScreen(meal: meal),
       ),
     );
     ```

---

### **Why Use This Pattern?**
Using a callback function provides the following benefits:
1. **Flexibility**: You can reuse `MealItem` in other parts of the app and pass a different callback depending on the desired behavior.
2. **Separation of Concerns**: `MealItem` only handles displaying data and notifying its parent when tapped. It doesn’t handle navigation or app-specific logic.
3. **Scalability**: If navigation logic changes, you only update it in `MealsScreen`, not in every `MealItem`.

---

### Example for Clarity

Let’s write a simplified example to demonstrate this pattern:

#### `MealsScreen` (Parent):
```dart
class MealsScreen extends StatelessWidget {
  final List<String> meals = ["Pizza", "Burger", "Pasta"];

  void selectMeal(BuildContext context, String meal) {
    print("Navigating to details of $meal");
    // Example of navigation logic
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (meal) {
          selectMeal(context, meal); // Pass callback
        },
      ),
    );
  }
}
```

#### `MealItem` (Child):
```dart
class MealItem extends StatelessWidget {
  final String meal;
  final void Function(String meal) onSelectMeal;

  const MealItem({required this.meal, required this.onSelectMeal});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(meal),
      onTap: () {
        onSelectMeal(meal); // Call the callback
      },
    );
  }
}
```

---

### **Key Takeaways**
- The callback (`onSelectMeal`) in `MealItem` lets the parent (`MealsScreen`) control what happens when a meal is tapped.
- `MealsScreen` defines `selectMeal`, which handles navigation, and passes it to `MealItem` as a callback.
- When a user taps the `MealItem`, the callback is executed, calling `selectMeal` in the parent.

Does this explanation clear things up? Let me know if you’d like to explore any part further!
*/