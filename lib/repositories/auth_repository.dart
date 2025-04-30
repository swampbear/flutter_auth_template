// lib/repositories/auth_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../models/user.dart' as domain;

class AuthRepository {
  final AuthService _service;
  AuthRepository(this._service);

  /// Wraps the raw call and maps the result into your domain.User
  Future<domain.User?> signIn({
    required String email,
    required String password,
  }) async {
    final User? raw = await _service.signIn(
      email: email, password: password,
    );
    if (raw == null) return null;
    return domain.User(id: raw.id, email: raw.email!);
  }

  Future<domain.User?> signUp({
    required String email,
    required String password,
  }) async {
    final User? raw = await _service.signUp(
      email: email, password: password,
    );
    if (raw == null) return null;
    return domain.User(id: raw.id, email: raw.email!);
  }

  Future<void> signOut() => _service.signOut();

  domain.User? get currentUser {
    final User? raw = _service.currentUser;
    if (raw == null) return null;
    return domain.User(id: raw.id, email: raw.email!);
  }
}
