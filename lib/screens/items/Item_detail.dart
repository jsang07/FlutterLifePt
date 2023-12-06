import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfintro/screens/chat/chatroom.dart';
import 'package:selfintro/model/Item.dart';

class ItemsDetail extends StatefulWidget {
  final Item item;
  const ItemsDetail({super.key, required this.item});

  @override
  State<ItemsDetail> createState() => _ItemsDetailState();
}

class _ItemsDetailState extends State<ItemsDetail> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  late Map<String, dynamic> data;

  getUser() async {
    var document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    data = document.data() as Map<String, dynamic>;
    return data;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget imageSlider() {
    return CarouselSlider(
      carouselController: _controller,
      items: widget.item.images.map(
        (imgLink) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    imgLink,
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
        height: 250,
        viewportFraction: 1.0,
        autoPlay: false,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.item.images.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8,
              height: 8,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == entry.key ? Colors.white : Colors.white70,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text('${widget.item.userName}'),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      imageSlider(),
                      sliderIndicator(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${widget.item.title}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 3,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.item.content.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        FirebaseAuth.instance.currentUser?.email == widget.item.userMail
            ? Container()
            : Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({
                      'chats': FieldValue.arrayUnion(
                          ['${widget.item.userName}-${widget.item.userUid}'])
                    });
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.item.userUid)
                        .update({
                      'chats': FieldValue.arrayUnion([
                        '${data['name']}-${FirebaseAuth.instance.currentUser?.uid}'
                      ])
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(
                                receiverUserName:
                                    widget.item.userName.toString(),
                                receiverUserId:
                                    widget.item.userUid.toString())));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(13)),
                      margin: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                      padding: const EdgeInsets.all(15),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '채팅하기',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )),
                ),
              ),
      ]),
    );
  }
}
