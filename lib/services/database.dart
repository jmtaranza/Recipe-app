import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future<void> addRecipe(String title, recipeData) {
    Firestore.instance
        .collection("recipe")
        .document(title)
        .setData(recipeData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserPublications(String userName) async {
    return Firestore.instance
        .collection("recipe")
        .where('publishedBy', isEqualTo: userName)
        .snapshots();
  }
}
