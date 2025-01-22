import 'package:fit_buddy/components/FitBuddyTimeLinePost.dart';
import 'package:flutter/material.dart';

import '../models/FitBuddyPostModel.dart';
import '../services/firestore/firestore_service.dart';

class SinglePostPage extends StatefulWidget {
  final String postId;

  const SinglePostPage({super.key, required this.postId});

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  Future<Post>? postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = FirestoreService.firestoreService().timelineService.getSinglePost(widget.postId);  // Assuming you have postId in your widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Single Post Page"),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              Post? post = snapshot.data;
              if (post != null) {
                return FitBuddyTimelinePost(postData: post);
              } else {
                return const Text("Post not found");
              }
            } else {
              return const CircularProgressIndicator(); // Show loading indicator while fetching
            }
          },
        ),
      ),
    );
  }
}