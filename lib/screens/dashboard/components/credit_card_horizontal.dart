import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CreditCardHorizontalList extends StatefulWidget {
  final List<CreditCard> cards;

  const CreditCardHorizontalList({Key? key, required this.cards})
      : super(key: key);

  @override
  State<CreditCardHorizontalList> createState() =>
      _CreditCardHorizontalListState();
}

class _CreditCardHorizontalListState extends State<CreditCardHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: ClipRect(
          child: Row(
            children: widget.cards.asMap().entries.map((entry) {
              int index = entry.key; // Get the index here
              CreditCard card = entry.value;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _handleCardTap(context, card, index);
                  },
                  child: Hero(tag: 'cardsHome-${card.cardNumber}', child: card),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, CreditCard card, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetail(card: card),
      ),
    );
  }
}
