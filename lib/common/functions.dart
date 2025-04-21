import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:demo_project/common/local_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:demo_project/api/user_api.dart';

final UserApi userApi = UserApi();

DateTime getZeroOclockOfDay(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

String padLeft(int num, [int length = 2, String fill = '0']) {
  return num.toString().padLeft(length, '0');
}

String getChineseStringByDatetime(DateTime dateTime, [DateTime? now]) {
  now ??= DateTime.now();
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    int min = now.hour * 60 + now.minute - dateTime.hour * 60 - dateTime.minute;
    if (min <= 1) return '刚刚';
    if (min < 60) return '$min分钟前';
    return '${now.hour - dateTime.hour}小时前';
  }
  int day =
      getZeroOclockOfDay(now).difference(getZeroOclockOfDay(dateTime)).inDays;
  if (day <= 0) return '未来(请检查本机系统时间)';
  if (day == 1)
    return '昨天${padLeft(dateTime.hour)}:${padLeft(dateTime.minute)}';
  if (day == 2) return '前天';
  if (day <= 7) {
    return '$day天前';
  }
  if (dateTime.year == now.year) {
    return '${padLeft(dateTime.month)}-${padLeft(dateTime.day)}';
  }
  return '${dateTime.year}-${padLeft(dateTime.month)}-${padLeft(dateTime.day)}';
}

Future<void> syncUserInfo() async {
  var resp = await userApi.getUserInfo();
}

Future<void> saveUserInfo(userInfo) async {
  clearMemoryImageCache();
  await clearDiskCachedImage(userInfo['user']['userAvatar']);
  await clearDiskCachedImage(userInfo['user']['userAvatar'] + '_original');
}

Future<void> saveNetworkImage(String imageUrl, context) async {
  if (Platform.isAndroid) {
    final bool suc = await requestStoragePermission();
    if (!suc) {
      SmartDialog.showNotify(msg: '请先授权存储权限', notifyType: NotifyType.error);
      return;
    }
  }
}

Future<bool> requestStoragePermission() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin();
  final AndroidDeviceInfo androidInfo = await info.androidInfo;
  final int androidVersion = int.parse(androidInfo.version.release);
  bool havePermission = false;
  if (androidVersion >= 13) {
    final request = await [Permission.videos, Permission.photos].request();

    havePermission = request.values.every(
      (status) => status == PermissionStatus.granted,
    );
  } else {
    final status = await Permission.storage.request();
    havePermission = status.isGranted;
  }
  if (!havePermission) {
    await openAppSettings();
  }
  return havePermission;
}

Future<Uint8List> getCompressedImage(
  Uint8List image, {
  minHeight = 1920,
  minWidth = 1920,
  quality = 88,
}) async {
  var result = await FlutterImageCompress.compressWithList(
    image,
    minHeight: minHeight,
    minWidth: minWidth,
    quality: quality,
  );
  return result;
}

///  示例：防抖用法
///   final debounceExample = () {
///     print('Debounced action triggered');
///   };
///   final debouncedFunction = debounceExample.debounce(1000); // 防抖 1000ms
///   debouncedFunction(); // 第一次触发
///   debouncedFunction(); // 第二次触发，前一次会被取消

// 扩展 `Function`，添加防抖（debounce）功能
extension DebounceExtension on Function {
  // 防抖功能：在调用后的 `milliseconds` 时间内，如果事件再次触发，则取消前一个调用。
  // 只有在指定的时间间隔没有触发事件时才会执行目标操作。
  void Function() debounce([int milliseconds = 500]) {
    Timer? _debounceTimer; // 定时器，用于取消上一次的调用并重新计时
    return () {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel(); // 如果定时器仍然活动，取消之前的调用
      _debounceTimer = Timer(Duration(milliseconds: milliseconds), () {
        this();
      }); // 设定新的定时器，并执行目标函数
    };
  }
}

/// 示例：节流用法
///final throttleExample = () {
///  print('Throttled action triggered');
///};
///final throttledFunction = throttleExample.throttle(2000); // 节流 2000ms
///throttledFunction(); // 第一次触发
///throttledFunction(); // 第二次触发，节流期间不会再次触发

// 扩展 `Function`，添加节流（throttle）功能
extension ThrottleExtension on Function {
  // 节流功能：在 `milliseconds` 时间内，只允许执行一次目标操作
  // 每隔设定的时间间隔执行一次函数。
  void Function() throttle([int milliseconds = 500]) {
    bool _isAllowed = true; // 标志位，判断是否允许函数执行
    Timer? _throttleTimer; // 定时器，用于控制执行频率
    return () {
      if (!_isAllowed) return; // 如果不允许执行，直接返回
      _isAllowed = false; // 设置标志位为不允许执行
      this(); // 执行目标函数
      _throttleTimer?.cancel(); // 取消上一次的定时器
      _throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
        _isAllowed = true; // 在指定时间后，允许执行函数
      });
    };
  }
}
