import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:RecipeApp/widget/navitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../widget/bottomnav.dart';

class PublishRecipe extends StatefulWidget {
  final String userName;
  PublishRecipe({this.userName});
  @override
  _PublishRecipeState createState() => _PublishRecipeState();
}

class _PublishRecipeState extends State<PublishRecipe> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  bool isLoading = false;
  List<TextEditingController> _ingredientControllers = new List();
  List<TextEditingController> _amountControllers = new List();
  List<TextEditingController> _stepControllers = new List();
  TextEditingController titleController = new TextEditingController();
  String category;
  String title;
  List ingredientList = [];
  List stepList = [];
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
      addRecipe();
    }
  }

  addRecipe() async {
    title = titleController.text;
    category = dropdownValue;
    for (int i = 0; i < ingredients; i++) {
      ingredientList.add({
        "ingredient": _ingredientControllers[i].text,
        "amount": _amountControllers[i].text
      });
    }
    for (int i = 0; i < steps; i++) {
      stepList.add(_stepControllers[i].text);
    }
    Map<String, dynamic> recipeData = {
      "title": title,
      "imageUrl": downloadUrl,
      "ingredients": FieldValue.arrayUnion(ingredientList),
      "steps": FieldValue.arrayUnion(stepList),
      "category": category,
      "publishedBy": widget.userName,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    DatabaseMethods().addRecipe(title, recipeData);
    print(ingredientList);
    print(stepList);
    print(downloadUrl);
  }

  String dropdownValue = 'Breakfast';
  int ingredients = 1;
  int steps = 1;
  @override
  Widget build(BuildContext context) {
    var ingredientController = new TextEditingController();
    _ingredientControllers.add(ingredientController);
    var amountController = new TextEditingController();
    _amountControllers.add(amountController);
    var stepController = new TextEditingController();
    _stepControllers.add(stepController);
    return ChangeNotifierProvider(
        create: (context) => NavItems(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Recipe'),
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Container(
                  child: GestureDetector(
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
                ),
                SizedBox(
                  height: 5.0,
                ),
                _input(context),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(userName: widget.userName),
        ));
  }

  Row ingredientsField(index) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Ingredient",
            ),
            validator: (val) {
              return val.isEmpty ? "Field must not be empty" : null;
            },
            controller: _ingredientControllers[index],
          ),
        ),
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Amount",
            ),
            validator: (val) {
              return val.isEmpty ? "Field must not be empty" : null;
            },
            controller: _amountControllers[index],
          ),
        ),
      ],
    );
  }

  Row stepsField(index) {
    int stepNumber = index + 1;
    return Row(
      children: [
        Text('*Step $stepNumber', style: TextStyle(color: Colors.red)),
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Step",
            ),
            validator: (val) {
              return val.isEmpty ? "Field must not be empty" : null;
            },
            controller: _stepControllers[index],
          ),
        ),
      ],
    );
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment(-1, 0.0),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.red[200],
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        category = dropdownValue;
                      });
                    },
                    items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment(-1, 0.0),
                child: Text(
                  'Ingredients',
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 20,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                    ingredients, (index) => ingredientsField(index)),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
                child: RaisedButton(
                  elevation: 100.0,
                  hoverColor: Colors.red[200],
                  disabledColor: Colors.grey.shade200,
                  child: const Text(
                    'add new ingredient',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      ingredients++;
                      var ingredientController = new TextEditingController();
                      _ingredientControllers.add(ingredientController);
                      var amountController = new TextEditingController();
                      _amountControllers.add(amountController);
                      print(ingredients);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Steps',
                style: TextStyle(
                  color: Colors.red[200],
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: List.generate(
                  steps,
                  (index) => stepsField(index),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
                child: RaisedButton(
                  elevation: 100.0,
                  hoverColor: Colors.red[200],
                  disabledColor: Colors.grey.shade200,
                  child: const Text(
                    'add new step',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      steps++;
                      var stepController = new TextEditingController();
                      _stepControllers.add(stepController);
                      print(steps);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
                child: new RaisedButton(
                    hoverColor: Colors.red[200],
                    disabledColor: Colors.red[200],
                    child: const Text(
                      'Add new recipe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      title = titleController.text;
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm'),
                          content:
                              Text('Do you wish to add the "$title" recipe?'),
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
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Success!'),
                                      content: Text(
                                          '"$title" recipe has been added successfully'),
                                      actions: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            if (isLoading == true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PublishRecipe(
                                                            userName: widget
                                                                .userName)),
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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  check() {
    for (int i = 0; i < _ingredientControllers.length; i++) {
      print(_ingredientControllers[i].text);
    }
  }
}
