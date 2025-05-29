import 'package:flutter/foundation.dart';

@immutable
class BillingInfo {
  final String? billingAddress;
  final String? city;
  final String? postalCode;
  final String? country;
  final String? preferredPaymentMethod; // e.g., 'M-Pesa', 'Tigo Pesa', 'Card', 'Bank Transfer'
  final String? paymentMethodDetails; // e.g., Phone number for mobile money, last 4 digits of card

  const BillingInfo({
    this.billingAddress,
    this.city,
    this.postalCode,
    this.country,
    this.preferredPaymentMethod,
    this.paymentMethodDetails,
  });

  Map<String, dynamic> toJson() => {
        'billingAddress': billingAddress,
        'city': city,
        'postalCode': postalCode,
        'country': country,
        'preferredPaymentMethod': preferredPaymentMethod,
        'paymentMethodDetails': paymentMethodDetails,
      };

  factory BillingInfo.fromJson(Map<String, dynamic> json) => BillingInfo(
        billingAddress: json['billingAddress'] as String?,
        city: json['city'] as String?,
        postalCode: json['postalCode'] as String?,
        country: json['country'] as String?,
        preferredPaymentMethod: json['preferredPaymentMethod'] as String?,
        paymentMethodDetails: json['paymentMethodDetails'] as String?,
      );

  @override
  String toString() {
    return 'BillingInfo(billingAddress: $billingAddress, city: $city, postalCode: $postalCode, country: $country, preferredPaymentMethod: $preferredPaymentMethod, paymentMethodDetails: $paymentMethodDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillingInfo &&
        other.billingAddress == billingAddress &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.preferredPaymentMethod == preferredPaymentMethod &&
        other.paymentMethodDetails == paymentMethodDetails;
  }

  @override
  int get hashCode =>
      billingAddress.hashCode ^
      city.hashCode ^
      postalCode.hashCode ^
      country.hashCode ^
      preferredPaymentMethod.hashCode ^
      paymentMethodDetails.hashCode;
}
