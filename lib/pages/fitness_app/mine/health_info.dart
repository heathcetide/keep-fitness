import 'package:demo_project/pages/introduction_animation/model/user_profile.dart';
import 'package:flutter/material.dart';
import '../../../api/user_api.dart';

class HealthInfoView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final UserProfileForm? profile;

  const HealthInfoView({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.height, '身高', '${profile?.heightCm?.toStringAsFixed(1)} cm'),
            _buildInfoRow(Icons.monitor_weight, '体重', '${profile?.weightKg?.toStringAsFixed(1)} kg'),
            _buildInfoRow(Icons.calculate, 'BMI', '${profile?.bmi?.toStringAsFixed(1)}'),
            _buildInfoRow(Icons.fitness_center, '体脂率', '${profile?.bodyFatPercent?.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, 
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                Text(value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateBMI() {
    if (profile?.heightCm == null || profile?.weightKg == null) return '--';
    final heightM = profile!.heightCm! / 100;
    final bmi = profile!.weightKg! / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }
} 