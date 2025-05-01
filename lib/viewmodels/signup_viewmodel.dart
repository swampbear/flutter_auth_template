// lib/viewmodels/sign_up_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';
import '../providers.dart'; // for authRepositoryProvider

/// The provider you’ll watch in your SignUpPage:
final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, AuthState>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return SignUpViewModel(repo, ref);
    });

class SignUpViewModel extends StateNotifier<AuthState> {
  SignUpViewModel(this._repo, this._ref) : super(AuthState.idle());

  final AuthRepository _repo;
  final Ref _ref;

  /// Call this from your UI: ref.read(signUpViewModelProvider.notifier).signUp(...)
  Future<void> signUp(String email, String password) async {
    state = AuthState.loading();
    try {
      final User? user = await _repo.signUp(
        email: email.trim(),
        password: password,
      );

      if (user == null) {
        state = AuthState.error('Sign-up failed: no user returned');
      } else {
        state = AuthState.success(user);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
