import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/base_response_by_month/base_response_by_month.dart';

class ChartByMonth extends StatelessWidget {
  final List<BaseResponseByMonth> data;
  const ChartByMonth({required this.data, super.key});

  static const _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Maj',
    'Jun',
    'Jul',
    'Avg',
    'Sep',
    'Okt',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: TextLabelSmall('Nema podataka'));
    }

    final maxY = data
        .map((e) => e.result)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY * 1.2,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= data.length) return const SizedBox.shrink();
                final d = data[i];
                return Text(
                  '${_monthLabels[d.month - 1]}\n${d.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        barGroups: [
          for (var i = 0; i < data.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].result,
                  width: 16,
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
