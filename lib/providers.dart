// lib/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_service.dart';
import 'repositories/auth_repository.dart';

/// 1) Provide the Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// 2) Provide your AuthService (raw Supabase calls)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// 3) Provide your AuthRepository (maps raw → domain)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthRepository(authService);
});
