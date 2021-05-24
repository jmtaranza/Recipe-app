import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:RecipeApp/views/createpost.dart';
import 'package:RecipeApp/views/screens/view_post_screen.dart';
import 'package:RecipeApp/widget/bottomnav.dart';
import 'package:RecipeApp/widget/navitem.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  final String userName;

  Feed({this.userName});
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  Widget feedList() {
    return StreamBuilder(
      stream: feed,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildPost(index, snapshot);
                })
            : Container(
                child: Text('No feed yet'),
              );
      },
    );
  }

  @override
  void initState() {
    getUserFeeds();
    super.initState();
  }

  Stream feed;
  getUserFeeds() async {
    DatabaseMethods().getUserFeeds().then((snapshots) {
      setState(() {
        feed = snapshots;
        print(
            "we got the data + ${feed.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  Widget _buildPost(index, snapshot) {
    int timestamp = snapshot.data.documents[index].data['time'];
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          width: double.infinity,
          height: 560.0,
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
                    ListTile(
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                              snapshot.data.documents[index].data['postedBy']
                                  .substring(0, 1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                      title: Text(
                        snapshot.data.documents[index].data['postedBy'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.documents[index].data['description'],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewPostScreen(
                              title:
                                  snapshot.data.documents[index].data['title'],
                              description: snapshot
                                  .data.documents[index].data['description'],
                              userName: widget.userName,
                              imageUrl: snapshot
                                  .data.documents[index].data['imageUrl'],
                              postedBy: snapshot
                                  .data.documents[index].data['postedBy'],
                              time: snapshot.data.documents[index].data['time'],
                              likes:
                                  snapshot.data.documents[index].data['likes'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 5),
                              blurRadius: 8.0,
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data.documents[index].data['imageUrl'],
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(timestamp)
                                .toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(child: feedList()),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
            child: InkResponse(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePost(userName: widget.userName),
              ),
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        )),
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
      ),
    );
  }
}
