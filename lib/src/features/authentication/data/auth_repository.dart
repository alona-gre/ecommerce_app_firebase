// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/data/firebase_app_user.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/domain/app_user.dart';
part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(
    this._auth,
  );

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map((_convertUser));
  }

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  /// Helper method to convert a Firebase [User] to an [AppUser]
  AppUser? _convertUser(User? user) {
    return user != null ? FirebaseAppUser(user) : null;
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance);
}

// * Using keepAlive since other providers need it to be an
// * [AlwaysAliveProviderListenable]
@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
