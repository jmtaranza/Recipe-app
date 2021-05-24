import 'dart:io';
import 'package:RecipeApp/views/feed.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../widget/bottomnav.dart';

class CreatePost extends StatefulWidget {
  final String userName;
  CreatePost({this.userName});
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  bool isLoading = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  String description;
  String title;
  File _imageFile;
  String downloadUrl;
  final picker = ImagePicker();

  Future takeImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String fileName = basename(_imageFile.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) => print("Done: $value"));
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      addFeed();
    }
  }

  addFeed() async {
    title = titleController.text;
    description = descriptionController.text;
    Map<String, dynamic> feedData = {
      "title": title,
      "imageUrl": downloadUrl,
      "description": description,
      "postedBy": widget.userName,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    DatabaseMethods().addFeed(title, feedData);
    print(title);
    print(description);
    print(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NavItems(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              RaisedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Confirm'),
                      content: Text('Are you sure you want to post?'),
                      actions: [
                        RaisedButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            uploadImageToFirebase(context);
                            if (isLoading == true) {
                              print('image printed');
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Success!'),
                                  content: Text('Posted successfully'),
                                  actions: [
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                        if (isLoading == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Feed(
                                                    userName: widget.userName)),
                                          );
                                        }
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('POST'),
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                _input(context),
                GestureDetector(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Upload image'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context, '');
                                takeImage();
                              },
                              child: Icon(Icons.camera_alt),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context, '');
                                selectImage();
                              },
                              child: Icon(Icons.photo_album),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    child: Container(
                      child: _imageFile != null
                          ? Image.file(_imageFile)
                          : Icon(
                              Icons.add_a_photo,
                              size: 30.0,
                              color: Colors.white,
                            ),
                    ),
                    radius: 80,
                    backgroundColor: Colors.red[200],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
        ));
  }

  Widget _input(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 15.0,
            top: 0.0,
          ),
          margin: EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(45.0),
            ),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 20,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter a title...",
                ),
                validator: (val) {
                  return val.isEmpty ? "Field must not be empty" : null;
                },
                controller: titleController,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 20,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Description...",
                ),
                validator: (val) {
                  return val.isEmpty ? "Field must not be empty" : null;
                },
                controller: descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
