import 'dart:async';
import 'dart:convert';
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
        headers: {'Accept': 'application/json'},
      ),
    );
    super.onInit();
  }

  void _logApiCall(String methodName, {Map<String, dynamic>? params}) {
    print('🔵 API CALL: $methodName');
    if (params != null && params.isNotEmpty) {
      print('📤 Parameters: $params');
    }
  }

  void _logSuccess(String methodName, int? statusCode, dynamic data) {
    try {
      print('✅ $methodName SUCCESS: $statusCode');
      if (data == null) {
        print('📦 Response: null');
        return;
      }

      String displayStr = '';
      if (data is Map || data is List) {
        try {
          displayStr = jsonEncode(data);
        } catch (e) {
          displayStr = data.toString();
        }
      } else {
        displayStr = data.toString();
      }

      if (displayStr.length > 500) {
        print('📦 Response (truncated): ${displayStr.substring(0, 500)}...');
      } else {
        print('📦 Response: $displayStr');
      }
    } catch (e) {
      print('📦 Response: [Log error: $e]');
    }
  }

  void _logError(String methodName, dynamic error) {
    print('❌ $methodName ERROR: $error');
    if (error is DioException) {
      print('   Status: ${error.response?.statusCode}');
      print('   Message: ${error.message}');
      print('   Data: ${error.response?.data}');
    }
  }

  Future<CountryCodesResponse?> getCountryCodes() async {
    try {
      _logApiCall('getCountryCodes');
      final response = await _dio.get(ApiConstants.getCountryCodes);
      _logSuccess('getCountryCodes', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return CountryCodesResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logError('getCountryCodes', e);
      return null;
    }
  }

  Future<SendOtpResponse?> sendOtp(String countryCode, String mobile) async {
    try {
      _logApiCall(
        'sendOtp',
        params: {'country_code': countryCode, 'mobile': mobile},
      );
      final formData = FormData.fromMap({
        'country_code': countryCode,
        'mobile': mobile,
      });

      final response = await _dio.post(ApiConstants.sendOtp, data: formData);
      _logSuccess('sendOtp', response.statusCode, response.data);

      if (response.data != null && response.data is Map) {
        return SendOtpResponse.fromJson(response.data);
      }
      return _errorResponse();
    } on DioException catch (e) {
      _logError('sendOtp', e);
      if (e.response?.data != null && e.response?.data is Map) {
        return SendOtpResponse.fromJson(e.response!.data);
      }
      return _errorResponse();
    } catch (e) {
      _logError('sendOtp', e);
      return _errorResponse();
    }
  }

  Future<SendOtpResponse?> verifyOtp(
    String countryCode,
    String mobile,
    String otp,
  ) async {
    try {
      _logApiCall(
        'verifyOtp',
        params: {'country_code': countryCode, 'mobile': mobile, 'otp': '***'},
      );
      final formData = FormData.fromMap({
        'country_code': countryCode,
        'mobile': mobile,
        'otp': otp,
      });

      final response = await _dio.post(ApiConstants.verifyOtp, data: formData);
      _logSuccess('verifyOtp', response.statusCode, response.data);

      if (response.data != null && response.data is Map) {
        final result = SendOtpResponse.fromJson(response.data);
        if (result.status &&
            result.data != null &&
            result.data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', result.data['token']);
          if (result.data['user'] != null &&
              result.data['user']['id'] != null) {
            await prefs.setString(
              'user_id',
              result.data['user']['id'].toString(),
            );
          } else if (result.data['id'] != null) {
            await prefs.setString('user_id', result.data['id'].toString());
          }
          print('🔑 Token and User ID saved successfully');
        }
        return result;
      }
      return _errorResponse();
    } on DioException catch (e) {
      _logError('verifyOtp', e);
      if (e.response?.data != null && e.response?.data is Map) {
        return SendOtpResponse.fromJson(e.response!.data);
      }
      return _errorResponse();
    } catch (e) {
      _logError('verifyOtp', e);
      return _errorResponse();
    }
  }

  Future<Map<String, dynamic>?> getTermsAndConditions() async {
    try {
      _logApiCall('getTermsAndConditions');
      final response = await _dio.get(ApiConstants.getTermsAndConditions);
      _logSuccess('getTermsAndConditions', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _logError('getTermsAndConditions', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAboutUs() async {
    try {
      _logApiCall('getAboutUs');
      final response = await _dio.get(ApiConstants.getAbout);
      _logSuccess('getAboutUs', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _logError('getAboutUs', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPrivacyPolicy() async {
    try {
      _logApiCall('getPrivacyPolicy');
      final response = await _dio.get(ApiConstants.getPrivacyPolicy);
      _logSuccess('getPrivacyPolicy', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _logError('getPrivacyPolicy', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getContact() async {
    try {
      _logApiCall('getContact');
      final response = await _dio.get(ApiConstants.getContact);
      _logSuccess('getContact', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _logError('getContact', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getHome() async {
    try {
      _logApiCall('getHome');
      final options = await _getAuthOptions();
      final response = await _dio.get(ApiConstants.home, options: options);
      _logSuccess('getHome', response.statusCode, response.data);
      if (response.data != null && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _logError('getHome', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      _logApiCall('getProfile');
      final options = await _getAuthOptions();
      print(
        '🔑 Auth token: ${options.headers?['Authorization']?.toString().substring(0, 20)}...',
      );
      final response = await _dio.get(
        ApiConstants.getProfile,
        options: options,
      );
      _logSuccess('getProfile', response.statusCode, response.data);
      if (response.data != null && response.data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final userId = response.data['data']?['user']?['id']?.toString();
        if (userId != null) {
          await prefs.setString('user_id', userId);
        }
      }
      return response.data;
    } catch (e) {
      _logError('getProfile', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile(FormData formData) async {
    try {
      _logApiCall(
        'updateProfile',
        params: {
          'fields': formData.fields
              .map((e) => '${e.key}=${e.value}')
              .join(', '),
        },
      );
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.updateProfile,
        data: formData,
        options: options,
      );
      _logSuccess('updateProfile', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('updateProfile', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRecommendedProducts({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        'sort_by': 'recently_posted',
        ...?queryParameters,
      };
      _logApiCall('getRecommendedProducts', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.recommendedProducts,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getRecommendedProducts', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getRecommendedProducts', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRecentlyAddedProducts({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        'sort_by': 'recently_posted',
        ...?queryParameters,
      };
      _logApiCall('getRecentlyAddedProducts', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.recentlyAddedProducts,
        queryParameters: params,
        options: options,
      );
      _logSuccess(
        'getRecentlyAddedProducts',
        response.statusCode,
        response.data,
      );
      return response.data;
    } catch (e) {
      _logError('getRecentlyAddedProducts', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllProducts({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        'sort_by': 'recently_posted',
        ...?queryParameters,
      };
      _logApiCall('getAllProducts', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.allProducts,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getAllProducts', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getAllProducts', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProductDetails(dynamic productId) async {
    try {
      final String idStr = productId.toString();
      _logApiCall('getProductDetails', params: {'product_id': idStr});

      final options = await _getAuthOptions();

      // Use the full URL explicitly to avoid any ambiguity
      final String fullUrl =
          '${ApiConstants.baseUrl}${ApiConstants.productDetails}';
      print('🌐 [API] Requesting: $fullUrl?product_id=$idStr');

      final response = await _dio.get(
        fullUrl,
        queryParameters: {'product_id': idStr},
        options: options.copyWith(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      _logSuccess('getProductDetails', response.statusCode, response.data);

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String) {
        try {
          return jsonDecode(response.data);
        } catch (e) {
          print(
            '❌ getProductDetails: Data is string but not JSON: ${response.data}',
          );
        }
      }
      return null;
    } on DioException catch (e) {
      _logError('getProductDetails', e);
      if (e.response?.data is Map<String, dynamic>) {
        return e.response?.data;
      }
      return null;
    } catch (e) {
      print('❌ getProductDetails Unexpected Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllConversations({
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = {'keyword': keyword ?? '', 'page': page, 'limit': limit};
      _logApiCall('getAllConversations', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getAllConversations,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getAllConversations', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getAllConversations', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendMessage(dynamic data) async {
    try {
      final Map<String, dynamic> logParams = {};
      if (data is Map<String, dynamic>) {
        logParams.addAll(data);
        if (logParams.containsKey('attachment'))
          logParams['attachment'] = '[File]';
      } else if (data is FormData) {
        for (var field in data.fields) {
          logParams[field.key] = field.value;
        }
      }
      _logApiCall('sendMessage', params: logParams);

      final options = await _getAuthOptions();

      FormData formData;
      if (data is FormData) {
        formData = data;
      } else if (data is Map<String, dynamic>) {
        formData = FormData.fromMap(data);
      } else {
        return null;
      }

      options.contentType = 'multipart/form-data';

      final response = await _dio.post(
        ApiConstants.sendMessage,
        data: formData,
        options: options,
      );
      _logSuccess('sendMessage', response.statusCode, response.data);
      return response.data;
    } on DioException catch (e) {
      _logError('sendMessage', e);
      if (e.response?.data != null && e.response?.data is Map) {
        return e.response?.data;
      }
      return null;
    } catch (e) {
      _logError('sendMessage', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getConversation(dynamic conversationId) async {
    try {
      _logApiCall(
        'getConversation',
        params: {'conversation_id': conversationId},
      );
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getConversation,
        queryParameters: {'conversation_id': conversationId},
        options: options,
      );
      _logSuccess('getConversation', response.statusCode, response.data);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Treat 422 (invalid conversation_id) as a successful "empty" chat
        // for new or uninitialized conversations.
        _logSuccess('getConversation (New Chat)', 200, {'status': true});
        return {
          'status': true,
          'data': {'messages': [], 'conversation': null},
        };
      }
      _logError('getConversation', e);
      return null;
    } catch (e) {
      _logError('getConversation', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteConversation(
    dynamic conversationId,
  ) async {
    try {
      _logApiCall(
        'deleteConversation',
        params: {'conversation_id': conversationId},
      );
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.deleteConversation,
        queryParameters: {'conversation_id': conversationId},
        options: options,
      );
      _logSuccess('deleteConversation', response.statusCode, response.data);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        _logSuccess('deleteConversation (422)', 422, e.response?.data);
        return e.response?.data;
      }
      _logError('deleteConversation', e);
      return null;
    } catch (e) {
      _logError('deleteConversation', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMyAds({
    int? type,
    int page = 1,
    int? limit,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'page': page,
        'type': type ?? 1,
        'limit': limit ?? 10,
      };

      _logApiCall('getMyAds', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.myAds,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getMyAds', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getMyAds', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> generateInvoice(FormData formData) async {
    try {
      _logApiCall('generateInvoice');
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.generateInvoice,
        data: formData,
        options: options,
      );
      _logSuccess('generateInvoice', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('generateInvoice', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> downloadInvoice(dynamic orderId) async {
    try {
      final params = {'order_id': orderId.toString()};
      _logApiCall('downloadInvoice', params: params);

      // Get auth options and modify for binary response
      final options = await _getAuthOptions();
      options.responseType = ResponseType.bytes;
      options.headers?['Accept'] = 'application/pdf';

      final response = await _dio.get(
        ApiConstants.downloadInvoice,
        queryParameters: params,
        options: options,
      );

      print('✅ downloadInvoice SUCCESS: ${response.statusCode}');
      print('📦 Response type: ${response.data.runtimeType}');

      if (response.data != null) {
        // Response should be bytes for PDF
        return <String, dynamic>{'status': true, 'file_data': response.data};
      }
      return null;
    } on DioException catch (e) {
      _logError('downloadInvoice', e);
      if (e.response?.data != null && e.response?.data is Map) {
        return Map<String, dynamic>.from(e.response?.data as Map);
      }
      return null;
    } catch (e) {
      _logError('downloadInvoice', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> reportAd(FormData formData) async {
    try {
      _logApiCall('reportAd');
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.reportAd,
        data: formData,
        options: options,
      );
      _logSuccess('reportAd', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('reportAd', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadDocuments(FormData formData) async {
    try {
      _logApiCall('uploadDocuments');
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.uploadDocuments,
        data: formData,
        options: options,
      );
      _logSuccess('uploadDocuments', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('uploadDocuments', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> buyPackage(FormData formData) async {
    try {
      _logApiCall(
        'buyPackage',
        params: {
          'fields': formData.fields
              .map((e) => '${e.key}=${e.value}')
              .join(', '),
        },
      );
      final options = await _getAuthOptions();
      print(
        '🔑 Auth token: ${options.headers?['Authorization']?.toString().substring(0, 20)}...',
      );
      final response = await _dio.post(
        ApiConstants.buyPackage,
        data: formData,
        options: options,
      );
      _logSuccess('buyPackage', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('buyPackage', e);
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> createAds(FormData formData) async {
    try {
      _logApiCall('createAds');
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.createAds,
        data: formData,
        options: options,
      );
      _logSuccess('createAds', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('createAds', e);
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateAd(
    dynamic productId,
    FormData formData,
  ) async {
    try {
      _logApiCall('updateAd', params: {'ad_id': productId});
      final options = await _getAuthOptions();
      // Ensure ad_id is sent as per Postman
      formData.fields.removeWhere((field) => field.key == 'ad_id');
      formData.fields.add(MapEntry('ad_id', productId.toString()));
      final response = await _dio.post(
        ApiConstants.updateAd,
        data: formData,
        options: options,
      );
      _logSuccess('updateAd', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('updateAd', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteAd(dynamic productId) async {
    try {
      _logApiCall('deleteAd', params: {'ad_id': productId});
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.deleteAd,
        queryParameters: {'ad_id': productId},
        options: options,
      );
      _logSuccess('deleteAd', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('deleteAd', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> markAsSold(dynamic productId) async {
    try {
      _logApiCall('markAsSold', params: {'ad_id': productId});
      final options = await _getAuthOptions();
      final formData = FormData.fromMap({'ad_id': productId});
      final response = await _dio.post(
        ApiConstants.markAsSold,
        data: formData,
        options: options,
      );
      _logSuccess('markAsSold', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('markAsSold', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> deactivateAds(dynamic productId) async {
    try {
      _logApiCall('deactivateAds', params: {'ad_id': productId});
      final options = await _getAuthOptions();
      // Postman says GET for deactivate-ads
      final response = await _dio.get(
        ApiConstants.deactivateAds,
        queryParameters: {'ad_id': productId},
        options: options,
      );
      _logSuccess('deactivateAds', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('deactivateAds', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAdDetails(dynamic productId) async {
    try {
      _logApiCall('getAdDetails', params: {'ad_id': productId});
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getAdDetails,
        queryParameters: {'ad_id': productId},
        options: options,
      );
      _logSuccess('getAdDetails', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getAdDetails', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPackages({
    int limit = 10,
    int page = 1,
  }) async {
    try {
      _logApiCall('getPackages', params: {'limit': limit, 'page': page});
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getPackages,
        queryParameters: {'limit': limit, 'page': page},
        options: options,
      );
      _logSuccess('getPackages', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getPackages', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchPackages({
    int limit = 10,
    int page = 1,
  }) async {
    try {
      _logApiCall('fetchPackages', params: {'limit': limit, 'page': page});
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.fetchPackages,
        queryParameters: {'limit': limit, 'page': page},
        options: options,
      );
      _logSuccess('fetchPackages', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('fetchPackages', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> addToWishlist(dynamic productId) async {
    try {
      _logApiCall('addToWishlist', params: {'product_id': productId});
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.addToWishlist,
        data: {'product_id': productId},
        options: options,
      );
      _logSuccess('addToWishlist', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('addToWishlist', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getWishlist({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = {'page': page, 'limit': limit};
      _logApiCall('getWishlist', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getWishlist,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getWishlist', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getWishlist', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteFromWishlist(dynamic productId) async {
    try {
      _logApiCall('deleteFromWishlist', params: {'product_id': productId});
      final options = await _getAuthOptions();
      final response = await _dio.post(
        ApiConstants.deleteFromWishlist,
        data: {'product_id': productId},
        options: options,
      );
      _logSuccess('deleteFromWishlist', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('deleteFromWishlist', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBoughtOrders({
    int page = 1,
    int limit = 10,
    String keyword = '',
    String? status,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        if (status != null) 'status': status,
      };
      _logApiCall('getBoughtOrders', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.boughtOrders,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getBoughtOrders', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getBoughtOrders', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSellerOrders({
    int page = 1,
    int limit = 10,
    String keyword = '',
    String? status,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        if (status != null) 'status': status,
      };
      _logApiCall('getSellerOrders', params: params);
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.sellerOrders,
        queryParameters: params,
        options: options,
      );
      _logSuccess('getSellerOrders', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getSellerOrders', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      _logApiCall('getNotifications', params: {'page': page, 'limit': limit});
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.getNotifications,
        queryParameters: {'page': page, 'limit': limit},
        options: options,
      );
      _logSuccess('getNotifications', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('getNotifications', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> logout() async {
    try {
      _logApiCall('logout');
      final options = await _getAuthOptions();
      final response = await _dio.post(ApiConstants.logout, options: options);
      _logSuccess('logout', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('logout', e);
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchSettings() async {
    try {
      _logApiCall('fetchSettings');
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.fetchSettings,
        options: options,
      );
      _logSuccess('fetchSettings', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('fetchSettings', e);
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteAccount() async {
    try {
      _logApiCall('deleteAccount');
      final options = await _getAuthOptions();
      final response = await _dio.get(
        ApiConstants.deleteAccount,
        options: options,
      );
      _logSuccess('deleteAccount', response.statusCode, response.data);
      return response.data;
    } catch (e) {
      _logError('deleteAccount', e);
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      return null;
    }
  }

  Future<Options> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('🔑 [API] Auth Token: Bearer $token');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
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
