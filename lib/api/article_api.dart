import '../common/api_service.dart';

class ArticleApi {
  final ApiService _apiService = ApiService();

  //获取推荐文章
  Future<ApiResponse> getRecommendArticles() async {
    return await _apiService.get('/fitness/api/articles/recommend');
  }


  // 根据id获取文章详细信息
  Future<ApiResponse> getArticleInfoById(id) async {
    return await _apiService.get('/fitness/api/articles/get/' + id);
  }

  // 新增：游标分页获取文章列表
  Future<ApiResponse> getArticlesByCursor({
    int? lastId,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> params = {
      'pageSize': pageSize,
    };

    if (lastId != null) {
      params['lastId'] = lastId;
    }

    return await _apiService.get(
      '/fitness/api/articles/listByCursor',
      queryParameters: params,
    );
  }
}
