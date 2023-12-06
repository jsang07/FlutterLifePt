import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/model/Item.dart';

class SearchProvider extends ChangeNotifier {
  List<Item> searchs = [];

  searchItems(String search) {
    FirebaseFirestore.instance
        .collection('items')
        .where('title', isEqualTo: search)
        .snapshots()
        .listen((searchs) {
      this.searchs =
          searchs.docs.map((doc) => Item.fromJson(doc.data())).toList();
    });
    notifyListeners();
    return searchs;
  }
}
