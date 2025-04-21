import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightTrendChart extends StatelessWidget {
  final List<double> weightData;

  const WeightTrendChart({Key? key, required this.weightData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.blueAccent)),
          minX: 0,
          maxX: weightData.length.toDouble() - 1,
          minY: weightData.reduce((a, b) => a < b ? a : b) - 5,
          maxY: weightData.reduce((a, b) => a > b ? a : b) + 5,
          lineBarsData: [
            LineChartBarData(
              spots: weightData.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (LineBarSpot touchedSpot) {
                // Example: Change tooltip color based on the y-value
                if (touchedSpot.y > 70) {
                  return Colors.red;
                } else if (touchedSpot.y > 60) {
                  return Colors.orange;
                } else {
                  return Colors.green;
                }
              },
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '体重: ${spot.y} kg\n',
                    TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}