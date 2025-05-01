import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/SignInPage.dart';
import 'screens/SignUpPage.dart';
import 'screens/Home.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // immediately notify, so redirect() runs at least once
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange.map((e) => e.session),
  ),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final loggedIn = session != null;

    // Use `state.matchedLocation` (or `state.uri.path`) instead of `location`
    final loc = state.matchedLocation; // e.g. '/signin', '/signup', '/home'
    final loggingIn = (loc == '/signin' || loc == '/signup');

    if (!loggedIn && !loggingIn) return '/signin';
    if (loggedIn && loggingIn) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/signin', builder: (_, __) => const SignInPage()),
    GoRoute(path: '/signup', builder: (_, __) => const SignUpPage()),
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
  ],
);
