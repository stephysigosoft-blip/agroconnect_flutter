import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_pkg;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_code.dart';
import '../models/send_otp_response.dart';
import '../utils/api_constants.dart';

class ApiService extends get_pkg.GetxService {
  late Dio _dio;

  @override
  void onInit() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
    super.onInit();
  }

  Future<CountryCodesResponse?> getCountryCodes() async {
    try {
      final response = await _dio.get(ApiConstants.getCountryCodes);
      if (response.data != null && response.data is Map) {
        return CountryCodesResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SendOtpResponse?> sendOtp(String countryCode, String mobile) async {
    try {
      final formData = FormData.fromMap({
        'country_code': countryCode,
        'mobile': mobile,
      });

      final response = await _dio.post(ApiConstants.sendOtp, data: formData);

      if (response.data != null && response.data is Map) {
        return SendOtpResponse.fromJson(response.data);
      }
      return _errorResponse();
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return SendOtpResponse.fromJson(e.response!.data);
      }
      return _errorResponse();
    } catch (e) {
      return _errorResponse();
    }
  }

  Future<SendOtpResponse?> verifyOtp(
    String countryCode,
    String mobile,
    String otp,
  ) async {
    try {
      final formData = FormData.fromMap({
        'country_code': countryCode,
        'mobile': mobile,
        'otp': otp,
      });

      final response = await _dio.post(ApiConstants.verifyOtp, data: formData);

      if (response.data != null && response.data is Map) {
        final result = SendOtpResponse.fromJson(response.data);
        if (result.status &&
            result.data != null &&
            result.data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', result.data['token']);
        }
        return result;
      }
      return _errorResponse();
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return SendOtpResponse.fromJson(e.response!.data);
      }
      return _errorResponse();
    } catch (e) {
      return _errorResponse();
    }
  }

  Future<Map<String, dynamic>?> getTermsAndConditions() async {
    try {
      final response = await _dio.get(ApiConstants.getTermsAndConditions);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAboutUs() async {
    try {
      final response = await _dio.get(ApiConstants.getAbout);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPrivacyPolicy() async {
    try {
      final response = await _dio.get(ApiConstants.getPrivacyPolicy);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getContact() async {
    try {
      final response = await _dio.get(ApiConstants.getContact);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        ApiConstants.home,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  SendOtpResponse _errorResponse() {
    return SendOtpResponse(
      status: false,
      data: [],
      message: {
        'message_en': ['Connection error or unexpected response'],
        'message_fr': ['Erreur de connexion ou réponse inattendue'],
      },
    );
  }
}
