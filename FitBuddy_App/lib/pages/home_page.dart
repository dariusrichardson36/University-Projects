import 'package:fit_buddy/pages/homepage_views/achievements_view.dart';
import 'package:fit_buddy/pages/homepage_views/matchmaking_view.dart';
import 'package:fit_buddy/pages/homepage_views/messages_view.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'homepage_views/timeline_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final user = FirebaseAuth.instance.currentUser!;
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  void _onViewChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        // Only animate if the selected tab is different from the current page
        _currentPageIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: DrawerPage(),
      ),
      body: SafeArea(
        child: PageView(
            physics: _currentPageIndex == 1
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          
          controller: _pageController,
          children: const [
            TimeLineView(),
            MatchmakingView(),
            AchievementsView(),
            MessagesView(),
          ],

        ),
      ),
      bottomNavigationBar: fitBuddyBottomNavigationBar(),
    );
  }

  fitBuddyBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPageIndex,
      onTap: (index) => _onViewChange(index),
      //selectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department_rounded),
          label: 'Matching',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email),
          label: 'messages',
        ),
        /*
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: 'messages',
        ),

         */
      ],
      showSelectedLabels: false, // Hide labels for selected item
      showUnselectedLabels: false, // Hide labels for unselected items
    );
  }

}