import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
          ),
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          title: TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Search for recipe",
            ),
            keyboardType: TextInputType.text,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Container(),
        bottomNavigationBar: MyBottomNavBar(),
      ),
    );
  }
}
