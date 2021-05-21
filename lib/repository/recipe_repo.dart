import 'package:RecipeApp/models/recipe_model.dart';
import 'package:hive/hive.dart';

class RecipeRepo {
  Future<Box<RecipeModel>> _box;

  RecipeRepo() {
    _box = Hive.openBox('recipeBox');
  }

  void saveRecipe(RecipeModel recipe) async {
    var box = await _box;
    box.add(recipe);
  }

  Future<HiveList<RecipeModel>> createRecipeList() async {
    var box = await _box;
    return HiveList(box);
  }
}
