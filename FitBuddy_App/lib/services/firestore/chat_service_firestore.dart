import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth.dart';
import 'firestore_service.dart';

class ChatServiceFirestore {
  final FirestoreService firestoreService;

  ChatServiceFirestore({required this.firestoreService});

  Stream<List<Chat>> getChatStream(String chatID) {
    return firestoreService.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Chat.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  void sendMessage(String chatroomUid, String message) {
    firestoreService.instance
        .collection('chats')
        .doc(chatroomUid)
        .collection('messages')
        .add({
      'message': message,
      'sender': Auth().currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class Chat {
  String message;
  String senderId;

  Chat({required this.message, required this.senderId});

  factory Chat.fromMap(Map<String, dynamic> data, String id) {
    return Chat(
      message: data['message'],
      senderId: data['sender'],
    );
  }
}
