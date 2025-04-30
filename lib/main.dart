// lib/main.dart (or wherever you put AuthWidget)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/SignUpPage.dart';
import 'screens/SignInPage.dart';
import 'screens/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthWidget(),
      routes: {
        '/signin': (_) => const SignInPage(),
        '/home':   (_) => const HomePage(),
        '/signup': (_) => const SignUpPage(),
      },
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) =>
          const Scaffold(body: Center(child: Text('404 – Page not found'))),
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<Session?>(
      // map the auth event stream to just the session object
      stream: supabase.auth.onAuthStateChange.map((e) => e.session),
      // seed it with whatever session we already have (persisted across restarts)
      initialData: supabase.auth.currentSession,
      builder: (context, snapshot) {
        // while waiting for the first event, show a spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;
        if (session == null) {
          // no session → signed out
          return const SignInPage();
        } else {
          // session exists → signed in
          return const HomePage();
        }
      },
    );
  }
}

