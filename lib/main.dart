// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/SignInPage.dart';
import 'screens/SignUpPage.dart';
import 'screens/Home.dart';
//import 'screens/ForgotPasswordPage.dart';
// import 'routes.dart';  // if you made a central routes.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // initial route can be your splash/sign-in/etc
      
      routes: {
        '/signin':      (_) => const SignInPage(),
        '/signup':      (_) => const SignUpPage(),
        '/home':       (_) => const HomePage(),
      },
      initialRoute: '/signin',
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('404 – Page not found')),
        ),
      ),
    );
  }
}
