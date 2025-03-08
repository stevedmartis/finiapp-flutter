import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.greenAccent,
              value: 40,
              title: 'Ingresos',
              radius: 40,
              titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.redAccent,
              value: 30,
              title: 'Gastos',
              radius: 40,
              titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.blueAccent,
              value: 30,
              title: 'Saldo Inicial',
              radius: 40,
              titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
