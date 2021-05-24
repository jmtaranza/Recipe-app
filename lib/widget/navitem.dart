import 'package:RecipeApp/views/feed.dart';
import 'package:RecipeApp/views/profile.dart';
import 'package:RecipeApp/views/publishrecipe.dart';
import 'package:RecipeApp/views/screens/homepage/homepage.dart';
import 'package:RecipeApp/views/search.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

class NavItem {
  final int id;
  final String icon;
  final Widget destination;

  NavItem({this.id, this.icon, this.destination});
}

// If we made any changes here Provider package rebuid those widget those use this NavItems
class NavItems extends ChangeNotifier {
  // By default first one is selected
  int selectedIndex;

  void chnageNavIndex(int index) {
    selectedIndex = index;
    // if any changes made it notify widgets that use the value
    notifyListeners();
  }

  List<NavItem> items = [
    NavItem(
      id: 1,
      icon: "assets/images/homepage.png",
      destination: Homepage(userName: Constants.myName),
    ),
    NavItem(
      id: 2,
      icon: "assets/images/searchicon.png",
      destination: Search(userName: Constants.myName),
    ),
    NavItem(
      id: 3,
      icon: "assets/images/addlogo.png",
      destination: PublishRecipe(userName: Constants.myName),
    ),
    NavItem(
      id: 4,
      icon: "assets/images/bulletlist.png",
      destination: Feed(userName: Constants.myName),
    ),
    NavItem(
      id: 5,
      icon: "assets/images/smiley.png",
      destination: Profile(userName: Constants.myName),
    ),
  ];
}
