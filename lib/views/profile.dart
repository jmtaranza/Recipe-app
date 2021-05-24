import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/services/auth.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
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
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          )),
    );
  }

  publication() {
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          publicationCard(),
          publicationCard(),
          publicationCard(),
        ],
      ),
    );
  }

  publicationCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width - 240.0,
            height: MediaQuery.of(context).size.height - 50.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChangeNotifierProvider(
          create: (context) => NavItems(),
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    AuthService().signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
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
                      height: 80,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: AssetImage("assets/images/user1.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Column(
                            children: [
                              Text('0'),
                              Text('Following',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                              fontSize: 20,
                            )),
                        Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            '+Create new list',
                            style: TextStyle(
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
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ),
                  publication(),
                ],
              ),
              bottomNavigationBar: MyBottomNavBar(),
            ),
          )),
    );
  }
}
