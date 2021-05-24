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
  bool isLoading = false;
  bool haveRecipeSearched = false;

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
                viewRecipe();
              }),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getUserRecipes() async {
    DatabaseMethods().getUserRecipes(Constants.myName).then((snapshots) {
      setState(() {
        recipes = snapshots;
        print(
            "we got the data + ${recipes.toString()} this is name  ${Constants.myName}");
      });
    });
    QuerySnapshot result = await Firestore.instance
        .collection('recipe')
        .where('publishedBy', isEqualTo: widget.userName)
        .getDocuments();
    List<DocumentSnapshot> result2 = result.documents;
    numOfPublications = result2.length;
    print(numOfPublications);
  }

  Stream recipes;
  viewRecipe() {
    print('test tapped'); //kaabot
    return StreamBuilder(
      stream: recipes,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return recipeCard(
                    snapshot.data.documents[index].data['title'],
                    snapshot.data.documents[index].data["category"],
                    snapshot.data.documents[index].data["imageUrl"],
                  );
                })
            : Container(
                child: Text('No searched recipe yet'),
              );
      },
    );
  }

  recipeCard(title, category, imageUrl) {
    print(title);
    print(category); //dili pa print idk
    /*  return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.red,
        width: MediaQuery.of(context).size.width - 240.0,
        height: MediaQuery.of(context).size.height - 50.0,
        decoration: imageUrl != null
            ? BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            Text(
              category,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            )
          ],
        ),
      ),
    ); */
  }

  @override
  void initState() {
    getUserRecipes();
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
