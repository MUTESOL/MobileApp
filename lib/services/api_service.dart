import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiService {
  late final Dio _dio;
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 API Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('❌ API Error: ${error.response?.statusCode} ${error.message}');
        return handler.next(error);
      },
    ));
  }

  // Helper to handle API responses
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data['success'] == true) {
      return response.data; // Return full response to preserve structure
    } else {
      throw Exception(response.data['error'] ?? 'Unknown error');
    }
  }

  /// Claim tokens from faucet
  /// POST /faucet/claim
  Future<Map<String, dynamic>> claimFaucet({
    required String tokenAddress,
  }) async {
    try {
      final response = await _dio.post('/faucet/claim', data: {
        'tokenAddress': tokenAddress,
      });
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Check if user can claim from faucet
  /// GET /faucet/can-claim/:address/:tokenAddress
  Future<Map<String, dynamic>> canClaimFaucet({
    required String address,
    required String tokenAddress,
  }) async {
    try {
      final response = await _dio.get('/faucet/can-claim/$address/$tokenAddress');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get token balance
  /// GET /faucet/balance/:address/:tokenAddress
  Future<Map<String, dynamic>> getTokenBalance({
    required String address,
    required String tokenAddress,
  }) async {
    try {
      final response = await _dio.get('/faucet/balance/$address/$tokenAddress');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new savings goal
  /// POST /goals
  Future<Map<String, dynamic>> createGoal({
    required String name,
    required String owner,
    required String currency,
    required int mode, // 0 = Lite, 1 = Pro
    required String targetAmount,
    required int durationInDays,
    required int donationPercentage,
  }) async {
    try {
      final response = await _dio.post('/goals', data: {
        'name': name,
        'owner': owner.toLowerCase(), // Normalize to lowercase
        'currency': currency.toLowerCase(), // Normalize currency address too
        'mode': mode,
        'targetAmount': targetAmount,
        'durationInDays': durationInDays,
        'donationPercentage': donationPercentage,
      });
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get goal details
  /// GET /goals/:goalId
  Future<Map<String, dynamic>> getGoalDetails(int goalId) async {
    try {
      final response = await _dio.get('/goals/$goalId');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get all goals for a user
  /// GET /users/:address/goals
  Future<Map<String, dynamic>> getUserGoals(String address) async {
    try {
      final response = await _dio.get('/users/${address.toLowerCase()}/goals');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Deposit to a goal
  /// POST /goals/:goalId/deposit
  Future<Map<String, dynamic>> deposit({
    required int goalId,
    required String amount,
  }) async {
    try {
      final response = await _dio.post('/goals/$goalId/deposit', data: {
        'amount': amount,
      });
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Withdraw from completed goal
  /// POST /goals/:goalId/withdraw
  Future<Map<String, dynamic>> withdrawCompleted(int goalId) async {
    try {
      final response = await _dio.post('/goals/$goalId/withdraw');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Early withdrawal with penalty
  /// POST /goals/:goalId/withdraw-early
  Future<Map<String, dynamic>> withdrawEarly(int goalId) async {
    try {
      final response = await _dio.post('/goals/$goalId/withdraw-early');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get supported currencies with APYs
  /// GET /goals/currencies/list
  Future<Map<String, dynamic>> getSupportedCurrencies() async {
    try {
      final response = await _dio.get('/goals/currencies/list');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 400) {
          return data['error'] ?? 'Invalid request';
        } else if (statusCode == 404) {
          return data['error'] ?? 'Resource not found';
        } else if (statusCode == 500) {
          return data['error'] ?? 'Server error. Please try again later.';
        }
        return 'Server error (${statusCode})';

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return 'Cannot connect to server. Make sure the backend is running on ${_dio.options.baseUrl}';
        }
        return 'Connection error. Please check your network.';

      case DioExceptionType.cancel:
        return 'Request cancelled';

      default:
        return error.message ?? 'Unknown error occurred';
    }
  }

  /// Get all public goods projects
  /// GET /projects
  Future<Map<String, dynamic>> getProjects({
    String? category,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/projects', queryParameters: queryParams);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get project categories
  /// GET /projects/categories
  Future<Map<String, dynamic>> getProjectCategories() async {
    try {
      final response = await _dio.get('/projects/categories');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get project by ID
  /// GET /projects/:id
  Future<Map<String, dynamic>> getProjectById(String id) async {
    try {
      final response = await _dio.get('/projects/$id');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get project by address
  /// GET /projects/address/:address
  Future<Map<String, dynamic>> getProjectByAddress(String address) async {
    try {
      final response = await _dio.get('/projects/address/$address');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Validate if address is an approved project
  /// GET /projects/validate/:address
  Future<Map<String, dynamic>> validateProject(String address) async {
    try {
      final response = await _dio.get('/projects/validate/$address');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
