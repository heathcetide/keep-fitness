import 'package:demo_project/common/api_service.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../common/local_storage.dart';

class UserApi {
  final ApiService _apiService = ApiService();

  //用户发送邮箱验证码
  Future<ApiResponse> sendEmailVerificationCode(String email) async {
    return await _apiService.post('/fitness/api/users/email/code?email=$email');
  }

  // 用户注册
  Future<ApiResponse> register(String code, String email) async {
    return await _apiService.post(
      '/fitness/api/users/register/email',
      data: {'code': code, 'email': email},
    );
  }

  // 用户登录
  Future<ApiResponse> login(String code, String email) async {
    return await _apiService.post(
      '/fitness/api/users/login/email',
      data: {'code': code, 'email': email},
    );
  }

  // 用户根据token获取信息
  Future<ApiResponse> getUserInfoByToken() async {
    return await _apiService.get('/fitness/api/users/info');
  }

  // 更新用户信息
  Future<ApiResponse> updateUserProfile(UserProfile user) async {
    return await _apiService.put(
      '/fitness/api/users/update',
      data: {
        'username': user.username,
        'address': user.address,
        'birthday': user.birthday,
        'gender': user.gender,
        'bio': user.bio,
      },
    );
  }

  Future<ApiResponse> uploadAvatar(Uint8List imageData) async {
    return await _apiService.post(
      '/fitness/api/users/upload-avatar',
      data: FormData.fromMap({'file': MultipartFile.fromBytes(imageData)}),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateUserInfo(
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put<Map<String, dynamic>>(
      '/fitness/api/users/info',
      data: data,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserInfo() async {
    return await _apiService.get<Map<String, dynamic>>('/user/info');
  }

  // 文章相关
  Future<ApiResponse> getArticles({int page = 1, int pageSize = 10}) async {
    return await _apiService.get(
      '/articles',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
  }

  Future<ApiResponse> createArticle(Map<String, dynamic> articleData) async {
    return await _apiService.post('/articles', data: articleData);
  }

  Future<ApiResponse> updateArticle(
    String articleId,
    Map<String, dynamic> articleData,
  ) async {
    return await _apiService.put('/articles/$articleId', data: articleData);
  }

  Future<ApiResponse> deleteArticle(String articleId) async {
    return await _apiService.delete('/articles/$articleId');
  }

  Future<Uint8List> fetchImageData(String url) async {
    try {
      final response = await _apiService.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.code == 200) {
        return response.data;
      }
      throw Exception('Failed to fetch image data');
    } on DioException catch (e) {
      throw Exception('Failed to fetch image data: ${e.message}');
    }
  }
}

class UserProfile {
  final String username;
  final String email;
  final String phone;
  final String address;
  final String points;
  final String articleCount;
  final String activityCount;
  final int gender;
  final String bio;
  final String birthday;
  final String lastLoginTime;
  final String createdAt;
  final String avatarUrl;

  UserProfile({
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.points,
    required this.articleCount,
    required this.activityCount,
    required this.gender,
    required this.bio,
    required this.birthday,
    required this.lastLoginTime,
    required this.createdAt,
    required this.avatarUrl,
  });

  factory UserProfile.fromLocalStorage() {
    return UserProfile(
      username: LocalStorage.user_userName.get() ?? '',
      email: LocalStorage.user_email.get() ?? '',
      phone: LocalStorage.user_phone.get() ?? '',
      address: LocalStorage.user_address.get() ?? '',
      points: LocalStorage.user_points.get() ?? '0',
      articleCount: LocalStorage.user_articleCount.get() ?? '0',
      activityCount: LocalStorage.user_activityCount.get() ?? '0',
      gender: int.tryParse(LocalStorage.user_gender.get() ?? '0') ?? 0,
      bio: LocalStorage.user_bio.get() ?? '',
      birthday: LocalStorage.user_birthday.get() ?? '',
      lastLoginTime: LocalStorage.user_lastLoginTime.get() ?? '',
      createdAt: LocalStorage.user_createdAt.get() ?? '',
      avatarUrl: LocalStorage.user_avatarUrl.get() ?? '',
    );
  }
}
