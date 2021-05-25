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

  searchByRecipe(title) async {
    return Firestore.instance
        .collection("recipe")
        .where('title', isEqualTo: title)
        .snapshots();
  }

  viewByRecipe(title, recipeData) async {
    return Firestore.instance
        .collection(recipeData)
        .where('recipeData', isEqualTo: recipeData)
        .snapshots();
  } //kani wa koy sure sa ppg map2 sa recipedata pag kuha niya tanan info

  Future<void> addRecipe(String title, recipeData) {
    Firestore.instance
        .collection("recipe")
        .document(title)
        .setData(recipeData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addFeed(String title, feedData) {
    Firestore.instance
        .collection("feed")
        .document(title)
        .setData(feedData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addComment(String title, commentData) {
    Firestore.instance
        .collection("feed")
        .document(title)
        .collection("comments")
        .add(commentData)
        .catchError((e) {
      print(e.toString());
    });
  }

  addLike(String title, likeData) async {
    Firestore.instance
        .collection("feed")
        .document(title)
        .updateData(likeData)
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

  getUserRecipes(String userName) async {
    return Firestore.instance
        .collection("recipe")
        .where('publishedBy', isEqualTo: userName)
        .snapshots();
  }

  getUserFeeds() async {
    return Firestore.instance.collection("feed").snapshots();
  }

  getUserFeedInfo(title) async {
    return Firestore.instance.collection("feed").document(title).snapshots();
  }

  getComments(String title) async {
    return Firestore.instance
        .collection("feed")
        .document(title)
        .collection("comments")
        .orderBy('time')
        .snapshots();
  }
}
