import 'package:RecipeApp/models/category_model.dart';
import 'package:hive/hive.dart';

class CategoryRepo {
  Future<Box<CategoryModel>> _box;

  CategoryRepo() {
    _box = Hive.openBox('categoryBox');
  }

  void saveCategory(CategoryModel categoryModel) async {
    var box = await _box;
    box.put(categoryModel.id, categoryModel);
  }

  Future<List<CategoryModel>> readCategories() async {
    var box = await _box;
    return box.values.toList();
  }

  void updateCategory(CategoryModel categoryModel) async {
    var box = await _box;
    box.put(categoryModel.id, categoryModel);
  }

  void deleteCategory(String id) async {
    var box = await _box;
    box.delete(id);
  }
}
