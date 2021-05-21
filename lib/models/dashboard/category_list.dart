import 'package:RecipeApp/models/category_model.dart';
import 'package:RecipeApp/models/dashboard/add_category_card.dart';
import 'package:RecipeApp/models/dashboard/category_delete_dialog.dart';
import 'package:RecipeApp/provider/app_provider.dart';

import 'package:RecipeApp/views/screens/homepage/category_screen.dart';
import 'package:RecipeApp/widget/homepagewidget/wave_border_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return ListView.separated(
            itemBuilder: (context, index) {
              if (index == appProvider.categories.length) {
                return AddCategoryCard();
              }

              CategoryModel category = appProvider.categories[index];
              return GestureDetector(
                onLongPress: () {
                  return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return CategoryDeleteDialog(
                        categoryModel: category,
                      );
                    },
                  );
                },
                child: WaveBorderCard(
                  recipeCardName: category.name,
                  categoryId: category.id,
                  width: 200,
                  imageFile: category.file != null ? category.file : null,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animationOne, animationTwo) =>
                          CategoryScreen(categoryIndex: index),
                      transitionsBuilder:
                          (context, animationOne, animationTwo, child) {
                        return FadeTransition(
                            opacity: animationOne, child: child);
                      },
                      transitionDuration: Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 20.0),
            itemCount: appProvider.categories.length + 1,
            scrollDirection: Axis.horizontal,
          );
        },
      ),
    );
  }
}
