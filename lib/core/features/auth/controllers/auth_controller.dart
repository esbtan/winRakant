import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState {
  final Session? session;
  final bool loading;
  final String? error;

  const AuthState({this.session, this.loading = false, this.error});

  AuthState copyWith({Session? session, bool? loading, String? error}) {
    return AuthState(
      session: session ?? this.session,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final auth = Supabase.instance.client.auth;

    // أول قيمة
    state = AuthState(session: auth.currentSession);

    // متابعة تغيّرات الجلسة
    auth.onAuthStateChange.listen((data) {
      final session = data.session;
      state = state.copyWith(session: session);
    });

    return state;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(loading: false, session: res.session);
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // ملاحظة: session ممكن تكون null لو Supabase عامل email confirmation
      state = state.copyWith(loading: false, session: res.session);
    } on AuthException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = const AuthState();
  }

  final authControllerProvider = NotifierProvider<AuthController, AuthState>(
    AuthController.new,
  );
}
