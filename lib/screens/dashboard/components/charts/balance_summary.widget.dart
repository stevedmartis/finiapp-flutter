import 'package:finia_app/constants.dart'; // Asegúrate que secondaryColor está definido aquí
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BalanceSummary extends StatefulWidget {
  @override
  _BalanceSummaryState createState() => _BalanceSummaryState();
}

class _BalanceSummaryState extends State<BalanceSummary> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: secondaryColor, // Usar el color secundario como fondo
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saldo Total: \$5000',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  AnimatedRotation(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    turns: isExpanded ? 0.5 : 0.0, // Gira la flecha 180 grados
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Espacio entre título y contenido
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width:
                  MediaQuery.of(context).size.width * (isExpanded ? 0.9 : 0.8),
              height: isExpanded ? 340 : 0,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: isExpanded
                  ? SingleChildScrollView(child: _buildExpandedChart())
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedChart() {
    return SfCircularChart(
      backgroundColor: Colors.transparent, // Fondo transparente para el gráfico
      legend: Legend(
        isVisible: true,
        textStyle: TextStyle(color: Colors.white),
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: [
            ChartData('Ingresado', 7000),
            ChartData('Gastado', 2000),
            ChartData('Saldo Neto', 5000),
          ],
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, textStyle: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}
