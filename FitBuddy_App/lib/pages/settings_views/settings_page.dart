import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.goNamed(FitBuddyRouterConstants.homePage),
                    icon: Icon(Icons.arrow_back,
                    color: FitBuddyColorConstants.lOnPrimary)
                  ),
                ],
              ),
              const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 25
                  )
                ),
              ),
              const SizedBox(height: 35),
              
              Row (
                children: [
                  const Icon(Icons.person, color: Colors.black, size: 30),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {context.goNamed(FitBuddyRouterConstants.accountsettingsPage);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Account',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                ]
              ),
              Divider(
                thickness: 2,
                color: FitBuddyColorConstants.lAccent
              ),

              Row (
                children: [
                  const Icon(Icons.notifications, color: Colors.black, size: 30),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Notifications',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                ]
              ),
              Divider(
                thickness: 2,
                color: FitBuddyColorConstants.lAccent
              ),

              Row (
                children: [
                  const Icon(Icons.settings, color: Colors.black, size: 30),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'General',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                ]
              ),
              Divider(
                thickness: 2,
                color: FitBuddyColorConstants.lAccent
              ),
            ],
          ),
        )
      )
    );
  }
}
