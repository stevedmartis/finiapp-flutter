import 'package:finia_app/screens/credit_card/credit_card_detail.dart';
import 'package:flutter/material.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';

class AccountsCardHorizontalList extends StatefulWidget {
  final List<CreditCard> accounts;

  const AccountsCardHorizontalList({Key? key, required this.accounts})
      : super(key: key);

  @override
  State<AccountsCardHorizontalList> createState() =>
      _CreditCardHorizontalListState();
}

class _CreditCardHorizontalListState extends State<AccountsCardHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: ClipRect(
          child: Row(
            children: widget.accounts.asMap().entries.map((entry) {
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
