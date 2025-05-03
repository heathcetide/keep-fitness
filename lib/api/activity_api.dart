import '../common/api_service.dart';

class ActivityApi {
  final ApiService _apiService = ApiService();

  //获取活动列表
  Future<ApiResponse> getActivityList(limit, cursor) async {
    return await _apiService.post('/fitness/api/activity/list',data: {'limit': limit, 'cursor': cursor});
  }
}
