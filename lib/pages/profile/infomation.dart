import 'package:demo_project/common/local_storage.dart';
import 'package:demo_project/widgets/bonss_avatar.dart';
import 'package:flutter/material.dart';

class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  Map<String, dynamic> userInfo = {
    'username': '加载中...',
    'email': '加载中...',
    'phone': '加载中...',
    'address': '加载中...',
    'points': '加载中...',
    'articleCount': '加载中...',
    'activityCount': '加载中...',
    'avatarUrl': '',
    'gender': '加载中...',
    'bio': '加载中...',
    'birthday': '加载中...',
    'lastLoginTime': '加载中...',
    'createdAt': '加载中...',
  };

  @override
  void initState() {
    super.initState();
    updateUserInfoFromLS();
  }

  Future updateUserInfoFromLS() async {
    Map<String, dynamic> info = {
      'username': await LocalStorage.user_userName.get() ?? '未设置',
      'email': await LocalStorage.user_email.get() ?? '未设置',
      'phone': await LocalStorage.user_phone.get() ?? '未设置',
      'address': await LocalStorage.user_address.get() ?? '未设置',
      'points': await LocalStorage.user_points.get() ?? '0',
      'articleCount': await LocalStorage.user_articleCount.get() ?? '0',
      'activityCount': await LocalStorage.user_activityCount.get() ?? '0',
      'avatarUrl': await LocalStorage.user_avatar.get() ?? '',
      'gender': await LocalStorage.user_gender.get() ?? '未设置',
      'bio': await LocalStorage.user_bio.get() ?? '未设置',
      'birthday': await LocalStorage.user_birthday.get() ?? '未设置',
      'lastLoginTime': await LocalStorage.user_lastLoginTime.get() ?? '未设置',
      'createdAt': await LocalStorage.user_createdAt.get() ?? '未设置',
    };
    setState(() {
      userInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的信息')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 用户信息卡片
            _buildUserProfileCard(context),
            // 昵称修改
            _buildListTile('昵称', userInfo['username'], '/profile/changeNickName'),
            // 宿舍信息
            _buildListTile('地址', userInfo['address']),
            // 性别
            _buildListTile('性别', userInfo['gender']),
            // 联系方式
            _buildListTile('电话', userInfo['phone']),
            // 邮箱
            _buildListTile('邮箱', userInfo['email']),
            // 积分
            _buildListTile('积分', userInfo['points']),
            // 文章数
            _buildListTile('文章数', userInfo['articleCount']),
            // 活动数
            _buildListTile('活动数', userInfo['activityCount']),
            // 个人简介
            _buildListTile('个人简介', userInfo['bio']),
            // 生日
            _buildListTile('生日', userInfo['birthday']),
            // 最后登录时间
            _buildListTile('最后登录时间', userInfo['lastLoginTime']),
            // 注册时间
            _buildListTile('注册时间', userInfo['createdAt']),
            // 注销和退出按钮
            _buildLogoutButtons(),
          ],
        ),
      ),
    );
  }

  // 构建用户信息卡片
  Widget _buildUserProfileCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 16),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile/avatarUpload');
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
                  child: Avatar(userInfo['avatarUrl'], name: userInfo['username']),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo['username'] ?? '未设置',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
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

  // 构建列表项
  Widget _buildListTile(String title, String content, [String? route]) {
    return ListTile(
      title: Text(title),
      subtitle: Text(content),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: route != null
          ? () {
        Navigator.pushNamed(context, route, arguments: {'info': content});
      }
          : null,
    );
  }

  // 退出登录和注销按钮
  Widget _buildLogoutButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            print("注销账号");
          },
          child: Text('注销账号', style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text('退出登录', style: TextStyle(fontSize: 18, color: Colors.orange)),
        ),
      ],
    );
  }
}