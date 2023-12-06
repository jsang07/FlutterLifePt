import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // send message
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    //create new message
    Message newMessage = Message(
        senderId: currentUserId,
        receiverId: receiverId,
        sentTime: DateTime.now(),
        content: message);

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(currentUserId + receiverId)
        .collection('messages')
        .add(newMessage.toJson());

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(receiverId + currentUserId)
        .collection('messages')
        .add(newMessage.toJson());
  }
}
