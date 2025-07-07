import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      rethrow; // or return null / custom error
    } catch (e) {
      print("Unexpected error during sign-in: $e");
      return null; //same to rethrow
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

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      print("🔐 Attempting Google sign-in...");

      final googleUser =
          await googleSignIn.signIn(); // 👈 USE the same instance
      if (googleUser == null) {
        print("⚠️ Google sign-in cancelled by user.");
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) return null;

      // 🔐 Check if user exists in Firestore
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (!doc.exists) {
        await _auth.signOut(); // ❌ Deny access
        throw Exception("Access denied. Contact administrator.");
      }

      return user;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
// Sign up with email, password, and role
// Future<User?> signUp(String email, String password, String role) async {
  //   try {
  //     final credential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // ✅ Send verification email
  //     await credential.user!.sendEmailVerification();

  //     // ✅ Add role to Firestore
  //     await _firestore.collection('users').doc(credential.user!.uid).set({
  //       'email': email,
  //       'role': role,
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });

  //     return credential.user;
  //   } on FirebaseAuthException catch (e) {
  //     print("Sign-up error: ${e.code} - ${e.message}");
  //     rethrow;
  //   } catch (e) {
  //     print("Unexpected error during sign-up: $e");
  //     throw Exception("Unexpected error: $e"); // ✅ FIXED: Throw here as well
  //   }
  // }
