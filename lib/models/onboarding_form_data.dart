import 'package:flutter/foundation.dart';

class OnboardingFormData {
  final String? name;
  final String? email;
  final String? password;
  final Map<String, dynamic> cbtResponses;

  OnboardingFormData({
    this.name,
    this.email,
    this.password,
    this.cbtResponses = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'cbtResponses': cbtResponses,
    };
  }

  factory OnboardingFormData.fromJson(Map<String, dynamic> json) {
    return OnboardingFormData(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      cbtResponses: json['cbtResponses'] as Map<String, dynamic>? ?? {},
    );
  }
} 