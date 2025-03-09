import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/utilis/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/finance_summary_service.dart';

class BudgetedExpensesChart extends StatefulWidget {
  final List<TransactionDto> transactions;

  const BudgetedExpensesChart({
    super.key,
    required this.transactions,
  });

  @override
  State<BudgetedExpensesChart> createState() => _BudgetedExpensesChartState();
}

class _BudgetedExpensesChartState extends State<BudgetedExpensesChart> {
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
    // ✅ Obtener el saldo total disponible desde FinancialDataService
    // ✅ Obtener el saldo total disponible desde FinancialDataService
    final totalIncome =
        Provider.of<FinancialDataService>(context, listen: false)
            .getTotalDisponible(
                Provider.of<AccountsProvider>(context, listen: false));

    final summary = _buildSummaryFromTransactions(widget.transactions);

    double totalSpent = widget.transactions
        .where((transaction) => transaction.type == "Gasto")
        .fold(0, (sum, transaction) => sum + transaction.amount);

// ✅ Eliminar duplicidad en el ingreso desde la transacción
    double savingsBudget = totalIncome * 0.20;

// ✅ Usar directamente totalIncome sin sumar savingsIncome
    double budget = totalIncome;
    double needsBudget = budget * 0.50;
    double wantsBudget = budget * 0.30;

    double spentPercentage = budget > 0 ? totalSpent / budget : 0;

// ✅ Estado de presupuesto
    String budgetStatus = spentPercentage > 1
        ? "Excedido del presupuesto"
        : spentPercentage > 0.9
            ? "Cerca del límite"
            : "Dentro del presupuesto";

    IconData statusIcon = spentPercentage > 1
        ? Icons.warning_amber
        : spentPercentage > 0.9
            ? Icons.error_outline
            : Icons.check_circle;

    Color statusColor = spentPercentage > 1
        ? Colors.redAccent
        : spentPercentage > 0.9
            ? Colors.orangeAccent
            : Colors.greenAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Título y descripción
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

        // ✅ Total Gastado, Presupuesto Total y Disponible
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Título y monto gastado
                    const Text(
                      'Total Gastado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatAbrevCurrency(totalSpent),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: totalSpent > budget
                            ? Colors.redAccent
                            : totalSpent == 0
                                ? Colors.grey
                                : Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ✅ Distribución Vertical de "Presupuesto Total" y "Disponible"
                    Row(
                      children: [
                        Icon(Icons.wallet, size: 18, color: Colors.grey[500]),
                        const SizedBox(width: 6),
                        Text(
                          'Presupuesto: ${formatAbrevCurrency(budget)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 18, color: Colors.greenAccent),
                        const SizedBox(width: 6),
                        Text(
                          'Disponible: ${formatAbrevCurrency(budget - totalSpent)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: budget - totalSpent < 0
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Estado (Dentro del presupuesto / Excedido)
                    Row(
                      children: [
                        Icon(
                          totalSpent > budget
                              ? Icons.warning_amber
                              : totalSpent == 0
                                  ? Icons.remove_circle_outline
                                  : Icons.check_circle,
                          color: totalSpent > budget
                              ? Colors.redAccent
                              : totalSpent == 0
                                  ? Colors.grey
                                  : Colors.greenAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          totalSpent > budget
                              ? 'Excedido del presupuesto'
                              : totalSpent == 0
                                  ? 'Sin gastos aún'
                                  : 'Dentro del presupuesto',
                          style: TextStyle(
                            color: totalSpent > budget
                                ? Colors.redAccent
                                : totalSpent == 0
                                    ? Colors.grey
                                    : Colors.greenAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ✅ Gráfico Circular
              const SizedBox(width: 16),
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: spentPercentage > 1 ? 1 : spentPercentage,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        totalSpent > budget
                            ? Colors.redAccent
                            : totalSpent == 0
                                ? Colors.grey
                                : Colors.greenAccent,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(spentPercentage * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: totalSpent > budget
                              ? Colors.redAccent
                              : totalSpent == 0
                                  ? Colors.grey
                                  : Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ✅ Detalle por categoría
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

  Widget _buildCategoryItem(
      String category, double value, double budget, bool isExceeded) {
    double percentage = budget > 0 ? (value / budget) * 100 : 0;
    double excess = value - budget;

    // ✅ Si el valor es mayor al 100%, limitar el porcentaje a 100
    percentage = percentage > 100 ? 100 : percentage;

    // ✅ Estado de la categoría
    String categoryStatus = isExceeded
        ? "Excedido por:"
        : percentage > 90
            ? "Cerca del límite"
            : "Dentro del presupuesto";

    IconData categoryIcon = isExceeded
        ? Icons.warning_amber
        : percentage > 90
            ? Icons.error_outline
            : Icons.check_circle;

    Color categoryColor = isExceeded
        ? Colors.redAccent
        : percentage > 90
            ? Colors.orangeAccent
            : Colors.greenAccent;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ Icono de categoría
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Porcentaje y valor de la categoría
                Text(
                  '${percentage.toStringAsFixed(0)}% = ${formatCurrency(value)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isExceeded
                        ? Colors.redAccent
                        : value > 0
                            ? Colors.white
                            : Colors.grey, // ✅ Si es 0, color gris
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // ✅ Barra de progreso (visible incluso si es 0)
                Container(
                  height: 8,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800], // ✅ Fondo gris
                  ),
                  child: FractionallySizedBox(
                    widthFactor: value > 0
                        ? (percentage / 100)
                        : 1, // ✅ Mostrar barra completa en gris si es 0
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isExceeded
                            ? Colors.red
                            : value > 0
                                ? (percentage > 90
                                    ? Colors.orangeAccent
                                    : Colors.greenAccent)
                                : const Color.fromARGB(
                                    255, 68, 66, 66), // ✅ Si es 0 → Gris
                      ),
                    ),
                  ),
                ),

                // ✅ Estado de la categoría (ícono + texto)
                Row(
                  children: [
                    Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categoryStatus,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 12,
                      ),
                    ),

                    // ✅ Mostrar solo si hay exceso
                    if (isExceeded)
                      Text(
                        " ${formatAbrevCurrency(excess)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _buildSummaryFromTransactions(
      List<TransactionDto> transactions) {
    double totalNeeds = 0;
    double totalWants = 0;
    double totalSavings = 0;

    for (var transaction in transactions) {
      if (transaction.type == 'Gasto') {
        switch (_getGlobalCategory(transaction.category)) {
          case 'Necesidades':
            totalNeeds += transaction.amount;
            break;
          case 'Deseos':
            totalWants += transaction.amount;
            break;
          case 'Ahorros':
            totalSavings += transaction.amount;
            break;
        }
      }
    }

    // ✅ Si no hay transacciones, usa el saldo inicial como base para la distribución
    final totalDisponible =
        Provider.of<FinancialDataService>(context, listen: false)
            .getTotalDisponible(
                Provider.of<AccountsProvider>(context, listen: false));

    // ✅ Si no hay gastos, asignar el saldo inicial a las categorías según la regla 50/30/20
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

  String _getGlobalCategory(String category) {
    const needs = ['Comida', 'Salud', 'Gasolina', 'Transporte'];
    const wants = ['Ocio', 'Videojuegos', 'Streaming', 'Ropa'];
    const savings = ['Ahorro'];

    if (needs.contains(category)) return 'Necesidades';
    if (wants.contains(category)) return 'Deseos';
    if (savings.contains(category)) return 'Ahorros';

    return 'Otro';
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
}
