import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycStorageHelper {
  static const String _kycNameKey = 'kyc_full_name';
  static const String _kycIdNumberKey = 'kyc_id_number';
  static const String _kycAddressKey = 'kyc_address';
  static const String _kycVerifiedKey = 'kyc_verified';

  /// Save KYC identity information to local storage
  static Future<void> saveKycInfo({
    required String fullName,
    required String idNumber,
    required String address,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kycNameKey, fullName);
      await prefs.setString(_kycIdNumberKey, idNumber);
      await prefs.setString(_kycAddressKey, address);
      await prefs.setBool(_kycVerifiedKey, true);
      debugPrint('✅ KYC info saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving KYC info: $e');
    }
  }

  /// Load saved KYC full name
  static Future<String?> getFullName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kycNameKey);
    } catch (e) {
      debugPrint('❌ Error loading KYC name: $e');
      return null;
    }
  }

  /// Load saved KYC ID number
  static Future<String?> getIdNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kycIdNumberKey);
    } catch (e) {
      debugPrint('❌ Error loading KYC ID number: $e');
      return null;
    }
  }

  /// Load saved KYC address
  static Future<String?> getAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kycAddressKey);
    } catch (e) {
      debugPrint('❌ Error loading KYC address: $e');
      return null;
    }
  }

  /// Check if KYC has been verified/submitted before
  static Future<bool> isKycVerified() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kycVerifiedKey) ?? false;
    } catch (e) {
      debugPrint('❌ Error checking KYC verification status: $e');
      return false;
    }
  }

  /// Load all KYC information at once
  static Future<Map<String, String?>> loadKycInfo() async {
    return {
      'fullName': await getFullName(),
      'idNumber': await getIdNumber(),
      'address': await getAddress(),
    };
  }

  /// Clear all KYC information (for logout or reset)
  static Future<void> clearKycInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kycNameKey);
      await prefs.remove(_kycIdNumberKey);
      await prefs.remove(_kycAddressKey);
      await prefs.remove(_kycVerifiedKey);
      debugPrint('✅ KYC info cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing KYC info: $e');
    }
  }
}
