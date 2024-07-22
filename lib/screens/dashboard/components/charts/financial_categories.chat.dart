import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetedExpensesChart extends StatefulWidget {
  const BudgetedExpensesChart({super.key});
  @override
  BudgetedExpensesChartState createState() => BudgetedExpensesChartState();
}

class BudgetedExpensesChartState extends State<BudgetedExpensesChart> {
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
        90.0; // Asumiendo que cada ListTile tiene una altura de 72 pixels
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: themeProvider.getGradientCard(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Alinea el título a la izquierda
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gastos Presupuestados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.getSubtitleColor(),
              ),
            ),
          ),
          SfCircularChart(
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.scroll,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<BudgetItem, String>(
                dataSource: budgetItems,
                xValueMapper: (BudgetItem data, _) => data.category,
                yValueMapper: (BudgetItem data, _) => data.spent,
                pointColorMapper: (BudgetItem data, _) =>
                    getColorForCategory(data.category),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true,
                name: 'Gastos',
              )
            ],
          ),
          // Usamos un tamaño fijo para la lista basado en la cantidad de elementos
          SizedBox(
            height:
                listHeight, // Altura dinámica basada en la cantidad de elementos
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: budgetItems.length,
              itemBuilder: (context, index) {
                final item = budgetItems[index];
                double spentPercentage = (item.spent / item.budget) * 100;
                return ListTile(
                  leading: Icon(getIconForCategory(item.category),
                      color: getColorForCategory(item.category)),
                  title: Text(item.category,
                      style:
                          TextStyle(color: themeProvider.getSubtitleColor())),
                  subtitle: Text('Gastado: \$${item.spent} de \$${item.budget}',
                      style: TextStyle(color: Colors.grey[400])),
                  trailing: CircularProgressIndicator(
                    value: spentPercentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        spentPercentage > 100 ? Colors.red : Colors.green),
                  ),
                );
              },
            ),
          ),
        ],
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
      case 'Ocio':
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
      case 'Ocio':
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
      BudgetItem(category: 'Ocio', budget: 120, spent: 90),
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
