import 'package:fit_buddy/models/contact_model.dart';
import 'package:fit_buddy/services/firestore/chat_service_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/firestore/firestore_service.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _firestore = FirestoreService.firestoreService();
  String? userUid = Auth().currentUser?.uid;
  final _messageController = TextEditingController();
  Future<List<Contact>>? contacts;
  String chatroomUid = '';
  String chatroomName = "";

  @override
  void initState() {
    super.initState();
    contacts = _firestore.userService.getContactList();
  }

  sendMessage(String message) {
    _firestore.chatService.sendMessage(chatroomUid, message);
  }

  @override
  Widget build(BuildContext context) {
    if (chatroomUid.isNotEmpty) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  chatroomUid = '';
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text(chatroomName),
            const SizedBox(
              width: 50,
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<List<Chat>>(
              stream: _firestore.chatService.getChatStream(chatroomUid),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Chat? chat = snapshot.data?[index];
                      bool sender = (chat?.senderId == userUid);
                      return Row(
                        mainAxisAlignment: (sender)
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: (sender) ? Colors.lightGreen : Colors.blue,
                            ),
                            child: Text(snapshot.data?[index].message ?? ''),
                          )
                        ],
                      );
                    });
              }),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                sendMessage(_messageController.text);
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ]);
    } else {
      return FutureBuilder(
          future: contacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var contact = snapshot.data![index];
                        return ListTile(
                          onTap: () {
                            setState(() {
                              chatroomUid = contact.chatUid;
                              chatroomName = contact.name;
                            });
                          },
                          title: Text(snapshot.data?[index].name ?? ''),
                          leading: CircleAvatar(
                            backgroundImage: (contact.image.isNotEmpty)
                                ? NetworkImage(contact.image)
                                : const AssetImage(
                                        'lib/images/default_profile.png')
                                    as ImageProvider,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    }
  }
}
