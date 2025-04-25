import '../common/api_service.dart';

class ArticleApi {
  final ApiService _apiService = ApiService();

  //用户发送邮箱验证码
  Future<ApiResponse> getRecommendArticles() async {
    return await _apiService.get('/fitness/api/articles/recommend');
  }

  // // 用户注册
  // Future<ApiResponse> register(String code, String email) async {
  //   return await _apiService.post(
  //     '/fitness/api/users/register/email',
  //     data: {'code': code, 'email': email},
  //   );
  // }
  //
  // // 用户登录
  // Future<ApiResponse> login(String code, String email) async {
  //   return await _apiService.post(
  //     '/fitness/api/users/login/email',
  //     data: {'code': code, 'email': email},
  //   );
  // }

}
