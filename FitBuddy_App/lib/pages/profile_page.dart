import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/models/user.dart';
import 'package:fit_buddy/pages/profile_feed_view.dart';
import 'package:fit_buddy/services/auth.dart';
import 'package:fit_buddy/services/firestore/auth_service_firestore.dart';
import 'package:fit_buddy/services/firestore/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/route_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    super.dispose();
    FirestoreService.firestoreService().profileTimelineService.onDispose();
  }

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    UserServiceFirestore userService =
        FirestoreService.firestoreService().userService;
    User user = userService.user;

    final screenWidth = MediaQuery.of(context).size.width - 40;
    const dotSpacing = 8.0; // The space you want to keep between each dot
    final totalSpacing =
        dotSpacing * (user.images.length - 1); // Total spacing between dots
    final dotWidth = (screenWidth - totalSpacing) / user.images.length;

    Future<void> pickImage() async {
      String _uid = Auth().currentUser!.uid;
      final picker = ImagePicker();
      // Pick an image.
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      // Upload to Firebase Storage.
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final picRef = storageRef.child(
            "profileImages/$_uid/${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}");

        try {
          //Store the file
          await picRef.putFile(File(image!.path));
          var imageUrl = await picRef.getDownloadURL();
          //Update the user's profile image
          userService.addImage(imageUrl);
          setState(() {});
        } catch (error) {
          //Some error occurred
        }
      } else {
        // Handle the case where the user didn't pick an image.
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _controller,
                itemCount: user.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      // Get the width of the widget
                      var width = MediaQuery.of(context).size.width;
                      // Check where the user tapped
                      if (details.globalPosition.dx < width / 2) {
                        // If the user tapped on the left side, go to the previous image
                        if (_controller.page != 0) {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        }
                      } else {
                        // If the user tapped on the right side, go to the next image
                        if (_controller.page != user.images.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.decelerate,
                          );
                        }
                      }
                    },
                    child: Image.network(user.images[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 40, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmoothPageIndicator(
                      controller: _controller, // PageController
                      count: user.images.length,
                      effect: WormEffect(
                          activeDotColor: FitBuddyColorConstants.lAccent,
                          dotColor: FitBuddyColorConstants.lPrimary,
                          dotHeight: 5,
                          dotWidth:
                              dotWidth, // Width for each dot calculated to fill the screen width
                          spacing: dotSpacing // Spacing between dots
                          ), // your preferred effect
                      onDotClicked: (index) {}),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.arrow_back_ios_rounded, size: 30, color: FitBuddyColorConstants.lPrimary),
                        onPressed: () {
                          context.goNamed(FitBuddyRouterConstants.homePage);
                        },
                      ),
                      //    const SizedBox(width: 30),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "@${user.username}",
                          style: TextStyle(
                              color: FitBuddyColorConstants.lPrimary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 210),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                            color: FitBuddyColorConstants.lPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: pickImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: FitBuddyColorConstants.lPrimary,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20),
          const Expanded(child: ProfileFeedView())
        ],
      ),
    );
  }
}
