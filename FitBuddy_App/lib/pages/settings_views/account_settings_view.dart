import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/constants/route_constants.dart';
import 'package:fit_buddy/models/user.dart';
import 'package:fit_buddy/services/firestore/auth_service_firestore.dart';
import 'package:fit_buddy/services/firestore/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String currentGender = "Male";
  String currentGoals = "Lose Weight";
  String currentExperience = "0-3 Months";
  String currentStyle = "Calisthenics";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Date Picker Popup
  void _selDatePicker() async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: FitBuddyColorConstants.lAccent,
                  onPrimary: FitBuddyColorConstants.lPrimary,
                  onSurface: FitBuddyColorConstants.lOnPrimary,
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        primary: FitBuddyColorConstants.lAccent))),
            child: child!,
          );
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().currentUser?.uid)
          .update({'dob': pickedDate});
      openAlert();
    });
  }

  // Dialog popup that allows to user to change thier gender.
  void genderSelMenu(String message, var items) {
    late TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: DropdownButtonFormField<String>(
            value: currentGender,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
            ),
            items: items.map<DropdownMenuItem<String>>((String items) {
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(),
            onChanged: (String? inputedValue) {
              currentGender = inputedValue!;
            },
            onSaved: (value) {
              setState(() {
                currentGender = value!;
              });
            }),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(Auth().currentUser?.uid)
                    .set({'gender': currentGender}, SetOptions(merge: true));
                Navigator.of(context).pop(controller.text);
                openAlert();
              },
              child: Text('SUBMIT',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  // Dialog popup that allows to user to change thier gym goals.
  void goalsSelMenu(String message, var items) {
    late TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: DropdownButtonFormField<String>(
            value: currentGoals,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
            ),
            items: items.map<DropdownMenuItem<String>>((String items) {
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(),
            onChanged: (String? inputedValue) {
              currentGoals = inputedValue!;
            },
            onSaved: (value) {
              setState(() {
                currentGoals = value!;
              });
            }),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(Auth().currentUser?.uid)
                    .set({'goals': currentGoals}, SetOptions(merge: true));
                Navigator.of(context).pop(controller.text);
                openAlert();
              },
              child: Text('SUBMIT',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  // Dialog popup that allows to user to change thier gym experinece.
  void experienceSelMenu(String message, var items) {
    late TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: DropdownButtonFormField<String>(
            value: currentExperience,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
            ),
            items: items.map<DropdownMenuItem<String>>((String items) {
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(),
            onChanged: (String? inputedValue) {
              currentExperience = inputedValue!;
            },
            onSaved: (value) {
              setState(() {
                currentExperience = value!;
              });
            }),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(Auth().currentUser?.uid)
                    .set({'experience': currentExperience},
                        SetOptions(merge: true));
                Navigator.of(context).pop(controller.text);
                openAlert();
              },
              child: Text('SUBMIT',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  // Dialog popup that allows to user to change thier lifting style.
  void styleSelMenu(String message, var items) {
    late TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: DropdownButtonFormField<String>(
            value: currentStyle,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: FitBuddyColorConstants.lAccent, width: 2)),
            ),
            items: items.map<DropdownMenuItem<String>>((String items) {
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(),
            onChanged: (String? inputedValue) {
              currentStyle = inputedValue!;
            },
            onSaved: (value) {
              setState(() {
                currentStyle = value!;
              });
            }),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(Auth().currentUser?.uid)
                    .set({'liftingStyle': currentStyle},
                        SetOptions(merge: true));
                Navigator.of(context).pop(controller.text);
                openAlert();
              },
              child: Text('SUBMIT',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  // Dialog popup that allows the user to enter in a text box.
  Future<String?> openDialog(String title, String hinttext) {
    late TextEditingController controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: hinttext,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: FitBuddyColorConstants.lAccent, width: 2)),
          ),
          controller: controller,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
                openAlert();
              },
              child: Text('SUBMIT',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  // Dialog popup that lets the user kn ow their changes wont take place until they reload the app.
  Future<String?> openAlert() {
    late TextEditingController controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Desclaimer"),
        content: const Text("Changes won't be seen till the app is reloaded."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('OK',
                  style: TextStyle(color: FitBuddyColorConstants.lAccent)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserServiceFirestore userService =
        FirestoreService.firestoreService().userService;
    User user = userService.user;
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Back button that takes the user to the settings home page.
            Row(
              children: [
                IconButton(
                    onPressed: () =>
                        context.goNamed(FitBuddyRouterConstants.homePage),
                    icon: Icon(Icons.arrow_back,
                        color: FitBuddyColorConstants.lOnPrimary)),
              ],
            ),

            // Page Title
            Center(
              child: Text('Account Settings',
                  style: TextStyle(
                      color: FitBuddyColorConstants.lOnPrimary, fontSize: 25)),
            ),

            const SizedBox(height: 35),

            // Displays current Display Name and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () async {
                    final name = await openDialog(
                        "Change Display Name", "Enter your new Display Name");
                    if (name != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Auth().currentUser?.uid)
                          .update({'displayName': name});
                    }
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Display Name',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.name,
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Username and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () async {
                    final username = await openDialog(
                        "Change Username", "Enter your new Username");
                    if (username != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Auth().currentUser?.uid)
                          .update({'username': username});
                    }
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Username',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.username,
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Email and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () async {
                    final email = await openDialog(
                        "Change Email", "Enter your new Email");
                    if (email != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Auth().currentUser?.uid)
                          .set({'email': email}, SetOptions(merge: true));
                    }
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.email ?? "null",
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Gender and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () async {
                    genderSelMenu("Select Your Gender", ["Male", "Female"]);
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.gender ?? "null",
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Date of Birth and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () {
                    _selDatePicker();
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date of Birth',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.dob.toDate().toString(),
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Lifting Style and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () {
                    styleSelMenu("Select Your Lifting Style", [
                      "Calisthenics",
                      "Powerlifting",
                      "Bodybuilding",
                      "Crossfit",
                      "General Health"
                    ]);
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lifting Style',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.liftingStyle ?? "null",
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Gym Goals and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () {
                    goalsSelMenu("Select Your Gym Goals",
                        ["Lose Weight", "Build Muscle", "Build Strength"]);
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gym Goals',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.gymGoals ?? "null",
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),

            Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),

            // Displays current Gym Experience and allows the user to change it.
            Row(children: [
              IconButton(
                  onPressed: () {
                    experienceSelMenu("Select Your Gym Experience", [
                      "0-3 Months",
                      "6 Months-1 Year",
                      "1-2 Years",
                      "2-4 Years",
                      "5+ Years"
                    ]);
                  },
                  icon: Icon(Icons.restart_alt,
                      color: FitBuddyColorConstants.lOnPrimary)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gym Experience',
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnPrimary,
                            fontSize: 18)),
                    Text(user.gymExperience ?? "null",
                        style: TextStyle(
                            color: FitBuddyColorConstants.lOnSecondary,
                            fontSize: 14)),
                  ],
                ),
              )
            ]),
          ],
        ),
      ),
    )));
  }
}
