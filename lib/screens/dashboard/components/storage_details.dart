import 'package:finia_app/models/transaction.model.dart';
import 'package:finia_app/screens/dashboard/components/transaction_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';

List<TransactionCreditCard> transactions = [
  TransactionCreditCard(
      id: '0',
      date: DateTime.now(),
      description: "Compra Galletas",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.cookie, color: Color.fromARGB(255, 253, 127, 0))),
  TransactionCreditCard(
      id: '1',
      date: DateTime.now(),
      description: "Compra en Supermercado",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.store, color: Color.fromARGB(255, 0, 162, 238))),
  TransactionCreditCard(
      id: '2',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: "Compra en Librería",
      inAmount: 0,
      outAmount: 30000,
      currency: "CLP",
      icon: Icon(Icons.book, color: Color.fromARGB(255, 250, 0, 0))),
  TransactionCreditCard(
      id: '3',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: "Compra en Librería",
      inAmount: 0,
      outAmount: 30000,
      currency: "CLP",
      icon: Icon(Icons.book, color: Color.fromARGB(255, 253, 127, 0))),
  TransactionCreditCard(
      id: '4',
      date: DateTime.now().subtract(Duration(days: 3)),
      description: "Compra Galletas",
      inAmount: 0,
      outAmount: 50000,
      currency: "CLP",
      icon: Icon(Icons.cookie, color: Color.fromARGB(255, 253, 127, 0))),
  // Agrega más transacciones según necesites
];

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Últimas Transacciones",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          SizedBox(height: defaultPadding),
          SizedBox(
            child: TransactionsWidget(
              transactions: transactions,
            ),
          ),
        ],
      ),
    );
  }
}
