// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';
import '../providers.dart';

/// 1) Sign-In ViewModel + State Provider
final signInViewModelProvider =
    StateNotifierProvider<SignInViewModel, AuthState>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return SignInViewModel(repo, ref);
    });

class SignInViewModel extends StateNotifier<AuthState> {
  SignInViewModel(this._repo, this._ref) : super(AuthState.idle());
  final AuthRepository _repo;
  final Ref _ref;

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    try {
      final User? user = await _repo.signIn(email: email, password: password);
      if (user == null) {
        state = AuthState.error('No user returned');
      } else {
        state = AuthState.success(user);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

/// 2) Sign-Up ViewModel + State Provider
final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, AuthState>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return SignUpViewModel(repo, ref);
    });

class SignUpViewModel extends StateNotifier<AuthState> {
  SignUpViewModel(this._repo, this._ref) : super(AuthState.idle());
  final AuthRepository _repo;
  final Ref _ref;

  Future<void> signUp(String email, String password) async {
    state = AuthState.loading();
    try {
      final User? user = await _repo.signUp(email: email, password: password);
      if (user == null) {
        state = AuthState.error('Sign-up failed');
      } else {
        state = AuthState.success(user);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
