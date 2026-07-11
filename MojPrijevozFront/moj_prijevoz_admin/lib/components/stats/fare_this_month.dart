import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/fares_this_month/fares_this_month_response.dart';

class FareThisMonthChart extends StatelessWidget {
  final List<FaresThisMonthResponse> data;
  const FareThisMonthChart({required this.data, super.key});

  static const _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty)
      return const Center(child: TextLabelSmall('Nema podataka'));

    final total = data.fold<int>(0, (sum, d) => sum + d.count);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                for (var i = 0; i < data.length; i++)
                  PieChartSectionData(
                    value: data[i].count.toDouble(),
                    color: _colors[i % _colors.length],
                    title:
                        '${(data[i].count / total * 100).toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < data.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        color: _colors[i % _colors.length],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${fareStatusMap[data[i].status]} (${data[i].count})',
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
