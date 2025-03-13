import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/utilis/format_currency.dart';

class BudgetedExpensesChart extends StatefulWidget {
  final List<TransactionDto> transactions;

  const BudgetedExpensesChart({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<BudgetedExpensesChart> createState() => _BudgetedExpensesChartState();
}

class _BudgetedExpensesChartState extends State<BudgetedExpensesChart> {
  // Categorías más completas
  static const List<String> _needsCategories = [
    'Comida',
    'Transporte',
    'Salud',
    'Educación',
    'Gasolina',
    'Uber / Taxi',
    'Hogar',
    'Mascota'
  ];

  static const List<String> _wantsCategories = [
    'Ocio',
    'Streaming',
    'Ropa',
    'Videojuegos',
    'Gimnasio',
    'Regalos',
    'Viajes'
  ];

  static const List<String> _savingsCategories = ['Ahorro'];

  // Método de categorización global
  String _getGlobalCategory(String category) {
    if (_needsCategories.contains(category)) return 'Necesidades';
    if (_wantsCategories.contains(category)) return 'Deseos';
    if (_savingsCategories.contains(category)) return 'Ahorros';
    return 'Otro';
  }

  // Método de construcción de resumen de transacciones
  Map<String, double> _buildSummaryFromTransactions(
      List<TransactionDto> transactions) {
    double totalNeeds = 0;
    double totalWants = 0;
    double totalSavings = 0;

    for (var transaction in transactions) {
      switch (_getGlobalCategory(transaction.category)) {
        case 'Necesidades':
          if (transaction.type == 'Gasto') totalNeeds += transaction.amount;
          break;
        case 'Deseos':
          if (transaction.type == 'Gasto') totalWants += transaction.amount;
          break;
        case 'Ahorros':
          // Solo sumar si es de tipo Ingreso
          if (transaction.type == 'Ingreso') totalSavings += transaction.amount;
          break;
      }
    }

    final totalDisponible =
        Provider.of<FinancialDataService>(context, listen: false)
            .getTotalDisponible(
                Provider.of<AccountsProvider>(context, listen: false));

    // Distribución por defecto si no hay transacciones
    if (totalNeeds == 0 && totalWants == 0 && totalSavings == 0) {
      totalNeeds = totalDisponible * 0.50;
      totalWants = totalDisponible * 0.30;
      totalSavings = totalDisponible * 0.20;
    }

    return {
      'Necesidades': totalNeeds,
      'Deseos': totalWants,
      'Ahorros': totalSavings,
    };
  }

  // Widget de elemento de categoría con diseño mejorado
  Widget _buildCategoryItem(
      String category, double value, double budget, bool isExceeded) {
    final percentage = budget > 0 ? (value / budget) * 100 : 0;
    final excess = value - budget;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isExceeded
                ? Colors.red.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Ícono de categoría
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getColorForCategory(category).withOpacity(0.2),
            ),
            child: Icon(
              _getIconForCategory(category),
              color: _getColorForCategory(category),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Detalles de la categoría
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: isExceeded ? Colors.redAccent : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' = ${formatCurrency(value)}',
                      style: TextStyle(
                        color: isExceeded
                            ? Colors.redAccent.withOpacity(0.7)
                            : Colors.grey,
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage > 100 ? 1 : percentage / 100,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(isExceeded
                      ? Colors.redAccent
                      : percentage > 90
                          ? Colors.orangeAccent
                          : Colors.greenAccent),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isExceeded ? Icons.warning_amber : Icons.check_circle,
                      color: isExceeded ? Colors.redAccent : Colors.greenAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isExceeded
                          ? 'Excedido por: ${formatCurrency(excess)}'
                          : 'Dentro del presupuesto',
                      style: TextStyle(
                        color:
                            isExceeded ? Colors.redAccent : Colors.greenAccent,
                        fontSize: 12,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return const Center(
        child: Text(
          'Sin datos para mostrar',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final currentTheme = Provider.of<ThemeProvider>(context);
    final totalIncome =
        Provider.of<FinancialDataService>(context, listen: false)
            .getTotalDisponible(
                Provider.of<AccountsProvider>(context, listen: false));

    final summary = _buildSummaryFromTransactions(widget.transactions);

    double totalSpent = widget.transactions
        .where((transaction) => transaction.type == "Gasto")
        .fold(0, (sum, transaction) => sum + transaction.amount);

    double budget = totalIncome;
    double spentPercentage = budget > 0 ? totalSpent / budget : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Distribución de gastos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: currentTheme.getSubtitleColor(),
            ),
          ),
        ),

        // Resto del código de construcción de la interfaz...
        // (mantendrías la estructura existente de la tarjeta de resumen y categorías)

        ...summary.entries.map((entry) {
          double budgetForCategory = _getBudgetForCategory(entry.key, budget);
          double percentage = budgetForCategory > 0
              ? (entry.value / budgetForCategory) * 100
              : 0;
          bool isExceeded = percentage > 100;

          return _buildCategoryItem(
            entry.key,
            entry.value,
            budgetForCategory,
            isExceeded,
          );
        }).toList(),
      ],
    );
  }

  // Métodos existentes de iconos y colores
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Necesidades':
        return Icons.shopping_cart;
      case 'Deseos':
        return Icons.star;
      case 'Ahorros':
        return Icons.savings;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Necesidades':
        return Colors.redAccent;
      case 'Deseos':
        return Colors.blueAccent;
      case 'Ahorros':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  double _getBudgetForCategory(String category, double budget) {
    switch (category) {
      case 'Necesidades':
        return budget * 0.50;
      case 'Deseos':
        return budget * 0.30;
      case 'Ahorros':
        return budget * 0.20;
      default:
        return 0;
    }
  }
}
