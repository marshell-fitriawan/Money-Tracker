import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportDonutChart extends StatelessWidget {
  final double totalExp;
  final double totalInc;

  const ReportDonutChart({
    super.key,
    required this.totalExp,
    required this.totalInc,
  });

  @override
  Widget build(BuildContext context) {
    final double total = totalExp + totalInc;
    final double expPercent = total == 0 ? 0 : (totalExp / total) * 100;
    final double incPercent = total == 0 ? 0 : (totalInc / total) * 100;

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 70,
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: totalInc,
                  title: '${incPercent.toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  showTitle: true,
                ),
                PieChartSectionData(
                  color: Colors.redAccent,
                  value: totalExp,
                  title: '${expPercent.toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  showTitle: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
