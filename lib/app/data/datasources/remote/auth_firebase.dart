import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "username": username,
          "createdAt": FieldValue.serverTimestamp(),
        });

        user.updateDisplayName(username);
        return user;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Kirim Verifikasi Email
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> updateUsername(String username) async {
    try {
      User? user = _firebaseAuth.currentUser;
      
      if(user == null){
        throw Exception("User not found");
      }

      await _firestore.collection("users").doc(user!.uid).update({
        "username" : username,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await user.updateDisplayName(username);
      await user.reload();

    } catch (e) {
        Get.snackbar(
          "Error!", 
          "Failed to update username! : $e",
          colorText: Colors.white, 
          backgroundColor: Colors.red
        );
        throw Exception("Failed to update username! : $e");
    }
  }


Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email tidak terdaftar.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Format email salah.');
      } else {
        throw Exception(e.message ?? 'Gagal mengirim email reset.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Cek User saat ini
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> reloadUser() async {
    // reload() akan memperbarui data currentUser dari server
    await _firebaseAuth.currentUser?.reload();
  }

  // cek status verifikasi simple
  bool isEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }
}
