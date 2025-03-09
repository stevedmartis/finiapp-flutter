import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:finia_app/services/transaction_service.dart';

class TransactionsWidget extends StatelessWidget {
  final String accountId;

  const TransactionsWidget({
    super.key,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Obtener las transacciones desde el Provider
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final filteredTransactions =
        transactionProvider.getTransactionsByAccountId(accountId);

    if (filteredTransactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No hay transacciones recientes',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // ✅ Agrupar por fecha y mostrar secciones
    var groupedTransactions = _groupTransactionsByDate(filteredTransactions);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedTransactions.keys.length,
      itemBuilder: (context, index) {
        String key = groupedTransactions.keys.elementAt(index);
        List<TransactionDto> tList = groupedTransactions[key]!;

        return _buildTransactionSection(key, tList);
      },
    );
  }

  // ✅ Función para agrupar por fecha
  Map<String, List<TransactionDto>> _groupTransactionsByDate(
      List<TransactionDto> transactions) {
    Map<String, List<TransactionDto>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    for (var transaction in transactions) {
      // ✅ Convertir desde formato 'dd-MM-yyyy' a DateTime
      final transactionDate = DateFormat('dd-MM-yyyy').parse(transaction.date);

      final dateCurrent =
          DateFormat('EEEE, d', 'es_ES').format(transactionDate);

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

  // ✅ Sección agrupada por fecha
  Widget _buildTransactionSection(
      String date, List<TransactionDto> transactions) {
    if (transactions.isEmpty) return Container();

    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.only(bottom: 8),
      backgroundColor: Colors.transparent,
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
    );
  }

  // ✅ Componente para mostrar cada transacción
  Widget _buildTransactionItem(TransactionDto transaction) {
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

    final bool isIncome = transaction.type == "Ingreso";
    final IconData icon =
        categoryIcons[transaction.category] ?? Icons.help_outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1C1C1E),
            Color(0xFF2C2C2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
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
            radius: 24,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          // 🔹 Descripción y monto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateFormat('dd-MM-yyyy').parse(transaction.date),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Monto
          Text(
            "${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.greenAccent[400] : Colors.redAccent[400],
            ),
          ),
        ],
      ),
    );
  }
}
