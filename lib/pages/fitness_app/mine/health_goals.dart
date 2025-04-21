import 'package:flutter/material.dart';

class HealthGoalsView extends StatelessWidget {
  const HealthGoalsView({
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
              '健康目标',  // Health Goals
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Goal 1
            GoalCard(
              goalName: '每日步数目标',
              progress: '7,500 步 / 10,000 步',
              progressPercentage: 0.75,  // 75% 达成
              goalUnit: '步',
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Goal 2
            GoalCard(
              goalName: '卡路里消耗目标',
              progress: '1,200 卡 / 2,000 卡',
              progressPercentage: 0.6,  // 60% 达成
              goalUnit: '卡路里',
              animationController: animationController!,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Goal 3
            GoalCard(
              goalName: '运动时长目标',
              progress: '45 分钟 / 60 分钟',
              progressPercentage: 0.75,  // 75% 达成
              goalUnit: '分钟',
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
class GoalCard extends StatelessWidget {
  final String goalName;
  final String progress;
  final double progressPercentage;
  final String goalUnit;
  final AnimationController animationController;
  final Animation<double> animation;

  const GoalCard({
    Key? key,
    required this.goalName,
    required this.progress,
    required this.progressPercentage,
    required this.goalUnit,
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
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goalName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '进度: $progress',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  // Ensure LinearProgressIndicator has proper width
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6), // Limit width
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '目标单位: $goalUnit',
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