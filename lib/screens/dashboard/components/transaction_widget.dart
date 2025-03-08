import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Map<String, List<TransactionCreditCard>> groupTransactionsByDate(
    List<TransactionCreditCard> transactions) {
  Map<String, List<TransactionCreditCard>> grouped = {};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  for (var transaction in transactions) {
    final dateCurrent = DateFormat('EEEE, d', 'es_ES').format(transaction.date);
    final transactionDate = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);
    String key;

    if (transactionDate == today) {
      key = 'Hoy $dateCurrent';
    } else if (transactionDate == yesterday) {
      key = 'Ayer $dateCurrent';
    } else {
      key = dateCurrent;
    }

    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]?.add(transaction);
  }

  return grouped;
}

class TransactionsWidget extends StatelessWidget {
  final List<TransactionCreditCard> transactions;

  const TransactionsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    var groupedTransactions = groupTransactionsByDate(transactions);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: groupedTransactions.keys.length,
      itemBuilder: (context, index) {
        String key = groupedTransactions.keys.elementAt(index);
        List<TransactionCreditCard> tList = groupedTransactions[key]!;

        return _buildTransactionSection(key, tList);
      },
    );
  }

  // ✅ Sección agrupada por fecha
  Widget _buildTransactionSection(
      String date, List<TransactionCreditCard> transactions) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent, // Eliminar borde por defecto
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.grey[850],
        title: Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        children: transactions
            .map((transaction) => _buildTransactionItem(transaction))
            .toList(),
      ),
    );
  }

  // ✅ Componente para mostrar cada transacción
  Widget _buildTransactionItem(TransactionCreditCard transaction) {
    // 🔹 Mapeo de iconos por categoría
    final Map<String, IconData> categoryIcons = {
      "Comida": Icons.fastfood,
      "Transporte": Icons.directions_car,
      "Salud": Icons.health_and_safety,
      "Ocio": Icons.movie,
      "Educación": Icons.school,
      "Gasolina": Icons.local_gas_station,
      "Uber / Taxi": Icons.directions_car_filled,
      "Streaming": Icons.tv,
      "Hogar": Icons.home,
      "Mascota": Icons.pets,
      "Ropa": Icons.shopping_bag,
      "Videojuegos": Icons.sports_esports,
      "Gimnasio": Icons.fitness_center,
      "Regalos": Icons.card_giftcard,
      "Viajes": Icons.flight_takeoff,
      "Inversión": Icons.savings,
    };

    final bool isIncome = transaction.outAmount > 0;
    final IconData icon =
        categoryIcons[transaction.category] ?? Icons.help_outline;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Icono de la categoría
          CircleAvatar(
            backgroundColor: isIncome ? Colors.green[400] : Colors.red[400],
            radius: 20,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // 🔹 Título y fecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd-MM-yyyy').format(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Monto
          Text(
            "${isIncome ? '+' : '-'} ${formatCurrency(transaction.outAmount)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
