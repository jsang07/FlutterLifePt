import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String? title;
  final String? content;
  final String? userMail;
  final String? userUid;
  final String? userName;
  final List images;
  final Timestamp timestamp;

  Item(
      {required this.id,
      required this.title,
      required this.content,
      required this.userMail,
      required this.userUid,
      required this.userName,
      required this.images,
      required this.timestamp});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userMail: json['userMail'],
      userUid: json['userUid'],
      userName: json['userName'],
      images: json['images'],
      timestamp: json['timestamp']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'userMail': userMail,
        'userUid': userUid,
        'userName': userName,
        'images': images,
        'timestamp': timestamp
      };

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        userMail: map['userMail'],
        userUid: map['userUid'],
        userName: map['userName'],
        images: map['images'],
        timestamp: map['timestamp']);
  }

  // factory Item.fromDocument(DocumentSnapshot doc) {
  //   return Item(
  //       id: doc.id,
  //       title: doc['title'],
  //       content: doc['content'],
  //       userMail: doc['userMail'],
  //       userUid: doc['userUid'],
  //       images: doc['images'],
  //       timestamp: doc['timestamp']);
  // }
}
