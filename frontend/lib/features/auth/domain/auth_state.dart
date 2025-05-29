import 'package:flutter/foundation.dart';
import 'package:tanzanian_bms/features/auth/domain/user_model.dart';

// Using a sealed class pattern for states can be very effective with pattern matching in Dart 3+
@immutable
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

// Optionally, include user data or a token here
class Authenticated extends AuthState {
  final User user;
  const Authenticated({required this.user});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Authenticated && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
