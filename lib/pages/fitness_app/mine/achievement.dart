import 'package:flutter/material.dart';

class MyAchievementsView extends StatelessWidget {
  const MyAchievementsView({
    Key? key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '我的成就',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Achievement 1
            AchievementCard(
              achievementName: '10,000步挑战',
              description: '每日步数达成10,000步，获得金奖徽章。',
              progressPercentage: 1.0,  // 完成
              icon: Icons.star,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Achievement 2
            AchievementCard(
              achievementName: '力量训练达人',
              description: '完成了15次力量训练，获得银奖徽章。',
              progressPercentage: 0.8,  // 80% 完成
              icon: Icons.fitness_center,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Achievement 3
            AchievementCard(
              achievementName: '瑜伽大师',
              description: '完成了30次瑜伽课程，获得铜奖徽章。',
              progressPercentage: 0.6,  // 60% 完成
              icon: Icons.self_improvement,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String achievementName;
  final String description;
  final double progressPercentage;
  final IconData icon;
  final AnimationController animationController;
  final Animation<double> animation;

  const AchievementCard({
    Key? key,
    required this.achievementName,
    required this.description,
    required this.progressPercentage,
    required this.icon,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievementName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${(progressPercentage * 100).toStringAsFixed(0)}% 完成',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFavoritesView extends StatelessWidget {
  const MyFavoritesView({
    Key? key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '收藏与加油',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Favorite 1
            FavoriteCard(
              title: '跑步课程',
              description: '你收藏了“跑步初学者”课程。',
              icon: Icons.directions_run,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Favorite 2
            FavoriteCard(
              title: '力量训练',
              description: '你收藏了“全面力量训练”课程。',
              icon: Icons.fitness_center,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final AnimationController animationController;
  final Animation<double> animation;

  const FavoriteCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.orange,
                size: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyActivityView extends StatelessWidget {
  const MyActivityView({
    Key? key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '我的动态',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Activity 1
            ActivityCard(
              content: '你刚刚完成了“跑步初学者”挑战。',
              time: '1小时前',
              icon: Icons.directions_run,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Activity 2
            ActivityCard(
              content: '你点赞了“瑜伽挑战”课程。',
              time: '2小时前',
              icon: Icons.self_improvement,
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String content;
  final String time;
  final IconData icon;
  final AnimationController animationController;
  final Animation<double> animation;

  const ActivityCard({
    Key? key,
    required this.content,
    required this.time,
    required this.icon,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.purple,
                size: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
