import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/model/Item.dart';
import 'package:selfintro/screens/items/itemBox.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchEditingController = TextEditingController();

  Future<List<DocumentSnapshot>> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('title', isEqualTo: searchEditingController.text)
        .get();
    return querySnapshot.docs;
  }

  Future<List<Item>> fetch() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('title', isEqualTo: searchEditingController.text)
        .get();

    List<Item> items = querySnapshot.docs.map((doc) {
      return Item.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: '검색',
              contentPadding: const EdgeInsets.only(left: 20, top: 30),
              filled: true,
              fillColor: Colors.grey[200],
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20))),
          controller: searchEditingController,
          onChanged: (value) {
            setState(() {});
          },
          // onSubmitted: (value) {
          //   setState(() {});
          // }, 마무리 후 enter누르면 반영 데이터 관리 ? 그런거에 이득일듯
        ),
      ),
      body: FutureBuilder<List<Item>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Item item = snapshot.data![index];
                  return ItemBox(item: item);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
