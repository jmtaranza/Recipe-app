import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/helper/authenticate.dart';
import 'package:RecipeApp/models/post_model.dart';

import 'package:RecipeApp/services/auth.dart';
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
                        child: CircleAvatar(
                          child: ClipOval(
                              //avatar
                              // child: Image(
                              //   height: 50.0,
                              //   width: 50.0,
                              //   image: NetworkImage(
                              //     snapshot.data.documents[index].data['imageUrl'],
                              //   ),
                              //   fit: BoxFit.cover,
                              // ),
                              ),
                        ),
                      ),
                      title: Text(
                        snapshot.data.documents[index].data['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.documents[index].data['time'].toString(),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_border),
                        iconSize: 30.0,
                        onPressed: () => print('Like post'),
                      ),
                    ),
                    InkWell(
                      onDoubleTap: () => print('Like post'),
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
                              time: snapshot.data.documents[index].data['time']
                                  .toString(),
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
                            snapshot.data.documents[index].data['description'],
                          ),
                          IconButton(
                            icon: Icon(Icons.bookmark_border),
                            iconSize: 30.0,
                            onPressed: () => print('Save post'),
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
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Feed',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Divider(
                thickness: 3,
              ),
              Flexible(child: feedList()),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePost(userName: widget.userName),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
      ),
    );
  }
}
