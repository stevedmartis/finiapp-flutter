import 'dart:math';

import 'package:flutter/material.dart';
import 'package:finia_app/constants.dart';

// Enum for health status
enum HealthStatus {
  starting,
  unavailable,
  excellent,
  good,
  regular,
  atrisk,
  critical,
  warning,
  alert
}

// Class to encapsulate financial health information
class FinancialHealthStatus {
  final HealthStatus status;
  final Color color;
  final IconData icon;
  final String mainMessage;
  final String description;
  final List<String> tips;

  FinancialHealthStatus({
    required this.status,
    required this.color,
    required this.icon,
    required this.mainMessage,
    required this.description,
    required this.tips,
  });
}

class FinancialHealthCard extends StatelessWidget {
  final double? score;
  final String message;
  final List<String> tips;
  final double accountBalance;
  final double totalNeeds;
  final double totalWants;
  final double totalSavings;
  final VoidCallback? onAddTransactionPressed;

  const FinancialHealthCard({
    Key? key,
    this.score,
    required this.message,
    required this.tips,
    required this.accountBalance,
    required this.totalNeeds,
    required this.totalWants,
    required this.totalSavings,
    this.onAddTransactionPressed,
  }) : super(key: key);

  FinancialHealthStatus _getFinancialHealthStatus() {
    // Sin transacciones o datos insuficientes
    if (score == null) {
      if (accountBalance > 0) {
        return FinancialHealthStatus(
          status: HealthStatus.starting,
          color: logoCOLOR1,
          icon: Icons.rocket_launch_outlined,
          mainMessage: "Iniciando tu Viaje Financiero",
          description:
              "Estás dando los primeros pasos. Registra tus transacciones para una evaluación completa.",
          tips: [
            "Registra tus gastos mensuales",
            "Clasifica tus gastos por categorías",
            "Establece metas financieras iniciales",
            "Mantén un registro consistente"
          ],
        );
      }

      return FinancialHealthStatus(
        status: HealthStatus.unavailable,
        color: Colors.grey,
        icon: Icons.help_outline,
        mainMessage: "Información Insuficiente",
        description:
            "No hay datos suficientes para evaluar tu salud financiera.",
        tips: [
          "Vincula tus cuentas bancarias",
          "Registra tus primeros movimientos",
          "Configura tu presupuesto inicial"
        ],
      );
    }

    // Cálculo de presupuestos
    final double needsBudget = accountBalance * 0.5;
    final double wantsBudget = accountBalance * 0.3;
    final double savingsBudget = accountBalance * 0.2;

    // Verificaciones iniciales de exceso
    bool isNeedsExceeded = totalNeeds > (needsBudget * 1.3);
    bool isWantsExceeded = totalWants > (wantsBudget * 1.3);
    bool isSavingsInsufficient = totalSavings < (savingsBudget * 0.5);

    // Calcular el impacto del ingreso de ahorros en las otras categorías
    double remainingOverNeeds = totalNeeds - needsBudget;
    double remainingOverWants = totalWants - wantsBudget;

    // Si hay un ingreso de ahorro significativo
    if (totalSavings > savingsBudget) {
      double savingsExcess = totalSavings - savingsBudget;

      // Intentar compensar gastos excedidos
      if (remainingOverNeeds > 0) {
        double needsReduction = min(savingsExcess, remainingOverNeeds);
        remainingOverNeeds -= needsReduction;
        isNeedsExceeded = remainingOverNeeds > 0;
      }

      if (remainingOverWants > 0) {
        double wantsReduction = min(savingsExcess, remainingOverWants);
        remainingOverWants -= wantsReduction;
        isWantsExceeded = remainingOverWants > 0;
      }
    }

    // Escenarios de violación de presupuesto
    if (isNeedsExceeded && isWantsExceeded) {
      return FinancialHealthStatus(
        status: HealthStatus.critical,
        color: Colors.redAccent,
        icon: Icons.warning_amber_rounded,
        mainMessage: "Alerta Financiera Máxima",
        description:
            "Tus gastos en Necesidades y Deseos superan significativamente tu presupuesto.",
        tips: [
          "Congela gastos no esenciales inmediatamente",
          "Negocia reducción de gastos fijos",
          "Busca ingresos adicionales",
          "Crea un plan de emergencia financiera"
        ],
      );
    }

    if (isNeedsExceeded) {
      return FinancialHealthStatus(
        status: HealthStatus.critical,
        color: Colors.redAccent,
        icon: Icons.account_balance_wallet,
        mainMessage: "Gastos Esenciales Excedidos",
        description:
            "Tus gastos en Necesidades están superando el presupuesto planificado.",
        tips: [
          "Revisa gastos fijos urgentemente",
          "Busca alternativas más económicas",
          "Negocia servicios y contratos",
          "Considera fuentes de ingreso adicionales"
        ],
      );
    }

    if (isWantsExceeded) {
      return FinancialHealthStatus(
        status: HealthStatus.warning,
        color: Colors.orangeAccent,
        icon: Icons.shopping_cart,
        mainMessage: "Gastos Discrecionales Altos",
        description:
            "Tus gastos en Deseos están por encima del límite recomendado.",
        tips: [
          "Establece límites de gasto",
          "Prioriza gastos esenciales",
          "Busca alternativas de entretenimiento económicas",
          "Implementa un periodo de reflexión antes de compras"
        ],
      );
    }

    if (isSavingsInsufficient) {
      return FinancialHealthStatus(
        status: HealthStatus.alert,
        color: Colors.yellowAccent,
        icon: Icons.savings,
        mainMessage: "Ahorro Bajo",
        description: "Tus ahorros están por debajo del nivel recomendado.",
        tips: [
          "Automatiza transferencias de ahorro",
          "Reduce gastos discrecionales",
          "Busca formas de aumentar ingresos",
          "Establece metas de ahorro realistas"
        ],
      );
    }

    // Escenarios de ahorros extraordinarios
    if (totalSavings > (accountBalance * 1.5)) {
      return FinancialHealthStatus(
        status: HealthStatus.excellent,
        color: Colors.greenAccent,
        icon: Icons.rocket_outlined,
        mainMessage: "Ahorros Extraordinarios",
        description: "Has superado significativamente tu objetivo de ahorro.",
        tips: [
          "Felicitaciones por tu disciplina financiera",
          "Considera diversificar tus inversiones",
          "Explora opciones de inversión a largo plazo",
          "Evalúa metas financieras más ambiciosas"
        ],
      );
    }

    // Escenario crítico si ahorros exceden completamente el balance
    if (totalSavings > accountBalance * 2) {
      return FinancialHealthStatus(
        status: HealthStatus.warning,
        color: Colors.orangeAccent,
        icon: Icons.priority_high,
        mainMessage: "Ahorros Fuera de Contexto",
        description:
            "Tus ahorros superan significativamente tus ingresos totales.",
        tips: [
          "Verifica el origen de tus ahorros",
          "Asegúrate de que los montos sean correctos",
          "Revisa tus registros de transacciones",
          "Consulta con un asesor financiero"
        ],
      );
    }

    // Evaluación basada en puntuación
    final double nonNullScore = score!;

    if (nonNullScore >= 90) {
      return FinancialHealthStatus(
        status: HealthStatus.excellent,
        color: Colors.greenAccent,
        icon: Icons.star,
        mainMessage: "Maestro Financiero",
        description: "Tus finanzas son un ejemplo de excelencia y disciplina.",
        tips: [
          "Explora inversiones estratégicas",
          "Considera asesoría patrimonial",
          "Mantén tu estrategia de crecimiento",
          "Comparte tus conocimientos financieros"
        ],
      );
    } else if (nonNullScore >= 80) {
      return FinancialHealthStatus(
        status: HealthStatus.excellent,
        color: Colors.lightGreenAccent,
        icon: Icons.trending_up,
        mainMessage: "Salud Financiera Excelente",
        description:
            "Estás administrando tus finanzas de manera sobresaliente.",
        tips: [
          "Continúa tu disciplina financiera",
          "Diversifica tus inversiones",
          "Establece metas financieras a largo plazo",
          "Mantén tu estrategia de ahorro"
        ],
      );
    } else if (nonNullScore >= 70) {
      return FinancialHealthStatus(
        status: HealthStatus.good,
        color: Colors.lightGreenAccent,
        icon: Icons.check_circle,
        mainMessage: "Finanzas Sólidas",
        description: "Vas por buen camino con tu gestión financiera.",
        tips: [
          "Optimiza tus gastos",
          "Explora oportunidades de ahorro",
          "Revisa tu presupuesto periódicamente",
          "Mantén el impulso financiero"
        ],
      );
    } else if (nonNullScore >= 50) {
      return FinancialHealthStatus(
        status: HealthStatus.regular,
        color: Colors.yellowAccent,
        icon: Icons.bolt,
        mainMessage: "Potencial de Mejora",
        description:
            "Necesitas ajustar estrategias para fortalecer tus finanzas.",
        tips: [
          "Identifica gastos innecesarios",
          "Crea un presupuesto detallado",
          "Establece metas financieras claras",
          "Incrementa gradualmente tus ahorros"
        ],
      );
    } else if (nonNullScore >= 30) {
      return FinancialHealthStatus(
        status: HealthStatus.atrisk,
        color: Colors.orangeAccent,
        icon: Icons.warning,
        mainMessage: "Zona de Riesgo Financiero",
        description: "Tu situación financiera requiere atención inmediata.",
        tips: [
          "Realiza un corte de gastos urgente",
          "Busca asesoría financiera",
          "Genera plan de recuperación",
          "Explora fuentes de ingreso adicional"
        ],
      );
    } else {
      return FinancialHealthStatus(
        status: HealthStatus.critical,
        color: Colors.redAccent,
        icon: Icons.emergency,
        mainMessage: "Emergencia Financiera",
        description:
            "Es crucial tomar medidas correctivas de manera inmediata.",
        tips: [
          "Congela gastos no esenciales",
          "Busca asesoría financiera profesional",
          "Genera plan de emergencia",
          "Explora opciones de refinanciamiento"
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Debug - Valores para Salud Financiera:');
    print('Account Balance: $accountBalance');
    print('Total Needs: $totalNeeds');
    print('Total Wants: $totalWants');
    print('Total Savings: $totalSavings');
    final healthStatus = _getFinancialHealthStatus();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: healthStatus.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Icon(
                healthStatus.icon,
                color: healthStatus.color,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Salud Financiera',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: healthStatus.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getStatusText(healthStatus.status),
                  style: TextStyle(
                    color: healthStatus.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            healthStatus.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Tips Section
          const Text(
            'Tips para mejorar:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ...healthStatus.tips.map((tip) => _buildTipItem(tip)).toList(),

          // Add Transaction Button for Starting Status
          if (healthStatus.status == HealthStatus.starting &&
              onAddTransactionPressed != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Registrar Primera Transacción'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: logoCOLOR1,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onAddTransactionPressed,
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to get status text
  String _getStatusText(HealthStatus status) {
    switch (status) {
      case HealthStatus.starting:
        return "Comenzando";
      case HealthStatus.unavailable:
        return "No disponible";
      case HealthStatus.excellent:
        return "Excelente";
      case HealthStatus.good:
        return "Buena";
      case HealthStatus.regular:
        return "Regular";
      case HealthStatus.atrisk:
        return "En riesgo";
      case HealthStatus.critical:
        return "Crítica";
      case HealthStatus.warning:
        return "Advertencia";
      case HealthStatus.alert:
        return "Alerta";
    }
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
