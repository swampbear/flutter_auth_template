import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../repositories/auth_repository.dart';

final signOutViewModelProvider =
    StateNotifierProvider<SignOutViewModel, AsyncValue<void>>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignOutViewModel(repo);
});

class SignOutViewModel extends StateNotifier<AsyncValue<void>> {
  SignOutViewModel(this._repo) : super(const AsyncValue.data(null));
  final AuthRepository _repo;

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
      // AuthWidget will rebuild to SignInPage automatically
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
