
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileInfoView extends StatelessWidget {
  const ProfileInfoView({Key? key, this.animationController, this.animation}) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/supportIcon.png'),  // 用户头像
            ),
            SizedBox(height: 16),
            Text(
              '用户名',  // Username
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '简短的个人介绍...',  // Short bio
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}




