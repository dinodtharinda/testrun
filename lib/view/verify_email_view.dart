// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:test_run/constanst/routes.dart';
import 'package:test_run/services/auth/auth_exception.dart';
import 'package:test_run/services/auth/auth_service.dart';
import 'package:test_run/utilities/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 280),
              child: const Text(
                'Verify email',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "we've sent you an email verification. please open it to verify your account.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final user = AuthService.firebase().currentUser;
                    await AuthService.firebase().sendEmailVerification();
                    if (user!.isEmailVerified) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                  } 
                  on UserNotLoggedInAuthException {
                    showErrorMsg('Error', 'user not Logged in', context);
                  } catch (e) {
                    showErrorMsg('Error', e.toString(), context);
                  }
                },
                child: const Text("Send email verification again!"),
              ),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Restart'),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
