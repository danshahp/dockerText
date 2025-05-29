import 'dart:async';
import 'package:get/get.dart';
import 'package:tanzanian_bms/features/auth/domain/auth_service_interface.dart';
import 'package:tanzanian_bms/features/auth/domain/user_model.dart';
import 'package:tanzanian_bms/features/auth/domain/employment_details_model.dart';
import 'package:tanzanian_bms/features/auth/domain/billing_info_model.dart';

// It's often good practice to have a base class or enum for auth states
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthController extends GetxController {
  final IAuthService _authService;

  // Reactive variables
  final Rx<AuthStatus> authStatus = AuthStatus.initial.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<User?>? _authStateSubscription;

  AuthController({required IAuthService authService}) : _authService = authService {
    _initialize();
  }

  void _initialize() async {
    // Listen to authentication state changes from the service
    _authStateSubscription = _authService.authStateChanges.listen(_handleAuthStateChanged);
    // Check current user status on initialization
    await _checkCurrentUser();
  }

  void _handleAuthStateChanged(User? user) {
    if (user != null) {
      currentUser.value = user;
      authStatus.value = AuthStatus.authenticated;
    } else {
      currentUser.value = null;
      authStatus.value = AuthStatus.unauthenticated;
    }
    isLoading.value = false;
  }

  Future<void> _checkCurrentUser() async {
    isLoading.value = true;
    try {
      final user = await _authService.getCurrentUser();
      _handleAuthStateChanged(user);
    } catch (e) {
      errorMessage.value = e.toString();
      authStatus.value = AuthStatus.error;
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    authStatus.value = AuthStatus.loading;
    try {
      await _authService.signInWithEmailAndPassword(email: email, password: password);
      // Auth state will be updated by the _authStateSubscription listener
    } catch (e) {
      errorMessage.value = e.toString();
      authStatus.value = AuthStatus.error;
      currentUser.value = null; // Ensure user is null on error
      isLoading.value = false; // Ensure loading is stopped
    }
    // isLoading is managed by _handleAuthStateChanged or catch block
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password, {
    required String fullName,
    required String username,
    String? phoneNumber,
    EmploymentDetails? employmentDetails,
    BillingInfo? billingInfo,
  }) async {
    isLoading.value = true;
    authStatus.value = AuthStatus.loading;
    try {
      await _authService.signUpWithEmailAndPassword(
        email: email, 
        password: password,
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        employmentDetails: employmentDetails,
        billingInfo: billingInfo,
      );
      // Auth state will be updated by the _authStateSubscription listener
    } catch (e) {
      errorMessage.value = e.toString();
      authStatus.value = AuthStatus.error;
      currentUser.value = null; // Ensure user is null on error
      isLoading.value = false; // Ensure loading is stopped
    }
    // isLoading is managed by _handleAuthStateChanged or catch block
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
      // Auth state will be updated by the _authStateSubscription listener
    } catch (e) {
      errorMessage.value = e.toString();
      authStatus.value = AuthStatus.error;
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    super.onClose();
  }
}
