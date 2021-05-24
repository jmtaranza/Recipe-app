import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPostScreen extends StatefulWidget {
  final String userName;
  final String title;
  final String postedBy;
  final int time;
  int likes;
  final String imageUrl;
  final String description;

  ViewPostScreen(
      {this.userName,
      this.imageUrl,
      this.description,
      this.postedBy,
      this.time,
      this.title,
      this.likes});

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  int numOfComments = 0;
  Stream<QuerySnapshot> comments;
  TextEditingController commentController = new TextEditingController();
  Widget _buildComment(index, snapshot) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
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
                color: Colors.grey, borderRadius: BorderRadius.circular(30)),
            child: Text(
                snapshot.data.documents[index].data['commentBy']
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
          snapshot.data.documents[index].data['commentBy'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          snapshot.data.documents[index].data['message'],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),
      ),
    );
  }

  addComment() {
    String message;
    if (commentController.text.isNotEmpty) {
      message = commentController.text;
      Map<String, dynamic> commentData = {
        "commentBy": Constants.myName,
        "message": message,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addComment(widget.title, commentData);

      setState(() {
        commentController.text = "";
      });
    }
  }

  addLike() async {
    Map<String, dynamic> likeData = {
      "likes": widget.likes + 1,
    };
    DatabaseMethods().addLike(widget.title, likeData);
    setState(() {
      widget.likes++;
    });
  }

  Widget commentMessages() {
    return StreamBuilder(
      stream: comments,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildComment(index, snapshot);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserComments();
    super.initState();
  }

  getUserComments() async {
    DatabaseMethods().getComments(widget.title).then((snapshots) {
      setState(() {
        comments = snapshots;
      });
    });
    update();
  }

  update() async {
    QuerySnapshot result = await Firestore.instance
        .collection('feed')
        .document(widget.title)
        .collection("comments")
        .getDocuments();
    List<DocumentSnapshot> result2 = result.documents;
    setState(() {
      numOfComments = result2.length;
      print(numOfComments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0),
              width: double.infinity,
              height: 600.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30.0,
                              color: Colors.black,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                widget.postedBy + "'s post",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onDoubleTap: () {
                            addLike();
                            update();
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
                                image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.postedBy,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.description,
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          iconSize: 30.0,
                                          onPressed: () {
                                            addLike();
                                            update();
                                          }),
                                      Text(
                                        widget.likes.toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20.0),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.chat),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          print('Chat');
                                        },
                                      ),
                                      Text(
                                        numOfComments.toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            SizedBox(height: 10.0),
            Container(
                width: double.infinity,
                height: 600.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: commentMessages())
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
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
                        // child: Image(
                        //   height: 48.0,
                        //   width: 48.0,
                        //   image: AssetImage(widget.post.authorImageUrl),
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xFF23B66F),
                    onPressed: () {
                      addComment();
                      update();
                    },
                    child: Icon(
                      Icons.send,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
