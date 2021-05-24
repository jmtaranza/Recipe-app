import 'package:RecipeApp/widget/navitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomNavBar extends StatelessWidget {
  final String userName;
  MyBottomNavBar({
    Key key,
    this.userName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<NavItems>(
      builder: (context, navItems, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 30), //30
        // just for demo
        // height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -7),
              blurRadius: 30,
              color: Color(0xFF4B1A39).withOpacity(0.2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              navItems.items.length,
              (index) => buildIconNavBarItem(
                isActive: navItems.selectedIndex == index ? true : false,
                icon: navItems.items[index].icon,
                press: () {
                  navItems.chnageNavIndex(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => navItems.items[index].destination,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildIconNavBarItem(
      {String icon, Function press, bool isActive = false}) {
    return IconButton(
      icon: Image.asset(
        icon,
        color: isActive ? Colors.red : Color(0xFFD1D4D4),
        height: 25,
      ),
      onPressed: press,
    );
  }
}
