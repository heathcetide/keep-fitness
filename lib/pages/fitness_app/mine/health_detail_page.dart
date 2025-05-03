import 'package:flutter/material.dart';

import '../../introduction_animation/model/user_profile.dart';
class HealthDetailPage extends StatelessWidget {
  final UserProfileForm? profile;

  const HealthDetailPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康数据详情',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHealthCard(
                icon: Icons.accessibility_new,
                color: Colors.blue,
                children: [
                  _buildMetricItem(
                    '身高',
                    '${profile?.heightCm?.toStringAsFixed(1) ?? '--'} cm',
                    Icons.straighten,
                  ),
                  _buildMetricItem(
                    '体重',
                    '${profile?.weightKg?.toStringAsFixed(1) ?? '--'} kg',
                    Icons.monitor_weight,
                  ),
                  _buildMetricItem(
                    'BMI',
                    '${profile?.bmi?.toStringAsFixed(1) ?? '--'}',
                    Icons.calculate,
                    valueColor: _getBMIColor(profile?.bmi),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildHealthCard(
                icon: Icons.fitness_center,
                color: Colors.purple,
                children: [
                  _buildMetricItem(
                    '体脂率',
                    '${profile?.bodyFatPercent?.toStringAsFixed(1) ?? '--'}%',
                    Icons.pie_chart,
                  ),
                  _buildMetricItem(
                    '肌肉量',
                    '${profile?.muscleMass?.toStringAsFixed(1) ?? '--'} kg',
                    Icons.directions_run,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildHealthCard(
                icon: Icons.medical_services,
                color: Colors.green,
                children: [
                  _buildMetricItem(
                    '基础代谢',
                    '${profile?.bmr?.toStringAsFixed(0) ?? '--'} kcal',
                    Icons.local_fire_department,
                  ),
                  _buildMetricRow(
                    left: _buildMetricItem(
                      '腰围',
                      '${profile?.waistCm?.toStringAsFixed(1) ?? '--'} cm',
                      Icons.ad_units,
                    ),
                    right: _buildMetricItem(
                      '臀围',
                      '${profile?.hipCm?.toStringAsFixed(1) ?? '--'} cm',
                      Icons.ad_units,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  _getCardTitle(icon),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, IconData icon,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    )),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? Colors.blue.shade800,
                    )),
              ],
            ),
          ),
          if (_showTrendArrow(title))
            Icon(
              Icons.arrow_upward,
              color: Colors.red.shade400,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }

  // 辅助方法
  Color _getBMIColor(double? bmi) {
    if (bmi == null) return Colors.grey;
    if (bmi < 18.5) return Colors.orange;
    if (bmi < 24) return Colors.green;
    return Colors.red;
  }

  bool _showTrendArrow(String title) {
    // 添加实际趋势判断逻辑
    return title == '体重'; // 示例
  }

  String _getCardTitle(IconData icon) {
    return switch (icon) {
      Icons.accessibility_new => '身体指标',
      Icons.fitness_center => '体成分分析',
      Icons.medical_services => '健康测量',
      _ => '其他数据',
    };
  }
}