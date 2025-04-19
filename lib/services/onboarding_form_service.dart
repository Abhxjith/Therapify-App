import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapify/models/onboarding_form_data.dart';

class OnboardingFormService {
  static const String _formDataKey = 'onboarding_form_data';

  Future<void> saveFormData(OnboardingFormData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_formDataKey, jsonString);
  }

  Future<OnboardingFormData?> getFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_formDataKey);
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString);
      return OnboardingFormData.fromJson(json);
    } catch (e) {
      print('Error loading form data: $e');
      return null;
    }
  }

  Future<void> clearFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_formDataKey);
  }
} 