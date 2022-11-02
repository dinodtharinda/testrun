// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_run/view/login_view.dart';
import 'firebase_options.dart';
import 'view/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView()
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            //   if (user!.emailVerified) {
            //     return const Text('done');
            //   } else {
            //     return const Center(child: VerifyEmailView());
            //   }
            return const LoginView();
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

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text('Please Verify your email'),
              TextButton(
                onPressed: () async {
                  await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform);
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text('Send email verification'),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
