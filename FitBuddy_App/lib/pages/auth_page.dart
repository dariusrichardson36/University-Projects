import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth.dart';
import '../components/FitBuddyTextFormField.dart';
import '../components/FitBuddyThirdPartyBox.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isNewUser = false; // This needs to be on false
  bool loginState = true; // The current state of the page

  void toggleLoginState() {
    setState(() {
      loginState = !loginState;
    });
  }



//
//  @override
//  void dispose() {
//    emailController.dispose();
//    passwordController.dispose();
    //super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  SizedBox(
                    height: 100,
                    child: Image.asset('lib/images/logo.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "FitBuddy",
                    style: GoogleFonts.fugazOne(
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                    ) ,
                  ),
                  const SizedBox(height: 20),
                  if (loginState) ... [
                    loginEmailPw()
                  ] else
                    ...[
                      registerEmailPw()
                    ],
                  const Spacer(),

                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  otherLoginMethods(),
                  const SizedBox(height: 75),
                ]
              ),
            )
        );
      })
    );
  }


  login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Auth().signInWithEmail(emailController.text, passwordController.text);
    } else {

    }
  }

  register() async {
    try {
       var result = await Auth().registerWithEmail(emailController.text.trim(), passwordController.text.trim());
    } catch (e) {

      return e;
    }
  }

  loginEmailPw() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log in to your FitBuddy account',
            style: GoogleFonts.robotoFlex(
                fontWeight: FontWeight.w700,
                fontSize: 16
            ),
          ),
          const SizedBox(height: 20),
          FitBuddyTextFormField(
            controller: emailController,
            hintText: 'Email',
            isPassword: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          //const SizedBox(height: 20),
          FitBuddyTextFormField(
            controller: passwordController,
            hintText: 'Password',
            isPassword: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            icon: const Icon(Icons.visibility_off),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (){
                if (_loginFormKey.currentState!.validate()) {
                  _loginFormKey.currentState!.save();
                  login();
                }
              },
              child: const Text(
                "Log in",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("No FitBuddy account yet? "),
              GestureDetector(
                onTap: toggleLoginState,
                child: const Text(
                    "Register here",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16)
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }

  registerEmailPw() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Register a account on FitBuddy',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16
            ),
          ),
          const SizedBox(height: 20),
          FitBuddyTextFormField(
            controller: emailController,
            hintText: 'email',
            isPassword: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          // password textfield
          FitBuddyTextFormField(
            controller: passwordController,
            hintText: 'Password',
            isPassword: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          // password textfield
          FitBuddyTextFormField(
            controller: confirmPasswordController,
            hintText: 'Confirm password',
            isPassword: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              } else if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_registerFormKey.currentState!.validate()) {
                  _registerFormKey.currentState?.save();
                  register();
                } else {
                  // Not validated
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Already have a FitBuddy account? "),
              GestureDetector(
                onTap: toggleLoginState,
                child: const Text(
                    "Log in here",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  otherLoginMethods() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // google button
          FitBuddyThirdPartyBox(imagePath: 'lib/images/google.png',
            text: 'Continue with Google',
            onTap: () {
              Auth().signInWithGoogle();

            },
          ),
          const SizedBox(height: 10),
          // apple button
          FitBuddyThirdPartyBox(
              imagePath: 'lib/images/apple.png',
              text: 'Continue with Apple',
              onTap: () => Auth().signInWithGoogle()
          )
        ],
      );
  }
}
