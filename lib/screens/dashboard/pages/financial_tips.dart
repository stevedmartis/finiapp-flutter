import 'package:finia_app/models/financial_tip_dto.dart';
import 'package:flutter/material.dart';

class FinancialTipsWidget extends StatelessWidget {
  final List<FinancialTipDto> tips;

  const FinancialTipsWidget({
    Key? key,
    required this.tips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amberAccent,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Consejos para ti',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mostrar solo el primer consejo para no sobrecargar el dashboard
          _buildTipCard(tips.first),

          // Enlace para ver más si hay más de un consejo
          if (tips.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Ver más consejos',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipCard(FinancialTipDto tip) {
    Color tipColor;
    IconData tipIcon;

    // Asignar color e icono según el tipo de consejo
    switch (tip.type) {
      case 'saving':
        tipColor = Colors.greenAccent;
        tipIcon = Icons.savings;
        break;
      case 'spending':
        tipColor = Colors.redAccent;
        tipIcon = Icons.money_off;
        break;
      case 'investment':
        tipColor = Colors.blueAccent;
        tipIcon = Icons.trending_up;
        break;
      case 'alert':
        tipColor = Colors.orangeAccent;
        tipIcon = Icons.warning_amber;
        break;
      default:
        tipColor = Colors.purpleAccent;
        tipIcon = Icons.lightbulb_outline;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: tipColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tipColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              tipIcon,
              color: tipColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
