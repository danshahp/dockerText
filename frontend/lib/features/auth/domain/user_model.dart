import 'package:flutter/foundation.dart';
import 'package:tanzanian_bms/features/auth/domain/employment_details_model.dart';
import 'package:tanzanian_bms/features/auth/domain/billing_info_model.dart';
import 'package:tanzanian_bms/features/auth/domain/user_role_model.dart';

@immutable
class User {
  final String uid;
  final String? email;
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? imageUrl;
  final UserRole role;
  final EmploymentDetails? employmentDetails;
  final BillingInfo? billingInfo;

  const User({
    required this.uid,
    this.email,
    this.fullName,
    this.username,
    this.phoneNumber,
    this.imageUrl,
    required this.role,
    this.employmentDetails,
    this.billingInfo,
  });

  User copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? username,
    String? phoneNumber,
    String? imageUrl,
    UserRole? role,
    EmploymentDetails? employmentDetails,
    BillingInfo? billingInfo,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      employmentDetails: employmentDetails ?? this.employmentDetails,
      billingInfo: billingInfo ?? this.billingInfo,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'username': username,
    'phoneNumber': phoneNumber,
    'imageUrl': imageUrl,
    'role': role.name,
    'employmentDetails': employmentDetails?.toJson(),
    'billingInfo': billingInfo?.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'] as String,
    email: json['email'] as String?,
    fullName: json['fullName'] as String?,
    username: json['username'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    imageUrl: json['imageUrl'] as String?,
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.undefined,
    ),
    employmentDetails:
        json['employmentDetails'] != null
            ? EmploymentDetails.fromJson(
              json['employmentDetails'] as Map<String, dynamic>,
            )
            : null,
    billingInfo:
        json['billingInfo'] != null
            ? BillingInfo.fromJson(json['billingInfo'] as Map<String, dynamic>)
            : null,
  );

  @override
  String toString() =>
      'User(uid: $uid, email: $email, fullName: $fullName, username: $username, role: ${role.displayName}, phoneNumber: $phoneNumber, imageUrl: $imageUrl, employmentDetails: $employmentDetails, billingInfo: $billingInfo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.uid == uid &&
        other.email == email &&
        other.fullName == fullName &&
        other.username == username &&
        other.phoneNumber == phoneNumber &&
        other.imageUrl == imageUrl &&
        other.role == role &&
        other.employmentDetails == employmentDetails &&
        other.billingInfo == billingInfo;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      username.hashCode ^
      phoneNumber.hashCode ^
      imageUrl.hashCode ^
      role.hashCode ^
      employmentDetails.hashCode ^
      billingInfo.hashCode;
}
