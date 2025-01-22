import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/user.dart';

String? currentUserID = Auth().currentUser?.uid;

// Constructs list of user information from user class
Future<List<User>> getProfilesFromFirestore(String currentUserID) async {
  final collection = FirebaseFirestore.instance.collection('users');
  final snapshot =
      await collection.where('uid', isNotEqualTo: currentUserID).get();
  return snapshot.docs.map((doc) => User.fromDataSnapshot(doc.data())).toList();
}

class MatchmakingView extends StatelessWidget {
  const MatchmakingView({Key? key}) : super(key: key);

  // Here is my like function
  Future<void> likeProfile(String likerID, String likedID) async {
    try {
      final likerRef =
          FirebaseFirestore.instance.collection('users').doc(likerID);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(likerRef);

        if (userSnapshot.exists) {
          final userData = userSnapshot.data();
          final likes = List<String>.from(userData?['Likes'] ?? []);

          if (!likes.contains(likedID)) {
            likes.add(likedID);
            transaction.update(likerRef, {'Likes': likes});
          } else {}
        }
      });
    } catch (error) {
      print('Error adding like: $error');
    }
  }

  Future<void> matchUser(String likerID, String likedID) async {
    try {
      var likerRef =
          FirebaseFirestore.instance.collection('users').doc(likerID);
      var likedRef =
          FirebaseFirestore.instance.collection('users').doc(likedID);

      await FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        var likerSnapshot = await transaction.get(likerRef);
        var likedSnapshot = await transaction.get(likedRef);

        if (likerSnapshot.exists && likedSnapshot.exists) {
          var likerData = likerSnapshot.data();
          var likedData = likedSnapshot.data();

          var likerLikes = List<String>.from(likerData?['Likes'] ?? []);
          var likedLikes = List<String>.from(likedData?['Likes'] ?? []);

          var mutualLike =
              likerLikes.contains(likedID) && likedLikes.contains(likerID);

          if (mutualLike) {
            var likerMatches = List<String>.from(likerData?['Matches'] ?? []);
            likerMatches.add(likedID);

            var likedMatches = List<String>.from(likedData?['Matches'] ?? []);
            likedMatches.add(likerID);

            transaction.update(likerRef, {'Matches': likerMatches});
            transaction.update(likedRef, {'Matches': likedMatches});

            print('Match found and updated in Firestore!');
          } else {
            print('No mutual like yet.');
          }
        } else {
          print('One or both users not found.');
        }
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  static const String placeholderImageUrl =
      'https://www.seekpng.com/png/detail/847-8474751_download-empty-profile.png';

  @override
  Widget build(BuildContext context) {
    AppinioSwiperController _controller = AppinioSwiperController();

    return FutureBuilder<List<User>>(
      future: getProfilesFromFirestore(currentUserID!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No users found.');
        }

        final users = snapshot.data;
        //final age = dob != null ? calculateAgeFromDOB(dob) : 0;

        final group1Users =
            users?.where((user) => isUserInGroup(user, 'A', 'Z')).toList();

        // Here is my swiper
        return AppinioSwiper(
          controller: _controller,
          cardsCount: group1Users?.length ?? 0,
          // Tracks direction that the card is swiped in
          onSwipe: (int index, AppinioSwiperDirection direction) {
            if (direction == AppinioSwiperDirection.right) {
              // User swiped right, call like and match functions
              String? likedUserID = group1Users?[index].uid;
              likeProfile(currentUserID!, likedUserID!);
              matchUser(currentUserID!, likedUserID);
            }
          },

          cardsBuilder: (BuildContext context, int index) {
            final User? user = group1Users?[index];
            final imageUrl = user?.image ?? placeholderImageUrl;

            return Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.blueGrey[100],
              child: Column(
                children: [
                  // Profile picture aligned with the top of the card and taking half of the height
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height *
                        0.40, // Set 40% of the screen height
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth, // Take up 90% of the screen width
                      width: MediaQuery.of(context)
                          .size
                          .width, // Set 90% of the screen width
                    ),
                  ),

                  // Text widget with size 24 font aligned to the left
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    // Add padding to both sides of the row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Distribute children to both ends of the row
                      children: [
                        Text(
                          user?.name ?? 'No Name',
                          style: GoogleFonts.roboto(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dateToAge(user!.dob) ?? 'No Age',
                          style: GoogleFonts.roboto(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40,
                          child: Image.asset('lib/images/emptyBadge.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40,
                          child: Image.asset('lib/images/emptyBadge.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40,
                          child: Image.asset('lib/images/emptyBadge.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40,
                          child: Image.asset('lib/images/emptyBadge.png'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  // Inside cardsBuilder in your AppinioSwiper widget
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.0),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 21,
                          color: Colors
                              .black, // Set the color for the regular text
                        ),
                        children: [
                          TextSpan(
                            text: 'Lifting Experience:',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight
                                  .bold, // Set the part before the colon as bold
                            ),
                          ),
                          TextSpan(
                            text: ' ${user?.gymExperience ?? 'No Experience'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.0),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 21,
                          color: Colors
                              .black, // Set the color for the regular text
                        ),
                        children: [
                          TextSpan(
                            text: 'Gym Goals:',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight
                                  .bold, // Set the part before the colon as bold
                            ),
                          ),
                          TextSpan(
                            text: ' ${user?.gymGoals ?? 'No Gym Goals'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.0),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 21,
                          color: Colors
                              .black, // Set the color for the regular text
                        ),
                        children: [
                          TextSpan(
                            text: 'Lifting Style:',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight
                                  .bold, // Set the part before the colon as bold
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${user?.liftingStyle ?? 'No Lifting Style'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Here is my code for my buttons, and the logic as far as liking and disliking goes
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controller.swipeLeft();
                              // Perform the action for the first button
                            },
                            child: const Icon(
                              Icons.close,
                              size: 48,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          GestureDetector(
                            onTap: () {
                              _controller.swipeRight();
                              String? likedUserID = group1Users?[index]
                                  .uid; // Get the liked user ID
                              likeProfile(currentUserID!,
                                  likedUserID!); // Call your like function
                              matchUser(currentUserID!, likedUserID);
                            },
                            child: const Icon(
                              Icons.favorite,
                              size: 58,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          GestureDetector(
                            onTap: () {
                              _controller.swipeUp();
                              // Perform the action for the third button
                            },
                            child: const Icon(
                              Icons.star,
                              size: 48,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String dateToAge(Timestamp time) {
    final date = time.toDate();
    final age = DateTime.now().year - date.year;
    return age.toString();
  }

  bool isUserInGroup(User? user, String startLetter, String endLetter) {
    final displayName = user?.name;
    if (displayName != null && displayName.isNotEmpty) {
      final firstLetter = displayName[0].toUpperCase();
      return firstLetter.compareTo(startLetter) >= 0 &&
          firstLetter.compareTo(endLetter) <= 0;
    }
    return false;
  }
}
