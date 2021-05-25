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
  Stream viewDataSnapshot;
  bool isLoading = false;
  bool haveRecipeSearched = false;
  String recipeData;
  String title;
  String category;
  String imageUrl;

  Widget viewrecipeList() {
    return StreamBuilder(
      stream: viewResultSnapshot,
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

  Widget viewRecipeData(String title, String category, String imageUrl) {
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
    DatabaseMethods().viewByRecipe(title, recipeData).then((snapshots) {
      setState(() {
        print('naka initiate view');
        viewResultSnapshot = snapshots;
        print("$viewResultSnapshot");
        haveRecipeSearched = true;
        print(recipeData);
      });
    });
  }

  Widget recipeTile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: GestureDetector(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onTap: () {
                    print('napislit ang title');
                    initiateView(); // same info raman gi kwaan
                    /*  recipeList();  dapat ma clear ang gi display ni recipelist unya puli si view recipedata  dapat ang sa gipilian ra*/
                    viewRecipeData(title, category, imageUrl);
                    //null iya valuess
                    /* print(title);
                    print(category);
                    print(imageUrl); */
                  },
                ),
              ),
            ],
          ),
          Spacer(),
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
              Container(height: 50, width: 50, child: Image.network(imageUrl)),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      color: Colors.grey[100],
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
                    viewrecipeList(),
                    /*    viewRecipeData(title), */ //dri ra ma display tanan
                  ],
                ),
              ),
        floatingActionButton: GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "View",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onTap: () {
              print('test');
              initiateView();
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
