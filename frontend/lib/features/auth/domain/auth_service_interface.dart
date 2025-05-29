// Defines the contract for authentication services.
// It might return a custom User model or FirebaseUser, depending on your needs.

import 'package:tanzanian_bms/features/auth/domain/user_model.dart';
import 'package:tanzanian_bms/features/auth/domain/employment_details_model.dart';
import 'package:tanzanian_bms/features/auth/domain/billing_info_model.dart';

// Placeholder for a potential User model
// class User {
//   final String uid;
//   final String? email;
//   User({required this.uid, this.email});
// }

/// Abstract interface for authentication services.
/// This allows for different implementations (e.g., Firebase, mock, etc.)
/// to be used interchangeably throughout the application.
abstract class IAuthService {
  /// Stream of authentication state changes.
  /// Emits the current [User] if authenticated, or `null` if not.
  Stream<User?> get authStateChanges;

  /// Retrieves the current authenticated user, if any.
  /// Returns `null` if no user is currently authenticated.
  // Future<User?> getCurrentUser();
  User? getCurrentUser();

  /// Signs in a user with the given email and password.
  /// Returns the authenticated [User] on success.
  /// Throws an exception if sign-in fails.
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs up a new user with the given email, password, and other details.
  /// Returns the newly created and authenticated [User] on success.
  /// Throws an exception if sign-up fails.
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? fullName,
    String? username,
    String? phoneNumber,
    EmploymentDetails? employmentDetails, 
    BillingInfo? billingInfo, 
  });

  /// Signs out the current user.
  Future<void> signOut();

  // Future<void> sendPasswordResetEmail({required String email});

  // Future<void> signInWithGoogle(); // Example for social login
  // Future<void> signInWithBiometrics(); // If implementing biometric login
  // Future<void> signInWithPin({required String pin}); // If implementing PIN login
}
