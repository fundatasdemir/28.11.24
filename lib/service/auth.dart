import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Kayıt olmak
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Giriş
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async =>
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  //Çıkış
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
