import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //Personal Info
  String name;
  Timestamp dob;
  String username;
  String? email;
  String? gender;
  bool? accountCompletion;
  String image;
  List<String> friendList = [];
  //Fitness Info
  String? liftingStyle;
  String? gymGoals;
  String? gymExperience;
  String? uid;
  List<String> images;

  User({
    required this.name,
    required this.dob,
    required this.gymExperience,
    this.gender,
    this.gymGoals,
    required this.accountCompletion,
    this.liftingStyle,
    required this.username,
    this.email,
    required this.image,
    required this.friendList,
    this.uid,
    required this.images,
  });

  static User fromDataSnapshot(Map<String, dynamic> map) {
    return User(
      //personal info
      name: map['displayName'],
      dob: map['dob'] ?? "0",
      username: map['username'],
      email: map['email'],
      image: map['image_url'] ??
          "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg",
      gender: map['gender'],
      accountCompletion: map['isAccountComplete'],
      friendList: List<String>.from(map["friendList"]),
      //fitness info
      liftingStyle: map['liftingStyle'],
      gymGoals: map['goals'],
      gymExperience: map['experience'],
      images: List<String>.from(map["images"]) ??
          [
            "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
          ],
    );
  }
}
