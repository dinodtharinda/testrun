// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:test_run/constanst/routes.dart';
import 'package:test_run/services/auth/auth_exception.dart';
import 'package:test_run/services/auth/auth_service.dart';
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
                    final email = _email.text;
                    final password = _password.text;
                    var errorMsg = 'error';
                    try {
                    await  AuthService.firebase()
                          .login(email: email, password: password);
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, (route) => false);
                      }
                    } on UserNotFoundAuthException {
                      errorMsg = 'User not found!';
                      await showErrorMsg('Error', errorMsg, context);
                    } on WrongPasswordAuthException {
                      errorMsg = 'Wrong password!';
                      await showErrorMsg('Error', errorMsg, context);
                    } on InvaidEmailAuthException {
                      errorMsg = 'Invalid Email!';
                      await showErrorMsg('Error', errorMsg, context);
                    }  on GenericAuthException {
                      await showErrorMsg(
                          'Login Error','Authentication Error', context);
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
