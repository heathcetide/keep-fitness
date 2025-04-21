import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoalSettingView extends StatelessWidget {
  final AnimationController animationController;

  const GoalSettingView({Key? key, required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slideIn = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(1.0, 1.2, curve: Curves.easeOut),
      ),
    );

    return SlideTransition(
      position: slideIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Set Your Goal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            TextField(decoration: InputDecoration(labelText: "Target Weight (kg)")),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Goal Duration (weeks)")),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Daily Calorie Goal")),
            SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: Text("Next")),
          ],
        ),
      ),
    );
  }
}
