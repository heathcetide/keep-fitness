import 'package:demo_project/common/api_service.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class UserApi {
  final ApiService _apiService = ApiService();

  //用户发送邮箱验证码
  Future<ApiResponse> sendEmailVerificationCode(String email) async {
    return await _apiService.post('/api/users/email/code?email=$email');
  }

  // 用户登录
  Future<ApiResponse> login(String code, String email) async {
    return await _apiService.post(
      '/api/users/login/email',
      data: {'code': code, 'email': email},
    );
  }

  // 用户根据token获取信息
  Future<ApiResponse> getUserInfoByToken() async {
    return await _apiService.get('/api/users/info');
  }

  Future<ApiResponse> uploadAvatar(Uint8List imageData) async {
    return await _apiService.post(
        '/api/users/upload-avatar',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(imageData),
        }));
  }

  Future<ApiResponse<Map<String, dynamic>>> updateUserInfo(
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put<Map<String, dynamic>>(
      '/api/users/info',
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


class UserInfo {
  final String username;
  final String email;
  final String phone;
  final String address;
  final int points;
  final int articleCount;
  final int activityCount;
  final String passwordSalt;
  final String avatarUrl;
  final int gender;
  final String? bio;
  final String birthday;
  final String lastLoginTime;
  final String createdAt;

  UserInfo({
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.points,
    required this.articleCount,
    required this.activityCount,
    required this.passwordSalt,
    required this.avatarUrl,
    required this.gender,
    required this.bio,
    required this.birthday,
    required this.lastLoginTime,
    required this.createdAt,
  });

  // 通过工厂方法从JSON解析数据
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      points: json['points'],
      articleCount: json['articleCount'],
      activityCount: json['activityCount'],
      passwordSalt: json['passwordSalt'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      bio: json['bio'],
      birthday: json['birthday'],
      lastLoginTime: json['lastLoginTime'],
      createdAt: json['createdAt'],
    );
  }

  // 将对象转为JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'points': points,
      'articleCount': articleCount,
      'activityCount': activityCount,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'bio': bio,
      'birthday': birthday,
      'lastLoginTime': lastLoginTime,
      'createdAt': createdAt,
    };
  }
}