import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Listen to auth state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Sign-in error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during sign-in: $e");
      return null;
    }
  }

  // Sign up with email, password, and role
  Future<User?> signUp(String email, String password, String role) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.sendEmailVerification();

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign-up error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during sign-up: $e");
      return null;
    }
  }

  // Get role of a user from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      } else {
        print("No user document found for UID $uid");
        return null;
      }
    } catch (e) {
      print("Error retrieving role for UID $uid: $e");
      return null;
    }
  }

  // Check if email is verified
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    await user?.reload(); // Refresh user data
    return user?.emailVerified ?? false;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Phone sign-in (for completeness — if you want it here)
  Future<void> signInWithPhone(
    String phoneNumber,
    Function(PhoneAuthCredential) onCompleted,
    Function(FirebaseAuthException) onFailed,
    Function(String verificationId, int? resendToken) onCodeSent,
    Function(String) onCodeAutoRetrievalTimeout,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onCompleted,
      verificationFailed: onFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  // Manual verification with SMS code
  Future<User?> signInWithSmsCode(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  // Sign in with any AuthCredential (e.g., from Google, Facebook, etc.)
  Future<User?> signInWithCredential(AuthCredential credential) async {
    try {
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("signInWithCredential error: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
