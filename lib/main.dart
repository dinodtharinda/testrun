// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:test_run/constanst/routes.dart';
import 'package:test_run/services/auth/auth_service.dart';
import 'package:test_run/view/login_view.dart';
import 'package:test_run/view/notes/new_note_view.dart';
import 'package:test_run/view/verify_email_view.dart';
import 'view/notes/notes_view.dart';
import 'view/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      home: const MyApp(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const Home(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView()
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const Home();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text('Lodding...'),
                ],
              ),
            );
        }
      },
    );
  }
}
