import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetedExpensesChart extends StatefulWidget {
  @override
  _BudgetedExpensesChartState createState() => _BudgetedExpensesChartState();
}

class _BudgetedExpensesChartState extends State<BudgetedExpensesChart> {
  late List<BudgetItem> budgetItems;

  @override
  void initState() {
    super.initState();
    budgetItems = getBudgetItems();
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos la altura de la lista basada en la cantidad de elementos
    double listHeight = budgetItems.length *
        72.0; // Asumiendo que cada ListTile tiene una altura de 72 pixels

    return Container(
      decoration: BoxDecoration(
        color: backgroundDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  PieSeries<BudgetItem, String>(
                    dataSource: budgetItems,
                    xValueMapper: (BudgetItem data, _) => data.category,
                    yValueMapper: (BudgetItem data, _) => data.spent,
                    pointColorMapper: (BudgetItem data, _) =>
                        getColorForCategory(data.category),
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                    name: 'Gastos',
                  )
                ],
              ),
            ),
            // Usamos un tamaño fijo para la lista basado en la cantidad de elementos
            Container(
              height:
                  listHeight, // Altura dinámica basada en la cantidad de elementos
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: budgetItems.length,
                itemBuilder: (context, index) {
                  final item = budgetItems[index];
                  double spentPercentage = (item.spent / item.budget) * 100;
                  return ListTile(
                    leading: Icon(getIconForCategory(item.category),
                        color: getColorForCategory(item.category)),
                    title: Text(item.category,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        'Gastado: \$${item.spent} de \$${item.budget}',
                        style: TextStyle(color: Colors.grey[400])),
                    trailing: CircularProgressIndicator(
                      value: spentPercentage / 100,
                      backgroundColor:
                          spentPercentage > 100 ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Alimentación':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.train;
      case 'Salud':
        return Icons.favorite;
      case 'Entretenimiento':
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'Alimentación':
        return Colors.yellow;
      case 'Transporte':
        return Colors.green;
      case 'Salud':
        return Colors.orange;
      case 'Entretenimiento':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<BudgetItem> getBudgetItems() {
    return [
      BudgetItem(category: 'Alimentación', budget: 200, spent: 150),
      BudgetItem(category: 'Transporte', budget: 100, spent: 75),
      BudgetItem(category: 'Salud', budget: 300, spent: 250),
      BudgetItem(category: 'Entretenimiento', budget: 120, spent: 90),
    ];
  }
}

class BudgetItem {
  final String category;
  final double budget;
  final double spent;

  BudgetItem(
      {required this.category, required this.budget, required this.spent});
}
