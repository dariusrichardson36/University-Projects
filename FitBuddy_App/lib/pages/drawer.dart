import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/constants/route_constants.dart';
import 'package:fit_buddy/models/user.dart';
import 'package:fit_buddy/services/firestore/auth_service_firestore.dart';
import 'package:fit_buddy/services/firestore/firestore_service.dart';
import 'package:fit_buddy/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserServiceFirestore userService =
        FirestoreService.firestoreService().userService;
    User user = userService.user;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: 75.0,
                height: 75.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        NetworkImage(user.image), // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "${user.name}@${user.username}",
                      style: TextStyle(
                          color: FitBuddyColorConstants.lOnPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 35),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "${user.friendList.length - 1} friends",
                      style: TextStyle(
                        color: FitBuddyColorConstants.lOnSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              context.goNamed(FitBuddyRouterConstants.profilePage);
            },
            child: Row(
              children: [
                Icon(Icons.person,
                    color: FitBuddyColorConstants.lOnPrimary, size: 35),
                const SizedBox(width: 30),
                Text(
                  'Profile',
                  style: TextStyle(
                      color: FitBuddyColorConstants.lOnPrimary, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              context.goNamed(FitBuddyRouterConstants.accountsettingsPage);
            },
            child: Row(
              children: [
                Icon(Icons.settings,
                    color: FitBuddyColorConstants.lOnPrimary, size: 35),
                const SizedBox(width: 30),
                Text(
                  'Settings',
                  style: TextStyle(
                      color: FitBuddyColorConstants.lOnPrimary, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              context.goNamed(FitBuddyRouterConstants.createWorkoutPage);
            },
            child: Row(
              children: [
                Icon(Icons.edit,
                    color: FitBuddyColorConstants.lOnPrimary, size: 35),
                const SizedBox(width: 30),
                Text(
                  'Log Workout',
                  style: TextStyle(
                      color: FitBuddyColorConstants.lOnPrimary, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              context.goNamed(FitBuddyRouterConstants.searchPage);
            },
            child: Row(
              children: [
                Icon(Icons.search,
                    color: FitBuddyColorConstants.lOnPrimary, size: 35),
                const SizedBox(width: 30),
                Text(
                  'Search',
                  style: TextStyle(
                      color: FitBuddyColorConstants.lOnPrimary, fontSize: 18),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Auth().signOutUser(),
                  icon: const Icon(Icons.logout_rounded)),
              IconButton(
                  onPressed: () => ThemeManager().toggleTheme(),
                  icon: const Icon(Icons.sunny))
            ],
          ),
        ]),
      ),
    );
  }
}
