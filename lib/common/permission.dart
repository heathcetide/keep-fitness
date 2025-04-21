import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // 检查权限状态
  static Future<PermissionStatus> checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    return status;
  }

  // 请求单个权限
  static Future<bool> requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    return status.isGranted;
  }

  // 请求多个权限
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statusMap = await permissions.request();
    return statusMap;
  }

  // 检查是否已授予相机权限
  static Future<bool> hasCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  // 检查是否已授予存储权限
  static Future<bool> hasStoragePermission() async {
    return await requestPermission(Permission.storage);
  }

  // 检查是否已授予位置权限
  static Future<bool> hasLocationPermission() async {
    return await requestPermission(Permission.location);
  }

  // 检查是否已授予麦克风权限
  static Future<bool> hasMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  // 检查所有权限
  static Future<Map<Permission, PermissionStatus>> checkAllPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statusMap = {};
    for (Permission permission in permissions) {
      PermissionStatus status = await permission.status;
      statusMap[permission] = status;
    }
    return statusMap;
  }

  // 启用相机权限并执行操作
  static Future<bool> enableCameraPermissionAndDoAction(Function action) async {
    bool hasPermission = await hasCameraPermission();
    if (hasPermission) {
      action();
      return true;
    } else {
      return false;
    }
  }

  // 启用存储权限并执行操作
  static Future<bool> enableStoragePermissionAndDoAction(Function action) async {
    bool hasPermission = await hasStoragePermission();
    if (hasPermission) {
      action();
      return true;
    } else {
      return false;
    }
  }

  // 启用位置权限并执行操作
  static Future<bool> enableLocationPermissionAndDoAction(Function action) async {
    bool hasPermission = await hasLocationPermission();
    if (hasPermission) {
      action();
      return true;
    } else {
      return false;
    }
  }

  // 启用麦克风权限并执行操作
  static Future<bool> enableMicrophonePermissionAndDoAction(Function action) async {
    bool hasPermission = await hasMicrophonePermission();
    if (hasPermission) {
      action();
      return true;
    } else {
      return false;
    }
  }
}

/// 使用示例 检查相机权限并执行操作：
/// bool hasPermission = await PermissionUtils.hasCameraPermission();
/// if (hasPermission) {
///   // 执行相机相关操作
/// } else {
///   // 请求相机权限
///   bool granted = await PermissionUtils.requestPermission(Permission.camera);
///   if (granted) {
///     // 执行相机相关操作
///   } else {
///     // 提示用户权限未授予
///     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("相机权限被拒绝")));
///   }
/// }
///
///
/// 启用相机权限并执行操作：
///  bool result = await PermissionUtils.enableCameraPermissionAndDoAction(() {
///    // 执行相机操作
///  });
///  if (!result) {
///     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("相机权限未授予")));
///  }
///
///
/// 请求多个权限并处理：
/// Map<Permission, PermissionStatus> statusMap = await PermissionUtils.requestMultiplePermissions([
///   Permission.camera,
///   Permission.location,
/// ]);
///
/// if (statusMap[Permission.camera]!.isGranted && statusMap[Permission.location]!.isGranted) {
///   // 执行相机和位置相关操作
/// } else {
///   // 提示用户缺少必要权限
///   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("权限未授予")));
/// }