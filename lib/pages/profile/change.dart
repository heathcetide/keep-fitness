import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ChangeNickName extends StatefulWidget {
  const ChangeNickName({super.key});

  @override
  State<ChangeNickName> createState() => _ChangeNickNameState();
}

class _ChangeNickNameState extends State<ChangeNickName> {
  TextEditingController _nickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _nickNameController.text = args['nickName'];

    return Scaffold(
      appBar: AppBar(title: Text('修改昵称')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nickNameController,
              autofocus: true,
              decoration: InputDecoration(labelText: '昵称', hintText: '请输入新的昵称'),
            ),
            ElevatedButton(
              onPressed: () async {
                String nickName = _nickNameController.text;
                if (nickName == args['nickName']) {
                  SmartDialog.showNotify(msg: '保存成功', notifyType: NotifyType.success);
                  Navigator.maybePop(context);
                  return;
                }
                SmartDialog.showLoading(msg: '等待响应中');
                // 保存逻辑
                // await updateNickName(nickName);
                SmartDialog.dismiss();
                SmartDialog.showNotify(msg: '保存成功', notifyType: NotifyType.success);
                Navigator.maybePop(context);
              },
              child: Text('保存更改'),
            ),
          ],
        ),
      ),
    );
  }
}