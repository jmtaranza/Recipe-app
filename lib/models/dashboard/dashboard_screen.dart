import 'package:RecipeApp/models/dashboard/category_list.dart';
import 'package:RecipeApp/provider/add_recipe_provider.dart';
import 'package:RecipeApp/utils/responsive_layout.dart';
import 'package:RecipeApp/views/screens/homepage/add_recipe_screen.dart';

import 'package:RecipeApp/widget/homepagewidget/custom_app_bar.dart';
import 'package:RecipeApp/widget/homepagewidget/lazy_network_image.dart';
import 'package:RecipeApp/widget/homepagewidget/wave_border_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  Widget heightPlaceholder(bool isMobileScreen) => SizedBox(
        height: isMobileScreen ? 20.0 : 30.0,
      );

  @override
  Widget build(BuildContext context) {
    var isMobileScreen = ResponsiveLayout.isSmallScreen(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 300.0,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: LazyNetworkImage(
                      imageUrl: 'https://loremflickr.com/300/300/food'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: isMobileScreen ? 40.0 : 50.0,
              horizontal: isMobileScreen ? 20.0 : 30.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Recipe of the day',
                  style: Theme.of(context).textTheme.headline5,
                ),
                heightPlaceholder(isMobileScreen),
                WaveBorderCard(
                  recipeCardName: "Breakfast",
                ),
                heightPlaceholder(isMobileScreen),
                Text(
                  "Categories",
                  style: Theme.of(context).textTheme.headline5,
                ),
                heightPlaceholder(isMobileScreen),
                /*   CategoryList() */
              ]),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChangeNotifierProvider<AddRecipeProvider>(
                  create: (context) => AddRecipeProvider(),
                  child: AddRecipeScreen(),
                ),
              ),
            );
          },
          icon: Icon(
            Icons.add_circle,
            size: 48,
          ),
        ),
      ),
    );
  }
}
