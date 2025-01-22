import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/constants/route_constants.dart';
import 'package:fit_buddy/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/firestore/firestore_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _firestore = FirestoreService.firestoreService();
  late TextEditingController _controller;
  String searchQuery = '';
  List<String> _searchResults = []; // This list will hold the search results
  List<String> _friendList = []; // This list will hold the friends list
  String userID = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _friendList = _firestore.userService.user.friendList;
    userID = Auth().currentUser!.uid;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final results = await FirestoreService.firestoreService()
        .userService
        .searchUser(_controller.text);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitBuddyColorConstants.lPrimary,
        leading: IconButton(
          //onPressed: () => Navigator.of(context).pop(),
          onPressed: () => context.goNamed(FitBuddyRouterConstants.homePage),
          icon:
              Icon(Icons.arrow_back, color: FitBuddyColorConstants.lOnPrimary),
        ),
        title: TextField(
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search),
            hintText: 'Search...',
            border: InputBorder.none,
            focusColor: FitBuddyColorConstants.lOnPrimary,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() {
              searchQuery = val;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshots) {
          if ((snapshots.connectionState == ConnectionState.waiting)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (searchQuery.isEmpty) {
                    return null;
                  }
                  if (data['username']
                      .toString()
                      .toLowerCase()
                      .startsWith(searchQuery.toLowerCase())) {
                    return ListTile(
                      title: Text(
                        data['displayName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '@${data['username']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: (data['image_url'] != null &&
                                data['image_url'].isNotEmpty)
                            ? NetworkImage(data['image_url'])
                            : const AssetImage('lib/images/default_profile.png')
                                as ImageProvider,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (!_friendList.contains(data['uid'])) {
                            _firestore.userService.addToFriendList(data['uid']);
                            setState(() {
                              _friendList.add(data['uid']);
                            });
                          } else {
                            _firestore.userService
                                .removeFromFriendList(data['uid']);
                            setState(() {
                              _friendList.remove(data['uid']);
                            });
                          }
                        },
                        child: (!_friendList.contains(data['uid']))
                            ? const Text('Add')
                            : const Text('Remove'),
                      ),
                      onTap: () {
                        //Navigator.of(context).pushNamed('/profile');
                        //context.goNamed(FitBuddyRouterConstants.profilePage);
                      },
                    );
                  }
                  return Container();
                });
          }
        },
      ),
    );
  }
}
