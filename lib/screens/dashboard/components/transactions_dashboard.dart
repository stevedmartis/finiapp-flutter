import 'package:finia_app/screens/dashboard/components/storage_info_card.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/models/transaction.model.dart';

class TransactionsDashBoardList extends StatelessWidget {
  final List<TransactionCreditCard> transactions;

  TransactionsDashBoardList({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionCreditCard lastTransaction = _getLastTransaction();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip
              .none, // Permite que los elementos del Stack se extiendan fuera de su vista
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: AmmountsInfoCard(
                key: lastTransaction.id,
                title: lastTransaction.description,
                svgSrc: lastTransaction.icon,
                amount: lastTransaction.outAmount.toString(),
                currency: lastTransaction.currency,
                date: lastTransaction.date,
              ),
            ),
            Positioned(
              right: 10, // Ajusta según la necesidad para alineación lateral
              bottom:
                  -12, // Posición negativa para poner el botón debajo de la tarjeta
              child: Container(
                width: 90, // Anchura ajustada para el texto "Ver más..."
                height: 30, // Altura adecuada para el contenido
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.circular(20), // Bordes redondeados
                    boxShadow: [
                      // Opcional: añade sombra para mejor visibilidad
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ]),
                alignment: Alignment.center,
                child: Text(
                  'Ver más',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  TransactionCreditCard _getLastTransaction() {
    if (transactions.isEmpty) {
      throw Exception('No transactions available');
    }
    // Ordena las transacciones por fecha y selecciona la última
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.first;
  }
}
