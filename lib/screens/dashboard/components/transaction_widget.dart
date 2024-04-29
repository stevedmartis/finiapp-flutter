import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/dashboard/components/storage_info_card.dart';
import 'package:finia_app/widgets/custom_expansionTile.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Map<String, List<TransactionCreditCard>> groupTransactionsByDate(
    List<TransactionCreditCard> transactions) {
  Map<String, List<TransactionCreditCard>> grouped = {};
  final now = DateTime.now();
  final today =
      DateTime(now.year, now.month, now.day); // Ajusta 'hoy' al inicio del día.
  final yesterday = DateTime(
      now.year, now.month, now.day - 1); // Ajusta 'ayer' al inicio del día.

  for (var transaction in transactions) {
    final dateCurrent = DateFormat('EEEE, d', 'es_ES').format(transaction.date);
    final transactionDate = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction
            .date.day); // Ajusta la fecha de la transacción al inicio del día.
    String key;

    if (transactionDate == today) {
      key = 'Hoy ' + dateCurrent;
    } else if (transactionDate == yesterday) {
      key = 'Ayer ' + dateCurrent;
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

  TransactionsWidget({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupedTransactions = groupTransactionsByDate(transactions);

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: groupedTransactions.keys.length,
      itemBuilder: (context, index) {
        String key = groupedTransactions.keys.elementAt(index);
        List<TransactionCreditCard> tList = groupedTransactions[key]!;

        return CustomExpansionTile(
          title: key,
          children: tList
              .map((transaction) => StorageInfoCard(
                    title: transaction.description,
                    svgSrc: transaction.icon,
                    amount: transaction.outAmount.toString(),
                    currency: transaction.currency,
                    date: transaction.date,
                  ))
              .toList(),
        );
      },
    );
  }
}
