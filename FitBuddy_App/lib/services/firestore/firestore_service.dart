import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/services/firestore/chat_service_firestore.dart';
import 'package:fit_buddy/services/firestore/post_service_firestore.dart';
import 'package:fit_buddy/services/firestore/timeline_service_firestore.dart';

import 'auth_service_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firebaseFirestoreInstance;

  late final UserServiceFirestore userService;
  late final TimelineServiceFirestore timelineService;
  late final PostServiceFirestore postService;
  late final TimelineServiceFirestore profileTimelineService;
  late final ChatServiceFirestore chatService;

  // 1. Static instance of the class
  static final FirestoreService _instance = FirestoreService._internal();

  // 2. Factory constructor returning the static instance
  factory FirestoreService.firestoreService() {
    return _instance;
  }

  // 3. Internal named constructor
  FirestoreService._internal() {
    userService = UserServiceFirestore(firestoreService: this);
    userService.init();
    timelineService = TimelineServiceFirestore(
        firestoreService: this, profileTimeline: false);
    postService = PostServiceFirestore(firestoreService: this);
    profileTimelineService =
        TimelineServiceFirestore(firestoreService: this, profileTimeline: true);
    chatService = ChatServiceFirestore(firestoreService: this);
  }
}
