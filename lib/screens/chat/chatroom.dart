import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfintro/provider/chat_provider.dart';
import 'package:selfintro/services/chat_service.dart';

class ChatRoom extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserId;
  const ChatRoom(
      {super.key,
      required this.receiverUserId,
      required this.receiverUserName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController messageTextController = TextEditingController();
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false)
        .getMessage(widget.receiverUserId, currentUser!.uid);
  }

  Future<void> sendMessage() async {
    if (messageTextController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.receiverUserId, messageTextController.text);
      messageTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.messages.length,
                    itemBuilder: (context, index) {
                      final message = value.messages[index];
                      return Column(
                        crossAxisAlignment: message.senderId == currentUser?.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: message.senderId == currentUser?.uid
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(12),
                                      topLeft: const Radius.circular(12),
                                      bottomLeft:
                                          message.senderId == currentUser?.uid
                                              ? const Radius.circular(12)
                                              : const Radius.circular(0),
                                      bottomRight:
                                          message.senderId == currentUser?.uid
                                              ? const Radius.circular(0)
                                              : const Radius.circular(12)),
                                  color: message.senderId == currentUser?.uid
                                      ? Colors.blue
                                      : Colors.grey[200]),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: message.senderId == currentUser?.uid
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            message.sentTime.toString().substring(0, 16),
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              child: TextField(
                cursorColor: Colors.grey[900],
                controller: messageTextController,
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    suffixIcon: IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.black,
                        )),
                    contentPadding: const EdgeInsets.only(left: 20, top: 30),
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
          ],
        ),
      ),
    );
  }
}
