import 'package:flutter/material.dart';

class RecentActivityView extends StatelessWidget {
  const RecentActivityView({
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
              '今天的活动',  // Today's Activity
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Activity 1
            ActivityCard(
              activityName: '晨跑',
              duration: '30 分钟',
              caloriesBurned: '300 卡路里',
              time: '早上 7:00',
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
              activityName: '力量训练',
              duration: '45 分钟',
              caloriesBurned: '450 卡路里',
              time: '下午 2:00',
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Activity 3
            ActivityCard(
              activityName: '瑜伽放松',
              duration: '15 分钟',
              caloriesBurned: '150 卡路里',
              time: '晚上 9:00',
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

// Card widget for each activity
class ActivityCard extends StatelessWidget {
  final String activityName;
  final String duration;
  final String caloriesBurned;
  final String time;
  final AnimationController animationController;
  final Animation<double> animation;

  const ActivityCard({
    Key? key,
    required this.activityName,
    required this.duration,
    required this.caloriesBurned,
    required this.time,
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
                Icons.fitness_center,
                color: Colors.blue,
                size: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '时长: $duration',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '消耗: $caloriesBurned',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '时间: $time',
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