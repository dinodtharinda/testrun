// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:test_run/constanst/routes.dart';
import 'package:test_run/services/auth/auth_exception.dart';
import 'package:test_run/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
              margin: const EdgeInsets.only(top: 70, bottom: 230),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
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
                    final email = _email.text;
                    final password = _password.text;
                    var errorMsg = ' error';
                    try {
                      await AuthService.firebase()
                          .createUser(email: email, password: password);
                      AuthService.firebase().currentUser;
                      await AuthService.firebase().sendEmailVerification();
                      Navigator.pushNamed(context, verifyEmailRoute);
                    } on EmailAlredyUseAuthException {
                      errorMsg = 'This email is already in use!';
                      await showErrorMsg('Login Error', errorMsg, context);
                    } on InvaidEmailAuthException {
                      errorMsg = 'Invalid Email!';
                      await showErrorMsg('Login Error', errorMsg, context);
                    } on WeakPasswordAuthException {
                      errorMsg = 'Weak password!';
                      await showErrorMsg('Login Error', errorMsg, context);
                    } on GenericAuthException {
                      await showErrorMsg(
                          'Login Error', 'Authentication error', context);
                    }
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const Text('Already registered? Login here!'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
