// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70,bottom: 230),
              child:  const Text('Login',style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    await  Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);
          
                      var snackbar = SnackBar(
                          content: const Text('Logged In'),
                          elevation: 16,
                          backgroundColor: const Color.fromARGB(255, 27, 171, 51),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          duration: const Duration(seconds: 10),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            textColor: Colors.black,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                      var snackbar = SnackBar(
                          content: Text(errorMsg),
                          elevation: 16,
                          backgroundColor: const Color.fromARGB(255, 234, 15, 15),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          duration: const Duration(seconds: 10),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            textColor: Colors.black,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } catch (e) {
                      var snackbar = SnackBar(
                          content: Text(e.toString()),
                          elevation: 16,
                          backgroundColor: const Color.fromARGB(255, 234, 15, 15),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          duration: const Duration(seconds: 10),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            textColor: Colors.black,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/register/', (route) => false);
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
