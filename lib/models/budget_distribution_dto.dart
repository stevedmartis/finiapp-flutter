import 'package:finia_app/services/transaction_service.dart';

class BudgetDistributionDto {
  final double totalIncome;
  final double needsBudget; // 50% del ingreso
  final double wantsBudget; // 30% del ingreso
  final double savingsBudget; // 20% del ingreso

  final double needsSpent; // Gasto actual en necesidades
  final double wantsSpent; // Gasto actual en deseos
  final double savingsSpent; // Gasto actual en ahorros

  BudgetDistributionDto({
    required this.totalIncome,
    required this.needsSpent,
    required this.wantsSpent,
    required this.savingsSpent,
  })  : needsBudget = totalIncome * 0.5,
        wantsBudget = totalIncome * 0.3,
        savingsBudget = totalIncome * 0.2;

  // Calcular porcentajes actuales
  double get needsPercentage =>
      needsBudget > 0 ? (needsSpent / needsBudget) * 100 : 0;
  double get wantsPercentage =>
      wantsBudget > 0 ? (wantsSpent / wantsBudget) * 100 : 0;
  double get savingsPercentage =>
      savingsBudget > 0 ? (savingsSpent / savingsBudget) * 100 : 0;

  // Verificar si se están excediendo los presupuestos
  bool get isNeedsExceeded => needsSpent > needsBudget;
  bool get isWantsExceeded => wantsSpent > wantsBudget;
  bool get isSavingsExceeded => savingsSpent > savingsBudget;

  // Calcular cuánto queda disponible en cada categoría
  double get needsRemaining => needsBudget - needsSpent;
  double get wantsRemaining => wantsBudget - wantsSpent;
  double get savingsRemaining => savingsBudget - savingsSpent;

  // Método para crear desde transacciones
  factory BudgetDistributionDto.fromTransactions({
    required double totalIncome,
    required List<TransactionDto> transactions,
  }) {
    double needsSpent = 0;
    double wantsSpent = 0;
    double savingsSpent = 0;

    for (var transaction in transactions) {
      if (transaction.type == 'Gasto') {
        switch (_getCategoryType(transaction.category)) {
          case 'needs':
            needsSpent += transaction.amount;
            break;
          case 'wants':
            wantsSpent += transaction.amount;
            break;
          case 'savings':
            savingsSpent += transaction.amount;
            break;
        }
      }
    }

    return BudgetDistributionDto(
      totalIncome: totalIncome,
      needsSpent: needsSpent,
      wantsSpent: wantsSpent,
      savingsSpent: savingsSpent,
    );
  }

  // Método auxiliar para determinar el tipo de categoría
  static String _getCategoryType(String category) {
    final needs = [
      'Comida',
      'Salud',
      'Gasolina',
      'Transporte',
      'Arriendo',
      'Servicios',
      'Hogar'
    ];
    final wants = [
      'Ocio',
      'Videojuegos',
      'Streaming',
      'Ropa',
      'Mascotas',
      'Regalos',
      'Viajes'
    ];
    final savings = ['Ahorro', 'Inversión'];

    if (needs.contains(category)) return 'needs';
    if (wants.contains(category)) return 'wants';
    if (savings.contains(category)) return 'savings';

    return 'other';
  }
}
