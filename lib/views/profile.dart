import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String userName;

  Profile({this.userName});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  favorites() {
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          myFaveCard(),
          myFaveCard(),
          myFaveCard(),
        ],
      ),
    );
  }

  myFaveCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width - 240.0,
            height: MediaQuery.of(context).size.height - 50.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/pizzafries.jpg"),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          )),
    );
  }

  publicationCard(title, category, imageUrl) {
    print(title);
    print(category);
    bool yes = true;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(right: 15),
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
          )),
    );
  }

  Widget publicationsList() {
    return StreamBuilder(
      stream: publications,
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
  void initState() {
    getUserPublications();
    super.initState();
  }

  Stream publications;
  getUserPublications() async {
    DatabaseMethods().getUserPublications(Constants.myName).then((snapshots) {
      setState(() {
        publications = snapshots;
        print(
            "we got the data + ${publications.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NavItems(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.exit_to_app),
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 100,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage("assets/images/post0.jpg"),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text('0'),
                            Text('Publications',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('0'),
                            Text('Following',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('0'),
                            Text(
                              'Followers',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Row(
                    children: [
                      Text('Favourites',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          '+Create new list',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                favorites(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Row(
                    children: [
                      Text('Publications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                    ],
                  ),
                ),
                Flexible(child: publicationsList()),
              ],
            ),
            bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
          ),
        ));
  }
}
