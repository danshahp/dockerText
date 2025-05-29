import 'dart:async';
import 'package:tanzanian_bms/features/auth/domain/auth_service_interface.dart';
import 'package:tanzanian_bms/features/auth/domain/user_model.dart';
import 'package:tanzanian_bms/features/auth/domain/employment_details_model.dart';
import 'package:tanzanian_bms/features/auth/domain/billing_info_model.dart';
import 'package:tanzanian_bms/features/auth/domain/user_role_model.dart';

class MockAuthService implements IAuthService {
  final _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  // Simulate a database of users with passwords
  // In a real app, passwords would be hashed.
  final Map<String, ({User user, String password})> _users = {
    'admin@example.com': (
      user: User(
        uid: 'mock-uid-admin',
        email: 'admin@example.com',
        fullName: 'Admin User',
        username: 'admin',
        phoneNumber: '1234567890',
        role: UserRole.admin,
      ),
      password: 'password',
    ),
    'test@example.com': (
      user: User(
        uid: 'mock-uid-test',
        email: 'test@example.com',
        fullName: 'Test User',
        username: 'testuser',
        role: UserRole.staff,
      ),
      password: 'password',
    ),
  };

  // To store users signed up during the current session
  final Map<String, ({User user, String password})> _sessionSignedUpUsers = {};

  MockAuthService() {
    _authStateController.add(null);
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? getCurrentUser() {
    return _currentUser;
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check predefined users
    if (_users.containsKey(email)) {
      final userData = _users[email]!;
      if (userData.password == password) {
        _currentUser = userData.user;
        _authStateController.add(_currentUser);
        print('MockAuthService: Predefined user logged in: ${email}');
        return _currentUser!;
      }
    }

    // Check users signed up in this session
    if (_sessionSignedUpUsers.containsKey(email)) {
      final sessionUserData = _sessionSignedUpUsers[email]!;
      if (sessionUserData.password == password) {
        _currentUser = sessionUserData.user;
        _authStateController.add(_currentUser);
        print('MockAuthService: Session user logged in: ${email}');
        return _currentUser!;
      }
    }

    print('MockAuthService: Login failed. Invalid email or password for: ${email}');
    _authStateController.add(null); // Ensure state is updated on failure
    throw Exception('Invalid email or password');
  }

  @override
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? fullName,
    String? username,
    String? phoneNumber,
    EmploymentDetails? employmentDetails,
    BillingInfo? billingInfo,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_users.containsKey(email) || _sessionSignedUpUsers.containsKey(email)) {
      print('MockAuthService: Signup failed. Email already in use: ${email}');
      _authStateController.add(null);
      throw Exception('Email already in use');
    }

    final newUser = User(
      uid: 'mock-uid-${email.hashCode}',
      email: email,
      fullName: fullName,
      username: username,
      phoneNumber: phoneNumber,
      role: UserRole.staff, // Default role for new sign-ups
      employmentDetails: employmentDetails,
      billingInfo: billingInfo,
    );
    _sessionSignedUpUsers[email] = (user: newUser, password: password);
    _currentUser = newUser;
    _authStateController.add(_currentUser);
    print('MockAuthService: User signed up and logged in: ${email}');
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('MockAuthService: User logged out.');
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}
