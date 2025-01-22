import 'dart:async';

import 'package:fit_buddy/components/FitBuddyTimeLinePost.dart';
import 'package:fit_buddy/models/FitBuddyPostModel.dart';
import 'package:fit_buddy/services/firestore/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_constants.dart';

class TimeLineView extends StatefulWidget {
  const TimeLineView({super.key});

  @override
  _TimeLineViewState createState() => _TimeLineViewState();
}

class _TimeLineViewState extends State<TimeLineView> {
  late Stream<List<Post>> _timelinePostsStream;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final _firestore = FirestoreService.firestoreService();

  @override
  void initState() {
    super.initState();
    loadTimeline();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firestore.timelineService.onDispose();
    _scrollController.dispose();
  }

  Future<void> loadMorePosts() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _firestore.timelineService.getMoreTimeLinePosts();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void loadTimeline() {
    setState(() {
      _firestore.timelineService.initTimeLine();
      _timelinePostsStream = _firestore.timelineService.postsController.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserServiceFirestore userService =
    //     _firestore.userService;
    // User user = userService.user;
    return StreamBuilder<List<Post>>(
      stream: _timelinePostsStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          //image: NetworkImage("https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"), // Replace with your image URL
                          image: NetworkImage(
                            _firestore.userService.user.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Image.asset("lib/images/logo.png", width: 35, height: 35),
                  IconButton(
                      onPressed: () {
                        context.goNamed(FitBuddyRouterConstants.searchPage);
                      },
                      icon: const Icon(Icons.search)),
                ],
              ),
            ),
            if (snapshot.connectionState == ConnectionState.waiting) ...{
              const Center(child: CircularProgressIndicator()),
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) ...{
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _firestore.timelineService.refreshTimeline,
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
