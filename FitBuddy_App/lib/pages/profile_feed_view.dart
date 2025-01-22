import 'dart:async';

import 'package:fit_buddy/components/FitBuddyTimeLinePost.dart';
import 'package:fit_buddy/models/FitBuddyPostModel.dart';
import 'package:fit_buddy/services/auth.dart';
import 'package:flutter/material.dart';

import '../../services/firestore/firestore_service.dart';

class ProfileFeedView extends StatefulWidget {
  const ProfileFeedView({super.key});

  @override
  _ProfileFeedState createState() => _ProfileFeedState();
}

class _ProfileFeedState extends State<ProfileFeedView> {
  late Stream<List<Post>> _ProfilePostsStream;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final _firestore = FirestoreService.firestoreService();
  String? uid = Auth().currentUser?.uid;

  @override
  void initState() {
    super.initState();
    loadProfileFeed();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMorePosts();
      }
    });
  }

  Future<void> loadMorePosts() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _firestore.profileTimelineService.getMoreTimeLinePosts();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void loadProfileFeed() {
    setState(() {
      _firestore.profileTimelineService.initTimeLine();
      _ProfilePostsStream =
          _firestore.profileTimelineService.postsController.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: _ProfilePostsStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (snapshot.connectionState == ConnectionState.waiting) ...{
              const Center(child: CircularProgressIndicator()),
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) ...{
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _firestore.profileTimelineService.refreshTimeline,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length && _isLoading) {
                        return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                                child:
                                    CircularProgressIndicator())); // Loading indicator at the end
                      }
                      final posts = snapshot.data!;
                      return FitBuddyTimelinePost(postData: posts[index]);
                    },
                  ),
                ),
              ),
            } else ...{
              const Center(child: Text('No posts available.')),
            },
          ],
        );
      },
    );
  }
}
