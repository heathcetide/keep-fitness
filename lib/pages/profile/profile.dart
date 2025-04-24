import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo_project/common/local_storage.dart';
import 'package:demo_project/widgets/bonss_avatar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:demo_project/api/user_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userInfo = {
    'avatar': '',
    'username': '加载中...',
    'email': '加载中...'
  };

  final List<Map<String, dynamic>> actions = [
    {'icon': Icons.settings, 'text': '软件设置', 'route': '/settings'},
    {'icon': AntDesign.heart_fill, 'text': '点赞列表', 'route': '/profile/likes'},
    {'icon': Icons.settings, 'text': '任务记录', 'route': '/profile/tasks'},
    {'icon': Icons.help, 'text': '问题反馈', 'route': '/profile/feedback'},
    {'icon': Icons.info, 'text': '关于软件', 'route': '/profile/about'}
  ];

  @override
  void initState() {
    super.initState();
    updateUserInfoFromLS();
  }

  Future updateUserInfoFromLS() async {
    var response = await UserApi().getUserInfoByToken();
    if (response.code == 200) {
      // // 将JSON数据解析为UserInfo对象
      // UserProfile user = UserProfile.fromJson(response.data);
      // // 更新UI状态
      // setState(() {
      //   userInfo['username'] = user.username;
      //   userInfo['avatar'] = user.avatarUrl;
      //   userInfo['email'] = user.email;
      // });
      // LocalStorage.user_avatar.set(user.avatarUrl);
      // LocalStorage.user_userName.set(user.username);
      // LocalStorage.user_email.set(user.email);
      // LocalStorage.user_activityCount.set(user.activityCount.toString());
      // LocalStorage.user_articleCount.set(user.articleCount.toString());
      // LocalStorage.user_points.set(user.points.toString());
      // LocalStorage.user_address.set(user.address);
      // LocalStorage.user_gender.set(user.gender.toString());
      // LocalStorage.user_phone.set(user.phone);
      // LocalStorage.user_bio.set(user.bio ?? '');
      // LocalStorage.user_birthday.set(user.birthday);
      // LocalStorage.user_createdAt.set(user.createdAt);
      // LocalStorage.user_lastLoginTime.set(user.lastLoginTime);
      // return;
    }

    // 如果网络请求失败，使用本地存储的默认值
    Map<String, dynamic> info = {
      'avatar': await LocalStorage.user_avatar.get() ?? 'default_avatar_url',
      'username': await LocalStorage.user_userName.get() ?? '软件犇码',
      'email': await LocalStorage.user_email.get() ?? '未设置邮箱',
    };
    setState(() {
      userInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 用户信息卡片
              _buildUserProfileCard(context),
              // 设置项列表
              _buildSettingsList(),
              // 退出与注销
              _buildLogoutButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // 用户信息卡片
  Widget _buildUserProfileCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 16),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile/myInformation');
        },
        padding: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 66,
                  height: 66,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Avatar(userInfo['avatar'], name: userInfo['username']),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      userInfo['username'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '邮箱: ${userInfo['email']}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 设置选项列表
  Widget _buildSettingsList() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: List.generate(actions.length, (index) {
          return ListTile(
            title: Text(actions[index]['text']),
            leading: Icon(actions[index]['icon']),
            onTap: () {
              Navigator.pushNamed(context, actions[index]['route']);
            },
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          );
        }),
      ),
    );
  }

  // 退出登录和注销按钮
  Widget _buildLogoutButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // 弹出确认对话框，确认注销账号
            _showConfirmDialog('确认注销账号吗？', '注销账号', _logoutAccount);
          },
          child: Text('注销账号', style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            // 弹出确认对话框，确认退出登录
            _showConfirmDialog('确认退出登录吗？', '退出登录', _logout);
          },
          child: Text('退出登录', style: TextStyle(fontSize: 18, color: Colors.orange)),
        ),
      ],
    );
  }

  // 弹出确认对话框
  void _showConfirmDialog(String message, String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(); // 执行确认操作
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }

  // 注销账号的操作
  void _logoutAccount() {
    // 执行注销账号逻辑
    print("账号已注销");
  }

  // 退出登录的操作
  void _logout() {
    // 执行退出登录逻辑
    Navigator.pushReplacementNamed(context, '/login');
  }
}