// lib/viewmodels/auth_state.dart
import '../models/user.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState._({required this.status, this.user, this.errorMessage});

  factory AuthState.idle() => AuthState._(status: AuthStatus.idle);
  factory AuthState.loading() => AuthState._(status: AuthStatus.loading);
  factory AuthState.success(User user) =>
      AuthState._(status: AuthStatus.success, user: user);
  factory AuthState.error(String msg) =>
      AuthState._(status: AuthStatus.error, errorMessage: msg);
}
