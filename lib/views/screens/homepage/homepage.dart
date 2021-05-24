import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/helper/helperfunctions.dart';
import 'package:RecipeApp/models/dashboard/dashboard_screen.dart';

import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/homepagewidget/responsive_widget.dart';
import 'package:RecipeApp/widget/navitem.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final String userName;

  Homepage({this.userName});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Constants.myName = "";
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
          child: MainScreen(),
        ),
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      smallScreen: DashboardScreen(),
      mediumScreen: DashboardScreen(),
      largeScreen: DashboardScreen(),
    );
  }
}
