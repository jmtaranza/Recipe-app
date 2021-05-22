import 'package:RecipeApp/helper/authenticate.dart';

import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublishRecipe extends StatefulWidget {
  @override
  _PublishRecipeState createState() => _PublishRecipeState();
}

class _PublishRecipeState extends State<PublishRecipe> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ),
        body: Container(
          child: Text('kuan ni diri katong publish recipe'),
        ),
        bottomNavigationBar: MyBottomNavBar(),
      ),
    );
  }
}
