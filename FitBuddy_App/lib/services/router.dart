import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_buddy/constants/route_constants.dart';
import 'package:fit_buddy/pages/auth_page.dart';
import 'package:fit_buddy/pages/complete_account_page.dart';
import 'package:fit_buddy/pages/create_workout_page.dart';
import 'package:fit_buddy/pages/home_page.dart';
import 'package:fit_buddy/pages/profile_page.dart';
import 'package:fit_buddy/pages/settings_views/account_settings_view.dart';
import 'package:fit_buddy/pages/settings_views/settings_page.dart';
import 'package:fit_buddy/pages/single_post_page.dart';
import 'package:fit_buddy/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/search_page.dart';
import 'firestore/firestore_service.dart';
import 'notifier.dart';

class FitBuddyRouter {
  //final notifier = ref.read(Auth().authStateChanges);
  GoRouter router = GoRouter(
      routes: [
        GoRoute(
            name: FitBuddyRouterConstants.homePage,
            path: '/',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: HomePage(),
              );
            }),
        GoRoute(
            name: FitBuddyRouterConstants.authPage,
            path: '/authentication',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: AuthPage(),
              );
            }),
        GoRoute(
            name: FitBuddyRouterConstants.loadingPage,
            path: '/loading',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: CircularProgressIndicator(),
              );
            }),
        GoRoute(
            name: FitBuddyRouterConstants.completeAccountPage,
            path: '/completeAccountInfo',
            pageBuilder: (context, state) {
              return const MaterialPage(child: CompleteAccountInformation());
            }),
        GoRoute(
            path: '/profile',
            name: FitBuddyRouterConstants.profilePage,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProfilePage());
            }),
        GoRoute(
            path: '/search',
            name: FitBuddyRouterConstants.searchPage,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: SearchPage(),
              );
            }),
        GoRoute(
            path: '/post/:postId',
            name: FitBuddyRouterConstants.singlePostPage,
            pageBuilder: (context, state) {
              return MaterialPage(
                child: SinglePostPage(postId: state.pathParameters['postId']!),
              );
            }),
        GoRoute(
            path: '/create',
            name: FitBuddyRouterConstants.createWorkoutPage,
            pageBuilder: (context, state) {
              return MaterialPage(
                child: CreateWorkoutPage(),
              );
            }),
        GoRoute(
            path: '/settings',
            name: FitBuddyRouterConstants.settingsPage,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: SettingsPage(),
              );
            }),
        GoRoute(
            path: '/accountsettings',
            name: FitBuddyRouterConstants.accountsettingsPage,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: AccountSettings(),
              );
            }),
      ],
      refreshListenable: GoRouterRefreshStream(Auth().authStateChanges),
      redirect: (context, GoRouterState state) async {
        User? user = Auth().currentUser;
        if (user == null) {
          return state.namedLocation(FitBuddyRouterConstants.authPage);
        }
        if (state.matchedLocation == '/authentication') {
          bool doesUserDataExist = await FirestoreService.firestoreService()
              .userService
              .doesUserDocumentExist(user.uid);
          if (!doesUserDataExist) {
            return state
                .namedLocation(FitBuddyRouterConstants.completeAccountPage);
          } else {
            FirestoreService.firestoreService().userService.init();
            return state.namedLocation(FitBuddyRouterConstants.homePage);
          }
        }
        if (state.matchedLocation == '/completeAccountInfo') {}

        if (state.matchedLocation != '/' &&
            state.matchedLocation != '/authentication' &&
            state.matchedLocation != '/completeAccountInfo') {
          return null;
        } else {
          FirestoreService.firestoreService().userService.init();
          return null;
        }
      });
}
