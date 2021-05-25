import 'package:RecipeApp/helper/constants.dart';
import 'package:RecipeApp/services/database.dart';

import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:RecipeApp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String userName;

  Search({this.userName});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int numOfPublications = 0;
  TextEditingController searchEditingController = new TextEditingController();
  Stream searchResultSnapshot;
  Stream viewResultSnapshot;
  bool isLoading = false;
  bool haveRecipeSearched = false;
  String recipeData;
  String title;

  Widget recipeList() {
    return StreamBuilder(
      stream: searchResultSnapshot,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return recipeTile(
                    snapshot.data.documents[index].data["title"],
                  );
                })
            : Container();
      },
    );
  }

  Widget viewrecipeList() {
    return StreamBuilder(
      stream: viewResultSnapshot,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return viewrecipeTile(
                    snapshot.data.documents[index].data["title"],
                    snapshot.data.documents[index].data["category"],
                    snapshot.data.documents[index].data["imageUrl"],
                  );
                })
            : Container();
      },
    );
  }

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      DatabaseMethods()
          .searchByRecipe(searchEditingController.text)
          .then((snapshots) {
        setState(() {
          searchResultSnapshot = snapshots;
          print("$searchResultSnapshot");
          isLoading = false;
          haveRecipeSearched = true;
        });
      });
    }
  }

  initiateView() async {
    /*  DatabaseMethods().viewByRecipe(title, recipeData).then((snapshots) {
      setState(() {
        print('naka initiate view');
        viewResultSnapshot = snapshots;
        print("$viewResultSnapshot");
        isLoading = false;
        haveRecipeSearched = true;
      });
    }); */
  }

  Widget recipeTile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      "View",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              onTap: () {
                print('test');
                initiateView(); // error pako diri sa pag sud sa database
                viewrecipeList();
              }),
        ],
      ),
    );
  }

  Widget viewrecipeTile(String title, String category, String imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                category,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Container(child: Image.network(imageUrl)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      color: Color(0x54FFFFFF),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchEditingController,
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  hintText: "Search recipe ...",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              initiateSearch();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0x36FFFFFF),
                                        const Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.search),
                            ),
                          )
                        ],
                      ),
                    ),
                    recipeList(),
                  ],
                ),
              ),
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
      ),
    );
  }
}
