import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/services/auth.dart';

import '../../models/FitBuddyPostModel.dart';
import '../../models/user.dart';
import 'firestore_service.dart';

class TimelineServiceFirestore {
  final FirestoreService firestoreService;
  final bool profileTimeline;

  DocumentSnapshot? _lastDocument;
  final StreamController<List<Post>> postsController =
      StreamController<List<Post>>.broadcast();

  List<List<Post>> _allPagedResults = [];

  TimelineServiceFirestore({
    required this.firestoreService,
    required this.profileTimeline,
  });

  Future<List> getFriendList() async {
    var data = await firestoreService.instance
        .collection('users')
        .doc(Auth().currentUser?.uid)
        .get();
    return User.fromDataSnapshot(data.data()!).friendList;
  }

  onDispose() {
    _allPagedResults = []; // clear list of posts
    _lastDocument = null;
  }

  void initTimeLine() async {
    getMoreTimeLinePosts();
  }

  Future<void> refreshTimeline() async {
    _allPagedResults = [];
    _lastDocument = null;
    await getMoreTimeLinePosts();
    return;
  }

  Future getMoreTimeLinePosts() async {
    List friendList = await getFriendList();

    // ["iRBSpsuph3QO0ZvRrlp5m1jfX9q1","VMmofqrvRVck3whXU1RugWT2lAt2"];
    Query<Map<String, dynamic>> query;
    if (profileTimeline) {
      query = firestoreService.instance
          .collection("posts")
          .where("creator_uid", isEqualTo: Auth().currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .limit(10);
    } else {
      query = firestoreService.instance
          .collection("posts")
          .where("creator_uid", whereIn: friendList)
          .where("visibility", isEqualTo: "Public")
          .orderBy('timestamp', descending: true)
          .limit(10);
    }

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    var postSnapshot = await query.get();
    var posts = postSnapshot.docs
        .map((snapshot) => Post.fromMap(snapshot.data(), snapshot.id))
        .toList();

    // Create a list of Futures to fetch user data for each post
    List<Future<void>> fetchUserFutures = posts.map((post) async {
      var user = await fetchUserData(post.creatorUid);
      if (user != null) {
        post.user = user;
      }
    }).toList();

    // Wait for all user data fetch operations to complete
    await Future.wait(fetchUserFutures);

    if (posts.isNotEmpty) {
      _allPagedResults.add(posts);
      _lastDocument = postSnapshot.docs.last;
    }

    // combine multiple lists into one with fold
    var allPosts =
        _allPagedResults.fold<List<Post>>([], (initialValue, pageItems) {
      return initialValue..addAll(pageItems);
    });
    postsController.add(allPosts);
  }

  Future<User?> fetchUserData(String creatorID) async {
    var userDoc = await firestoreService.instance
        .collection('users')
        .doc(creatorID)
        .get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      return User.fromDataSnapshot(userData);
    }
    return null;
  }

  Future<User> getUserData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().currentUser?.uid)
        .get();

    if (docSnapshot.exists) {
      return User.fromDataSnapshot(docSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }

  Future<Post> getSinglePost(String postId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();

    if (docSnapshot.exists) {
      return Post.fromMap(docSnapshot.data()!,
          postId); // Assuming you have a named constructor `fromMap` in your `Post` class
    } else {
      throw Exception('Post not found');
    }
  }
}
