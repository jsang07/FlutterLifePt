import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/model/Item.dart';

class ItemProvider extends ChangeNotifier {
  final _itemsRef = FirebaseFirestore.instance.collection('items');

  List<Item> items = [];

  List<Item> getItems() {
    _itemsRef
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((items) {
      this.items = items.docs.map((doc) => Item.fromJson(doc.data())).toList();
      notifyListeners();
    });
    return items;
  }
}
