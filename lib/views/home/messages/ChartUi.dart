// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../tools/index.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  const ChatScreen({Key? key, required this.receiverId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _messageController = TextEditingController();

  String _currentUserId = "";
  //  Stream<QuerySnapshot>? _chatStream;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
  }

  void _sendMessage(String message) {
    _firestore.collection('chats').add({
      'senderId': _currentUserId,
      'receiverId': widget.receiverId,
      'message': message,
      'timestamp': DateTime.now(),
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("chats").orderBy("timestamp",descending: true).snapshots(),
              builder: (context, snapshot) {
                final chatDocs = snapshot.data?.docs ?? [];
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: chatDocs.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final chat = chatDocs[index].data();
                          final message = chat['message'] ?? "";
                          final isSentByCurrentUser =
                              chat['senderId'] == _currentUserId;
                          return isSentByCurrentUser? Row(
                            children: [
                             
                                   const Spacer(),
                                   Card(
                                    color: Colors.blue[300],

                                      margin: const EdgeInsets.all(
                                        10,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                              text: message,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold), children: [
                                                TextSpan(text: "\n\n${getElapsedTime(chat['timestamp'])}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
                                              ]),
                                        ),
                                      ),
                                    ),
                            ],
                          ):Row(
                            children: [
                             
                                   Card(
                                    color: Colors.grey[300],
                                      margin: const EdgeInsets.all(
                                        10,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                              text: message,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold), children: [
                                                TextSpan(text: "\n\n${getElapsedTime(chat['timestamp'])}"),
                                              ]),
                                        ),
                                      ),
                                    ),
                                   const Spacer(),
                            ],
                          );

                          // ListTile(
                          //   tileColor: isSentByCurrentUser
                          //       ? Theme.of(context).primaryColor
                          //       : Colors.grey[300],
                          //   title: Text(
                          //     message,
                          //     style: TextStyle(
                          //       fontWeight: isSentByCurrentUser
                          //           ? FontWeight.bold
                          //           : FontWeight.normal,
                          //     ),
                          //   ),
                          //   subtitle: Text(
                          //     getElapsedTime(chat['timestamp']),
                          //   ),
                          //   trailing: isSentByCurrentUser
                          //       ? const Icon(Icons.check)
                          //       : null,
                          // );
                        },
                      )
                    : const Center(child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
