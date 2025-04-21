import 'dart:typed_data';
import 'package:demo_project/common/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:demo_project/common/loading_queue.dart';

class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? code;

  ApiResponse({this.data, this.message, this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'],
      message: json['message'] ?? json['msg'],
      code: json['code'],
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final LoadingQueue _loadingQueue = LoadingQueue();

  final String baseUrl = 'http://192.168.188.80:8080'; // 替换为你的基础URL

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 显示 loading
          _loadingQueue.show();

          // 添加token
          final token = _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 关闭 loading
          _loadingQueue.dismiss();
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 错误时也要关闭 loading
          _loadingQueue.dismiss();
          return handler.next(e);
        },
      ),
    );
  }

  // 获取存储的token
  String? _getToken() {
    // 从本地存储获取token的逻辑
    return LocalStorage.user_token.get();
  }

  // 统一的错误处理
  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // 处理超时错误
        break;
      case DioExceptionType.badResponse:
        // 处理响应错误
        switch (e.response?.statusCode) {
          case 401:
            // 处理未授权错误
            break;
          case 403:
            // 处理禁止访问错误
            break;
          case 404:
            // 处理未找到错误
            break;
          case 500:
            // 处理服务器错误
            break;
        }
        break;
      case DioExceptionType.cancel:
        // 处理请求取消
        break;
      default:
        // 处理其他错误
        break;
    }
  }

  // CRUD 操作
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }

  // 文件上传
  Future<ApiResponse<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }

  // 文件下载
  Future<ApiResponse<Uint8List>> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse(data: response.data);
    } on DioException catch (e) {
      return ApiResponse(
        message: e.message,
        code: e.response?.statusCode,
      );
    }
  }
}
