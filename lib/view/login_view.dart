// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_run/constanst/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Login',
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter Your email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: _password,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Password',
                          border: InputBorder.none)),
                ),
                TextButton(
                  onPressed: () async {
                    await Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform);
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);

                      devtools.log(userCredential.toString());
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home/', (route) => false);
                    } on FirebaseAuthException catch (e) {
                      var errorMsg = ' error';
                      print(e.code);
                      if (e.code == 'user-not-found') {
                        errorMsg = 'User not found!';
                      } else if (e.code == 'unknown') {
                        errorMsg = 'Please enter Email and Password!';
                      } else if (e.code == 'wrong-password') {
                        errorMsg = 'Wrong password!';
                      } else if (e.code == 'invalid-email') {
                        errorMsg = 'Invalid Email!';
                      } else if (e.code == 'too-many-requests') {
                        errorMsg = 'Please try again later!';
                      } else if (e.code == 'network-request-failed') {
                        errorMsg = 'Please Connect Network';
                      } else {
                        errorMsg = e.code;
                      }
                      await showErrorMsg('Error', errorMsg, context);
                    } catch (e) {
                      await showErrorMsg('Error', e.toString(), context);
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: const Text('Not registered yet? Register here!'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
