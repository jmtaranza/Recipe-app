import 'package:RecipeApp/widget/navitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublishRecipe extends StatefulWidget {
  @override
  _PublishRecipeState createState() => _PublishRecipeState();
}

class _PublishRecipeState extends State<PublishRecipe> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NavItems(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: null, //idk mubalik guro shas home page haha
                        child: Container(
                          alignment: Alignment(-0.9, 0.0),
                          child: Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      color: Colors.red[200],
                      height: 60.0,
                      width: 360.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: GestureDetector(
                    child: CircleAvatar(
                      child: Container(
                        child: Icon(
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
                Input(),
              ],
            ),
          ),
        ));
  }
}

class Input extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter a title...",
                  ),
                ),
              ],
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
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter category...",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Ingredients',
              style: TextStyle(
                color: Colors.red[200],
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "All purpose flour", //idk
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  width: 180.0,
                ),
                Container(
                  child: Text(
                    "2 cups", //idk
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              padding:
                  const EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
              child: new RaisedButton(
                elevation: 100.0,
                hoverColor: Colors.red[200],
                disabledColor: Colors.grey.shade200,
                child: const Text(
                  '+ add ingredient',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: null,
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

            //widget
            Row(
              children: <Widget>[
                Text(
                  "*",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Preheat the oven to 450 degrees", //
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            new Container(
              padding:
                  const EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
              child: new RaisedButton(
                elevation: 100.0,
                hoverColor: Colors.red[200],
                disabledColor: Colors.grey.shade200,
                child: const Text(
                  '+ add step',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: null, //idk id id man cguro ni AHHA
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
                  onPressed:
                      null, // idk i think ma makita sha sa feed and ma publish sd sha sa home
                )),
          ],
        ),
      ),
    );
  }
}
