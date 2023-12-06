import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/method/media_picker.dart';
import 'package:selfintro/services/Item_service.dart';

class ItemAddPage extends StatefulWidget {
  const ItemAddPage({super.key});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  // late List<String> userList;
  late Map<String, dynamic> data;
  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();

  getUser() async {
    var document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    data = document.data() as Map<String, dynamic>;
    // userList = data.values.map((item) => item.toString()).toList();
    return data;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final List images = [];
  File? _image;
  var mediaPicker = MediaPicker();
  final List<Map<String, dynamic>> _mediaFiles = [];
  void pickImgaes() async {
    var pickFiles = await mediaPicker.pickImages();
    setState(() {
      _mediaFiles.addAll(pickFiles);
    });
  }

  removeMedia(index) {
    setState(() {
      _mediaFiles.removeAt(index - 1);
    });
  }

  Future<void> add() async {
    for (int i = 0; i < _mediaFiles.length; i++) {
      setState(() {
        _image = File(_mediaFiles[i]['mediaFile']);
      });
      final refImage = FirebaseStorage.instance
          .ref()
          .child('ProPhotos')
          .child('ProPhotos$i${Timestamp.now()}.png');
      await refImage.putFile(_image!);
      final imgUrl = await refImage.getDownloadURL();
      setState(() {
        images.add(imgUrl);
      });
    }

    if (titleEditingController.text.isNotEmpty &&
        contentEditingController.text.isNotEmpty) {
      ItemService().createItem(
          Timestamp.now().toString(),
          titleEditingController.text,
          contentEditingController.text,
          data['name'],
          images);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Pt 만들기')),
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TextField(
                      maxLines: 1,
                      controller: titleEditingController,
                      decoration: InputDecoration(
                          hintText: '제목을 입력하세요',
                          contentPadding:
                              const EdgeInsets.only(left: 20, top: 30),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      maxLines: 7,
                      controller: contentEditingController,
                      decoration: InputDecoration(
                          hintText: '내용을 입력하세요',
                          contentPadding:
                              const EdgeInsets.only(left: 20, top: 30),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _mediaFiles.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: IconButton(
                                onPressed: () {
                                  pickImgaes();
                                },
                                icon: const Icon(Icons.add_a_photo)),
                          );
                        }
                        var mediaFile = _mediaFiles[index - 1];
                        var thumbnailFile = File(mediaFile['thumbnailFile']);

                        return Stack(
                          children: [
                            Image.file(thumbnailFile,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                            Positioned(
                                right: 5,
                                top: 5,
                                child: GestureDetector(
                                  onTap: () async {
                                    removeMedia(index);
                                  },
                                  child: const Icon(Icons.close_rounded),
                                ))
                          ],
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 100))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GestureDetector(
                onTap: () {
                  add();
                },
                child: Container(
                  width: width,
                  height: height * 0.065,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                    child: Text(
                      '글 올리기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
