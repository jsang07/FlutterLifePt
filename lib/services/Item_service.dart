import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selfintro/model/Item.dart';

class ItemService {
  final _itemsRef = FirebaseFirestore.instance.collection('items');
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> createItem(String id, String title, String content,
      String userName, List images) async {
    final item = Item(
        id: id,
        title: title,
        content: content,
        userMail: currentUser!.email.toString(),
        userUid: currentUser!.uid,
        userName: userName,
        images: images,
        timestamp: Timestamp.now());
    await _itemsRef.add(item.toJson());
  }

  Future<void> updateItem(Item item, String newTitle, newContent) async {
    await _itemsRef.doc(item.id).update({
      'title': newTitle,
      'content': newContent,
    });
  }

  Future<void> deleteItem(Item item) async {
    await _itemsRef.doc(item.id).delete();
  }
}
