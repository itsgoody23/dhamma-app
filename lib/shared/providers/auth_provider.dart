import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/services/auth_service.dart';

part 'auth_provider.g.dart';

/// Supabase client singleton — initialized in main.dart.
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Auth service wrapping Supabase auth operations.
@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.watch(supabaseClientProvider));
}

/// Reactive stream of auth state changes (sign-in, sign-out, token refresh).
@riverpod
Stream<AuthState> authState(Ref ref) {
  return ref.watch(authServiceProvider).onAuthStateChange;
}

/// Current user — null when not signed in.
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((s) => s.session?.user).value;
}
