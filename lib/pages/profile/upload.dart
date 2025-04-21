import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AvatarUpload extends StatefulWidget {
  const AvatarUpload({super.key});

  @override
  State<AvatarUpload> createState() => _AvatarUploadState();
}

class _AvatarUploadState extends State<AvatarUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('上传头像')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 上传头像逻辑
            SmartDialog.showLoading(msg: '头像上传中...');
            // 假设上传成功
            SmartDialog.dismiss();
            SmartDialog.showNotify(msg: '头像上传成功', notifyType: NotifyType.success);
            Navigator.pop(context);
          },
          child: Text('上传头像'),
        ),
      ),
    );
  }
}