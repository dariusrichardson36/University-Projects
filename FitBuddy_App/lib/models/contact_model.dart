import 'package:fit_buddy/services/auth.dart';

class Contact {
  String name;
  String image;
  String uid;
  String chatUid;

  Contact(
      {required this.name,
      required this.image,
      required this.uid,
      required this.chatUid});

  factory Contact.fromJson(Map<String, dynamic> json) {
    List<String> chatUid = [];
    chatUid.add(json['uid']);
    chatUid.add(Auth().currentUser!.uid);
    chatUid.sort();
    String joined = chatUid.join("_");
    return Contact(
        name: json['displayName'],
        image: json['image_url'],
        uid: json['uid'],
        chatUid: joined);
  }
}
