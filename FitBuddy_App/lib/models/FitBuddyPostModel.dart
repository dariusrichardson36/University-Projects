import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/models/user.dart';

import 'FitBuddyActivityModel.dart';

class Post {
  final List<Activity> workout;
  final String description;
  final Timestamp timestamp;
  final String postId;
  final String creatorUid;
  late User user;

  Post({
    required this.workout,
    required this.description,
    required this.timestamp,
    required this.postId,
    required this.creatorUid,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    var activitiesJson = map['activities'];
    List<Activity> activitiesList =
        activitiesJson.map<Activity>((i) => Activity.fromMap(i)).toList();
    return Post(
      workout: activitiesList,
      creatorUid: map['creator_uid'],
      description: map['description'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      postId: id,
    );
  }
}
