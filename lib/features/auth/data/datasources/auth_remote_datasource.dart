import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  });
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<bool> reloadAndCheckVerified();
  bool get isEmailVerified;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _ensureUserDocument(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: _authErrorMessage(e.code));
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      try {
        await credential.user!.sendEmailVerification();
      } catch (e, st) {
        AppLogger.e(
            'Initial sendEmailVerification failed during signUp', e, st);
      }
      return _createUserDocument(credential.user!, displayName: displayName);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: _authErrorMessage(e.code));
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException(
            code: 'cancelled', message: 'Sign-in cancelled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _ensureUserDocument(userCredential.user!);
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: _authErrorMessage(e.code));
    } catch (e) {
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      try {
        await _firestore.collection(AppConfig.usersCollection).doc(uid).update({
          AppConfig.fieldIsOnline: false,
          AppConfig.fieldLastSeen: FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
    try {
      await _auth.signOut();

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
    } catch (_) {}
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: _authErrorMessage(e.code));
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(code: 'no-user', message: 'Not signed in');
    }
    if (user.emailVerified) return;
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      AppLogger.e('sendEmailVerification (manual) failed', e.code);
      throw AuthException(code: e.code, message: _authErrorMessage(e.code));
    }
  }

  @override
  Future<bool> reloadAndCheckVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.reload();
    } catch (_) {}
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<UserModel> _ensureUserDocument(User user) async {
    final ref = _firestore.collection(AppConfig.usersCollection).doc(user.uid);
    final doc = await ref.get();

    final model = UserModel(
      uid: user.uid,
      name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isOnline: true,
    );

    if (!doc.exists) {
      await ref.set(model.toCreateMap());
      AppLogger.i('Created user document', user.uid);
    } else {
      await ref.update({
        AppConfig.fieldIsOnline: true,
        AppConfig.fieldLastSeen: FieldValue.serverTimestamp(),
        AppConfig.fieldPhoto: user.photoURL,
        AppConfig.fieldName: model.name,
      });
    }
    return model;
  }

  Future<UserModel> _createUserDocument(User user,
      {required String displayName}) async {
    final model = UserModel(
      uid: user.uid,
      name: displayName,
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isOnline: true,
    );
    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.uid)
        .set(model.toCreateMap());
    AppLogger.i('Created new user document', user.uid);
    return model;
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'cancelled':
        return 'Sign-in cancelled';
      default:
        return 'Authentication failed (code: $code)';
    }
  }
}
