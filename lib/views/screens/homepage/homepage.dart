import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/helper/helperfunctions.dart';
import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
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
    getUserPublications();
    super.initState();
  }

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  Stream breakfast;
  Stream lunch;
  Stream dinner;
  Stream snacks;
  getUserPublications() async {
    DatabaseMethods()
        .getPublicationBasedOnCategory('Breakfast')
        .then((snapshots) {
      setState(() {
        breakfast = snapshots;
      });
    });
    DatabaseMethods().getPublicationBasedOnCategory('Lunch').then((snapshots) {
      setState(() {
        lunch = snapshots;
      });
    });
    DatabaseMethods().getPublicationBasedOnCategory('Dinner').then((snapshots) {
      setState(() {
        dinner = snapshots;
      });
    });
    DatabaseMethods().getPublicationBasedOnCategory('Snacks').then((snapshots) {
      setState(() {
        snacks = snapshots;
      });
    });
  }

  publicationCard(title, category, imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(right: 15),
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget publicationsList(stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return publicationCard(
                    snapshot.data.documents[index].data['title'],
                    snapshot.data.documents[index].data["category"],
                    snapshot.data.documents[index].data["imageUrl"],
                  );
                })
            : Container(
                child: Text('No publications yet'),
              );
      },
    );
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
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Container(
                          width: double.infinity,
                          height: 450.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        height: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(0, 5),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://static.toiimg.com/thumb/53110049.cms?width=1200&height=900",
                                            ),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Recipe of the day',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'BreakFast',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  child: publicationsList(breakfast)),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Lunch',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  child: publicationsList(lunch)),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Dinner',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  child: publicationsList(dinner)),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
      ),
    );
  }
}