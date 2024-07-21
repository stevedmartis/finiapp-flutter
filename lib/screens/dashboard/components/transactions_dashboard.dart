import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/models/transaction.model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsDashBoardList extends StatelessWidget {
  final List<TransactionCreditCard> transactions;

  const TransactionsDashBoardList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    TransactionCreditCard lastTransaction = _getLastTransaction();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dateFormat = DateFormat('dd-MM-yyyy');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Última Transacción',
            style: TextStyle(
              fontSize: defaultPadding,
              fontWeight: FontWeight.bold,
              color: themeProvider.getSubtitleColor(),
            ),
          ),
        ), */
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: themeProvider.getGradientCard(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cookie,
                    color: Colors.yellow,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastTransaction.category,
                        style: TextStyle(
                          color: themeProvider.getSubtitleColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(lastTransaction.outAmount.toDouble()),
                        style: TextStyle(
                          color: themeProvider.getSubtitleColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dateFormat.format(lastTransaction.date),
                        style: TextStyle(
                          color: themeProvider.getSubtitleColor(),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: logoCOLOR1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  TransactionCreditCard _getLastTransaction() {
    if (transactions.isEmpty) {
      throw Exception('No transactions available');
    }
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.first;
  }
}
