import 'package:RecipeApp/constant.dart';
import 'package:RecipeApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRecipeScreen extends StatefulWidget {
  final String userName;
  String title;

  ViewRecipeScreen({this.userName, this.title});

  @override
  _ViewRecipeScreenState createState() => _ViewRecipeScreenState();
}

class Ingredients {
  final String ingredient;
  final String amount;

  Ingredients({this.ingredient, this.amount});
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
  @override
  void initState() {
    getRecipeInfo();
    super.initState();
  }

  Stream recipe;
  getRecipeInfo() async {
    DatabaseMethods().getRecipeInfo(widget.title).then((snapshots) {
      setState(() {
        recipe = snapshots;
      });
    });
  }

  Widget stepsCard(steps) {
    List<String> items = List.from(steps);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        int stepNumber = index + 1;
        return Container(
            color: Colors.orange,
            child: Row(
              children: [
                Text(
                  "Step #$stepNumber ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  item,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      },
    );
  }

  Widget ingredientsCard(ingredients) {
    List<Map<String, dynamic>> items = List.from(ingredients);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index]["ingredient"];
        final amount = items[index]["amount"];
        int ingredientNumber = index + 1;
        return Container(
            color: Colors.green,
            child: Row(
              children: [
                Text("Ingredient #$ingredientNumber ",
                    style: TextStyle(fontSize: 20)),
                SizedBox(width: 30),
                Text(item + " " + amount,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ));
      },
    );
  }

  Widget recipeScreen() {
    return StreamBuilder(
      stream: recipe,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 600,
                        height: 400,
                        decoration:
                            snapshot.data.documents[index].data['imageUrl'] !=
                                    null
                                ? BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot.data
                                            .documents[index].data['imageUrl']),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))
                                : BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                      ),
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                            snapshot.data.documents[index].data['title'],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: [
                            Text('Ingredients',
                                style: TextStyle(
                                  fontSize: 25,
                                )),
                            Container(
                                width: 600,
                                child: ingredientsCard(snapshot.data
                                    .documents[index].data['ingredients'])),
                            Text('Steps',
                                style: TextStyle(
                                  fontSize: 25,
                                )),
                            Container(
                                width: 600,
                                child: stepsCard(snapshot
                                    .data.documents[index].data['steps'])),
                          ],
                        ),
                      ),
                    ],
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
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xFFEDF0F6),
      body: Container(
          padding: EdgeInsets.only(top: 40.0),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(child: recipeScreen())),
    );
  }
}
