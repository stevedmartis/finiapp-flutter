import 'package:finia_app/models/savind_dto.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'dart:math' as math;

class FinancialHealthDto {
  final double score; // Puntuación de 0 a 100
  final String
      status; // "Excelente", "Buena", "Regular", "En riesgo", "Crítica"
  final String message; // Mensaje personalizado según la puntuación
  final List<String> improvementTips; // Tips para mejorar
  final Map<String, double> categoryScores; // Puntuaciones por categoría

  FinancialHealthDto({
    required this.score,
    required this.status,
    required this.message,
    required this.improvementTips,
    required this.categoryScores,
  });

  // Método para crear a partir de los datos financieros
  factory FinancialHealthDto.calculate({
    required double totalIncome,
    required double totalExpenses,
    required double totalSavings,
    required double totalDebt,
    required List<TransactionDto> transactions,
    required List<SavingGoalDto> savingGoals,
  }) {
    // Inicializar puntuaciones por categoría
    Map<String, double> categoryScores = {
      'budget': 0,
      'savings': 0,
      'debt': 0,
      'spending': 0,
      'goals': 0,
    };

    // 1. Evaluar presupuesto (50/30/20)
    double budgetScore = 0;
    if (totalIncome > 0) {
      // Calcular porcentajes actuales
      double needsPercentage = 0;
      double wantsPercentage = 0;
      double savingsPercentage = 0;

      // ... cálculos basados en transacciones ...

      // Evaluar qué tan cerca está del ideal
      double budgetDeviation = ((needsPercentage - 50).abs() +
              (wantsPercentage - 30).abs() +
              (savingsPercentage - 20).abs()) /
          100;

      budgetScore = 100 * (1 - budgetDeviation);
    }
    categoryScores['budget'] = budgetScore;

    // 2. Evaluar ahorro
    double savingsScore = 0;
    if (totalIncome > 0) {
      double savingsRate = totalSavings / totalIncome;
      savingsScore =
          math.min(savingsRate * 500, 100); // 20% de ahorro = 100 puntos
    }
    categoryScores['savings'] = savingsScore;

    // 3. Evaluar deuda
    double debtScore = 0;
    if (totalIncome > 0) {
      double debtToIncomeRatio = totalDebt / totalIncome;
      debtScore = 100 * math.max(0, 1 - debtToIncomeRatio);
    }
    categoryScores['debt'] = debtScore;

    // 4. Evaluar patrones de gasto
    double spendingScore = totalIncome > 0
        ? 100 * math.max(0, 1 - (totalExpenses / totalIncome))
        : 0;
    categoryScores['spending'] = spendingScore;

    // 5. Evaluar progreso hacia metas
    double goalsScore = 0;
    if (savingGoals.isNotEmpty) {
      double totalProgress = savingGoals.fold(
          0,
          (sum, goal) =>
              sum + math.min(1, goal.currentAmount / goal.targetAmount));
      goalsScore = 100 * (totalProgress / savingGoals.length);
    }
    categoryScores['goals'] = goalsScore;

    // Calcular puntuación total (ponderada)
    double finalScore = (budgetScore * 0.25 +
        savingsScore * 0.25 +
        debtScore * 0.2 +
        spendingScore * 0.15 +
        goalsScore * 0.15);

    // Determinar estatus y mensaje
    String status;
    String message;
    List<String> tips = [];

    if (finalScore >= 80) {
      status = "Excelente";
      message = "¡Felicitaciones! Tu salud financiera es excelente. Sigue así.";
    } else if (finalScore >= 60) {
      status = "Buena";
      message =
          "Tu situación financiera es buena, pero aún hay espacio para mejorar.";
    } else if (finalScore >= 40) {
      status = "Regular";
      message = "Tu situación financiera necesita atención en algunas áreas.";
    } else if (finalScore >= 20) {
      status = "En riesgo";
      message =
          "Tu salud financiera está en riesgo. Es importante tomar medidas pronto.";
    } else {
      status = "Crítica";
      message = "Tu situación financiera requiere atención inmediata.";
    }

    // Generar tips personalizados basados en las categorías con menor puntuación
    List<MapEntry<String, double>> sortedScores = categoryScores.entries
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (var i = 0; i < math.min(3, sortedScores.length); i++) {
      var entry = sortedScores[i];
      switch (entry.key) {
        case 'budget':
          tips.add("Ajusta tus gastos para acercarte más al modelo 50/30/20");
          break;
        case 'savings':
          tips.add("Intenta aumentar tu tasa de ahorro mensual");
          break;
        case 'debt':
          tips.add(
              "Enfócate en reducir tus deudas para mejorar tu situación financiera");
          break;
        case 'spending':
          tips.add(
              "Revisa tus gastos recurrentes para identificar oportunidades de ahorro");
          break;
        case 'goals':
          tips.add(
              "Establece metas de ahorro realistas y haz aportes regulares");
          break;
      }
    }

    return FinancialHealthDto(
      score: finalScore,
      status: status,
      message: message,
      improvementTips: tips,
      categoryScores: categoryScores,
    );
  }
}
