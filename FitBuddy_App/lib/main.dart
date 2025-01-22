import 'package:fit_buddy/services/router.dart';
import 'package:fit_buddy/theme/theme_constants.dart';
import 'package:fit_buddy/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    ThemeManager().addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
    ThemeManager().removeListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if(mounted) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: fitBuddyLightTheme,
      //darkTheme: darkTheme,
      //themeMode: ThemeManager.themeMode,
      routerConfig: FitBuddyRouter().router,

    );
  }
}

// https://coolors.co/30343f-fafaff-e4d9ff-273469-1e2749