import 'dart:typed_data';

import 'package:demo_project/api/user_api.dart';
import 'package:demo_project/common/functions.dart';
import 'package:demo_project/common/page_scaffold.dart';
import 'package:demo_project/common/crop_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AvatarUpload extends StatefulWidget {
  const AvatarUpload({super.key});

  @override
  State<AvatarUpload> createState() => _AvatarUploadState();
}
class _AvatarUploadState extends State<AvatarUpload> {
  Uint8List? imageData = null;
  final ImageEditorController _editorController = ImageEditorController();
  bool _cropping = false;

  @override
  void initState() {
    super.initState();
    // 这里改成在合适的时机触发权限请求，比如在按钮点击时
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Text('上传头像'),
      leading: getPopLeading(context),
      customActions: [
        IconButton(
          icon: Text(
            "保存",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onPressed: () async {
            // 触发权限请求
            await requestPermissions();

            if (_cropping) {
              return;
            }
            _cropping = true;
            try {
              SmartDialog.showLoading(msg: "图片裁剪中");
              Uint8List? fileData =
                  (await cropImageDataWithNativeLibrary(_editorController)).data;
              final Uint8List compressedFileData =
              await getCompressedImage(fileData!, minHeight: 128, minWidth: 128, quality: 24);
              SmartDialog.showLoading(msg: "图片上传中");
              var resp = await UserApi().uploadAvatar(compressedFileData);
              print(resp);
              if (resp.code == 200) {
                await syncUserInfo();
                SmartDialog.dismiss();
                SmartDialog.showNotify(msg: '头像修改成功', notifyType: NotifyType.success);
                Navigator.maybePop(context);
                return;
              }
            } catch (e) {
              print(e);
            }
            SmartDialog.dismiss();
            SmartDialog.showNotify(msg: '头像上传失败', notifyType: NotifyType.failure);
            _cropping = false;
          },
        )
      ],
      child: imageData == null
          ? SizedBox()
          : Container(
        color: Colors.grey[600],
        child: ExtendedImage.memory(
          imageData!,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          enableLoadState: true,
          cacheRawData: true,
          initEditorConfigHandler: (ExtendedImageState? state) {
            return EditorConfig(
              maxScale: 20.0,
              cropRectPadding: const EdgeInsets.all(16.0),
              initCropRectType: InitCropRectType.imageRect,
              cropAspectRatio: CropAspectRatios.ratio1_1,
              controller: _editorController,
              editorMaskColorHandler: (context, pointerDown) {
                return pointerDown
                    ? Color.fromARGB(122, 0, 0, 0)
                    : Color.fromARGB(188, 0, 0, 0);
              },
            );
          },
        ),
      ),
    );
  }

  // 权限请求方法
  Future<void> requestPermissions() async {
    // 请求照片权限
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      print("照片权限已授予");
    } else if (status.isDenied) {
      print("照片权限被拒绝");
    } else if (status.isPermanentlyDenied) {
      print("照片权限被永久拒绝，请前往设置页面授权");
      openAppSettings();  // 引导用户去设置页面授权
    }

    // Android 10（API 29）及以上版本需要请求 MANAGE_EXTERNAL_STORAGE 权限
    if (await Permission.manageExternalStorage.isGranted) {
      print("外部存储管理权限已授予");
    } else {
      print("申请外部存储管理权限");
      PermissionStatus storagePermissionStatus = await Permission.manageExternalStorage.request();

      if (storagePermissionStatus.isPermanentlyDenied) {
        print("外部存储管理权限被永久拒绝，请前往设置页面授权");
        openAppSettings();  // 引导用户去设置页面授权
      } else if (storagePermissionStatus.isDenied) {
        print("外部存储管理权限被拒绝");
      } else if (storagePermissionStatus.isGranted) {
        print("外部存储管理权限已授予");
      }
    }
  }
}
