import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/database_helper.dart';
import '../model/auth_model.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier() : super(AuthModel()) {
    _initialize();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _initialize() async {
    _auth.authStateChanges().listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<void> registerUser(
      String email, String password, String name, String dob) async {
    state = state.copyWith(isLoading: true);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'dob': dob,
          'profileImageUrl': '',
        });
        state = state.copyWith(user: user);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': '',
            'dob': '',
            'profileImageUrl': '',
          });
        }
        state = state.copyWith(user: user);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> googleSignIn() async {
    state = state.copyWith(isLoading: true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? '',
            'dob': '',
            'profileImageUrl': user.photoURL ?? '',
          });
        }
        state = state.copyWith(user: user);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await dbHelper.clearDatabase();
    await _auth.signOut();
    await _googleSignIn.signOut();
    state = state.copyWith(user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  return AuthNotifier();
});
